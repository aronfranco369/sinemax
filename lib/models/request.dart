import 'package:flutter/material.dart';

/// Mirrors the `status` check constraint on the Supabase `requests` table:
/// status = ANY (ARRAY['Sent', 'Received', 'Added']).
enum RequestStatus { sent, received, added }

extension RequestStatusExt on RequestStatus {
  /// Value as stored in Supabase.
  String get dbValue {
    switch (this) {
      case RequestStatus.sent:
        return 'Sent';
      case RequestStatus.received:
        return 'Received';
      case RequestStatus.added:
        return 'Added';
    }
  }

  /// Localized (Swahili) label shown in the UI.
  String get label {
    switch (this) {
      case RequestStatus.sent:
        return 'Imetumwa';
      case RequestStatus.received:
        return 'Imepokelewa';
      case RequestStatus.added:
        return 'Imeongezwa';
    }
  }

  Color get color {
    switch (this) {
      case RequestStatus.sent:
        return const Color(0xFFF4C13B); // gold
      case RequestStatus.received:
        return const Color(0xFF2D8EFF); // blue
      case RequestStatus.added:
        return const Color(0xFF22D3A6); // teal
    }
  }

  /// Fallback note when the row has no explicit `status_note`.
  String get note {
    switch (this) {
      case RequestStatus.sent:
        return 'In the queue';
      case RequestStatus.received:
        return 'Team is checking';
      case RequestStatus.added:
        return 'Now on the app';
    }
  }

  static RequestStatus fromDb(String? value) {
    switch (value) {
      case 'Received':
        return RequestStatus.received;
      case 'Added':
        return RequestStatus.added;
      case 'Sent':
      default:
        return RequestStatus.sent;
    }
  }
}

/// A content request, aligned with the Supabase `requests` table.
class ContentRequest {
  final String id;
  final String title;
  final String note;
  final String? type; // 'movie' | 'series'
  final String? dj;
  final String? userId;
  final RequestStatus status;
  final String? statusNote;
  final DateTime? createdAt;

  const ContentRequest({
    required this.id,
    required this.title,
    this.note = '',
    this.type,
    this.dj,
    this.userId,
    this.status = RequestStatus.sent,
    this.statusNote,
    this.createdAt,
  });

  factory ContentRequest.fromJson(Map<String, dynamic> json) {
    return ContentRequest(
      id: json['id'] as String,
      title: (json['title'] as String?) ?? '',
      note: (json['note'] as String?) ?? '',
      type: json['type'] as String?,
      dj: json['dj'] as String?,
      userId: json['user_id'] as String?,
      status: RequestStatusExt.fromDb(json['status'] as String?),
      statusNote: json['status_note'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  /// Payload for inserting a new request (id/status/timestamps are DB defaults).
  Map<String, dynamic> toInsert() {
    return {
      'title': title,
      'note': note,
      if (type != null) 'type': type,
      if (dj != null && dj!.isNotEmpty) 'dj': dj,
      if (userId != null) 'user_id': userId,
    };
  }

  /// Human-friendly note: prefer the DB `status_note`, fall back to the enum default.
  String get displayNote =>
      (statusNote != null && statusNote!.isNotEmpty) ? statusNote! : status.note;

  String get dateLabel {
    final d = createdAt;
    if (d == null) return '';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final local = d.toLocal();
    return '${months[local.month - 1]} ${local.day}, ${local.year}';
  }

  String get typeLabel {
    switch (type) {
      case 'movie':
        return 'Movie';
      case 'series':
        return 'Series';
      default:
        return '';
    }
  }
}
