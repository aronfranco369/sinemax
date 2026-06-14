import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Subscription engine for Sinemax.
///
/// Design (tables `profiles` + `subscriptions`):
/// - Identity is the `username` (`sinemax#####`), generated once per install by
///   the `create_profile()` RPC and stored in the `metadata` Hive box. It is the
///   single durable key: it never changes across payments, only on reinstall
///   (fresh generation) — and [restore] brings the original one back.
/// - `msisdn` is a *payment attribute*, not identity: the user may pay with any
///   provider number, so we just stamp the latest one onto their row. Subscribe
///   and renewal both look the row up by username; each repeat payment updates
///   the number and bumps `renewal_count`.
/// - `restore` (after a reinstall) is the only two-factor path: username + the
///   last-used number must both match the stored row, then this device adopts
///   that username.
/// - Entitlement = `status active/grace AND expires_at > now`.
///
/// NOTE: the actual charge is done later by the payment gateway. For now
/// [subscribe] writes the record straight from the client. When the
/// mobile-money callback lands, move that write server-side; the client should
/// then only ever read entitlement.

// ── Plans ──────────────────────────────────────────────────────────────────

enum SubPlan { wiki, mwezi }

extension SubPlanX on SubPlan {
  String get dbValue => name; // 'wiki' | 'mwezi'
  int get days => this == SubPlan.wiki ? 7 : 30;
  int get priceTsh => this == SubPlan.wiki ? 500 : 1500;

  /// Swahili name shown in the UI.
  String get swahili => this == SubPlan.wiki ? 'Wiki' : 'Mwezi';
  String get priceLabel => 'TZS ${priceTsh == 1500 ? '1,500' : priceTsh}';
  String get periodLabel => this == SubPlan.wiki ? 'siku 7' : 'siku 30';

  static SubPlan? fromDb(String? v) {
    switch (v) {
      case 'wiki':
        return SubPlan.wiki;
      case 'mwezi':
        return SubPlan.mwezi;
      default:
        return null;
    }
  }
}

/// User-facing (Swahili) error raised by [subscribe] / [restore].
class SubscriptionException implements Exception {
  final String message;
  const SubscriptionException(this.message);
  @override
  String toString() => message;
}

// ── State ──────────────────────────────────────────────────────────────────

class SubscriptionState {
  final String status; // 'free' | 'active' | 'grace' | 'expired'
  final String? username; // device identity (generated at install)
  final String? msisdn; // last number paid with
  final SubPlan? plan;
  final DateTime? expiresAt;
  final int renewalCount;

  const SubscriptionState({this.status = 'free', this.username, this.msisdn, this.plan, this.expiresAt, this.renewalCount = 0});

  static const free = SubscriptionState();

  bool get isActive => (status == 'active' || status == 'grace') && expiresAt != null && expiresAt!.isAfter(DateTime.now());

  /// Swahili status label for the UI.
  String get statusLabel {
    if (isActive) return 'Inatumika';
    if (status == 'free' || plan == null) return 'Mgeni';
    return 'Imeisha';
  }

  SubscriptionState copyWith({String? username}) => SubscriptionState(
    status: status,
    username: username ?? this.username,
    msisdn: msisdn,
    plan: plan,
    expiresAt: expiresAt,
    renewalCount: renewalCount,
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'username': username,
    'msisdn': msisdn,
    'plan': plan?.dbValue,
    'expires_at': expiresAt?.toUtc().toIso8601String(),
    'renewal_count': renewalCount,
  };

  factory SubscriptionState.fromJson(Map<String, dynamic> j) => SubscriptionState(
    status: j['status'] as String? ?? 'free',
    username: j['username'] as String?,
    msisdn: j['msisdn'] as String?,
    plan: SubPlanX.fromDb(j['plan'] as String?),
    expiresAt: DateTime.tryParse(j['expires_at']?.toString() ?? '')?.toLocal(),
    renewalCount: (j['renewal_count'] as num?)?.toInt() ?? 0,
  );

  /// Maps a Supabase `subscriptions` row to state.
  factory SubscriptionState.fromRow(Map<String, dynamic> r) => SubscriptionState(
    status: r['status'] as String? ?? 'free',
    username: r['username'] as String?,
    msisdn: r['msisdn'] as String?,
    plan: SubPlanX.fromDb(r['plan'] as String?),
    expiresAt: DateTime.tryParse(r['expires_at']?.toString() ?? '')?.toLocal(),
    renewalCount: (r['renewal_count'] as num?)?.toInt() ?? 0,
  );
}

// ── Phone normalization (Tanzania → E.164) ──────────────────────────────────

/// Normalizes Tanzanian input (`0712…`, `255712…`, `+255712…`, `712…`) to a
/// canonical `+255XXXXXXXXX`. Returns null if it isn't a plausible TZ mobile
/// number. Both writes and lookups go through this so they always match.
String? normalizeTzPhone(String input) {
  final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
  String? local; // the 9-digit subscriber part, starting 6 or 7
  if (digits.length == 12 && digits.startsWith('255')) {
    local = digits.substring(3);
  } else if (digits.length == 10 && digits.startsWith('0')) {
    local = digits.substring(1);
  } else if (digits.length == 9) {
    local = digits;
  }
  if (local == null || local.length != 9) return null;
  if (!(local.startsWith('6') || local.startsWith('7'))) return null;
  return '+255$local';
}

// ── Provider ─────────────────────────────────────────────────────────────────

final subscriptionProvider = AsyncNotifierProvider<SubscriptionNotifier, SubscriptionState>(SubscriptionNotifier.new);

class SubscriptionNotifier extends AsyncNotifier<SubscriptionState> {
  SupabaseClient get _db => Supabase.instance.client;
  Box<String> get _meta => Hive.box<String>('metadata');
  static const _kUser = 'username'; // durable device identity
  static const _kSub = 'subscription'; // cached subscription JSON

  @override
  Future<SubscriptionState> build() async {
    final username = await _ensureUsername();

    final raw = _meta.get(_kSub);
    var local = (raw == null || raw.isEmpty)
        ? SubscriptionState(username: username)
        : SubscriptionState.fromJson(jsonDecode(raw) as Map<String, dynamic>).copyWith(username: username);

    // Best-effort refresh so a renewal/expiry done elsewhere is reflected.
    // Offline failures keep the cached state as-is.
    if (username != null) {
      try {
        final row = await _findRow(username);
        if (row != null) {
          local = SubscriptionState.fromRow(row);
          await _persistSub(local);
        }
      } catch (_) {}
    }
    return local;
  }

  /// Returns this device's username, generating one via the `create_profile`
  /// RPC on first run. Offline first-run returns null and is retried next build.
  Future<String?> _ensureUsername() async {
    final existing = _meta.get(_kUser);
    if (existing != null && existing.isNotEmpty) return existing;
    try {
      final name = await _db.rpc('create_profile') as String;
      await _meta.put(_kUser, name);
      return name;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> _findRow(String username) async {
    return await _db.from('subscriptions').select().eq('username', username).maybeSingle();
  }

  Future<void> _persistSub(SubscriptionState s) async {
    if (s.status == 'free' || s.plan == null) {
      await _meta.delete(_kSub);
    } else {
      await _meta.put(_kSub, jsonEncode(s.toJson()));
    }
  }

  /// First purchase OR renewal, keyed by this device's [username]:
  /// - no record yet      → first subscribe (renewal_count 0).
  /// - record exists      → extend (carrying over unused days), stamp the new
  ///   payment number, and bump renewal_count. Covers "renew" and "pay again
  ///   with a different provider number" in one path.
  Future<void> subscribe({required String phone, required SubPlan plan}) async {
    final username = await _ensureUsername();
    if (username == null) {
      throw const SubscriptionException('Hakuna muunganisho wa intaneti. Tafadhali jaribu tena.');
    }
    final msisdn = normalizeTzPhone(phone);
    if (msisdn == null) {
      throw const SubscriptionException('Namba ya simu si sahihi.');
    }

    final now = DateTime.now();
    final row = await _findRow(username);
    late SubscriptionState result;

    if (row == null) {
      final expires = now.add(Duration(days: plan.days));
      final inserted = await _db
          .from('subscriptions')
          .insert({
            'username': username,
            'msisdn': msisdn,
            'status': 'active',
            'plan': plan.dbValue,
            'expires_at': expires.toUtc().toIso8601String(),
            'renewal_count': 0,
            'updated_at': now.toUtc().toIso8601String(),
          })
          .select()
          .single();
      result = SubscriptionState.fromRow(inserted);
    } else {
      final current = DateTime.tryParse(row['expires_at']?.toString() ?? '');
      final base = (current != null && current.isAfter(now)) ? current : now;
      final expires = base.add(Duration(days: plan.days));
      final updated = await _db
          .from('subscriptions')
          .update({
            'msisdn': msisdn,
            'status': 'active',
            'plan': plan.dbValue,
            'expires_at': expires.toUtc().toIso8601String(),
            'renewal_count': ((row['renewal_count'] as num?)?.toInt() ?? 0) + 1,
            'updated_at': now.toUtc().toIso8601String(),
          })
          .eq('username', username)
          .select()
          .single();
      result = SubscriptionState.fromRow(updated);
    }

    await _persistSub(result);
    state = AsyncData(result);
  }

  /// Reclaim a subscription after a reinstall. Two factors must match the stored
  /// row: the original [username] and the last number it paid with. On success
  /// this device adopts that username as its identity.
  Future<void> restore({required String phone, required String username}) async {
    final msisdn = normalizeTzPhone(phone);
    if (msisdn == null) {
      throw const SubscriptionException('Namba ya simu si sahihi.');
    }
    final name = username.trim();
    if (name.isEmpty) {
      throw const SubscriptionException('Tafadhali andika jina lako la mtumiaji.');
    }

    final row = await _findRow(name);
    if (row == null) {
      throw const SubscriptionException('Hakuna kifurushi kwa jina hili.');
    }
    if ((row['msisdn'] as String?) != msisdn) {
      throw const SubscriptionException('Namba na jina havilingani.');
    }
    final s = SubscriptionState.fromRow(row);
    if (!s.isActive) {
      throw const SubscriptionException('Kifurushi cha jina hili kimeisha.');
    }

    // Adopt the restored identity on this device.
    await _meta.put(_kUser, name);
    await _persistSub(s);
    state = AsyncData(s);
  }
}
