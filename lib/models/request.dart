import 'package:flutter/material.dart';

enum RequestStatus { added, reviewing, pending }

extension RequestStatusExt on RequestStatus {
  String get label {
    switch (this) {
      case RequestStatus.added:    return 'Added';
      case RequestStatus.reviewing: return 'Reviewing';
      case RequestStatus.pending:  return 'Pending';
    }
  }

  Color get color {
    switch (this) {
      case RequestStatus.added:    return const Color(0xFF22D3A6);
      case RequestStatus.reviewing: return const Color(0xFF2D8EFF);
      case RequestStatus.pending:  return const Color(0xFFF4C13B);
    }
  }

  String get note {
    switch (this) {
      case RequestStatus.added:    return 'Now on the app';
      case RequestStatus.reviewing: return 'Team is checking';
      case RequestStatus.pending:  return 'In the queue';
    }
  }
}

class ContentRequest {
  final String id;
  final String title;
  final String note;
  final RequestStatus status;
  final String date;

  const ContentRequest({
    required this.id,
    required this.title,
    this.note = '',
    required this.status,
    required this.date,
  });
}
