import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_notifier.g.dart';

/// Emits `true` when the device can actually reach the internet.
///
/// Combines connectivity_plus interface events (Wi-Fi/mobile toggles) with a
/// real reachability probe (TCP handshake to a public DNS server), so dead
/// Wi-Fi and captive portals are detected too. While offline it re-probes
/// every few seconds so the app recovers automatically when the connection
/// comes back — data notifiers listen to this to re-sync with Supabase.
@Riverpod(keepAlive: true)
class ConnectionStatus extends _$ConnectionStatus {
  StreamSubscription<List<ConnectivityResult>>? _sub;
  Timer? _retryTimer;
  bool _probing = false;

  @override
  bool build() {
    ref.onDispose(() {
      _sub?.cancel();
      _retryTimer?.cancel();
    });

    _sub = Connectivity().onConnectivityChanged.listen((results) {
      if (results.every((r) => r == ConnectivityResult.none)) {
        _setOnline(false);
      } else {
        recheck();
      }
    });

    // Start optimistic so cached-data UIs don't flash an offline banner on
    // every launch; the first probe corrects this within a few seconds.
    Future.microtask(recheck);
    return true;
  }

  /// Probes real internet reachability and updates state. Safe to call from
  /// retry buttons — concurrent calls coalesce into one probe.
  Future<bool> recheck() async {
    if (_probing) return state;
    _probing = true;
    try {
      _setOnline(await _probe());
    } finally {
      _probing = false;
    }
    return state;
  }

  void _setOnline(bool online) {
    if (state != online) state = online;
    _retryTimer?.cancel();
    if (!online) {
      // No interface event fires when a captive portal unlocks or a flaky
      // link heals — poll our way back online.
      _retryTimer = Timer(const Duration(seconds: 8), recheck);
    }
  }

  Future<bool> _probe() async {
    // Cloudflare then Google DNS — a raw TCP connect needs no DNS resolution,
    // so it can't be fooled by the OS resolver cache.
    for (final host in const ['1.1.1.1', '8.8.8.8']) {
      try {
        final socket = await Socket.connect(host, 53, timeout: const Duration(seconds: 4));
        socket.destroy();
        return true;
      } catch (_) {
        // Try the next host.
      }
    }
    return false;
  }
}
