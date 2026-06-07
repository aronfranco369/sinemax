import 'package:flutter/material.dart';

class Dj {
  final String id;
  final String name;
  final String country;
  final Color accent;
  final int titles;

  const Dj({
    required this.id,
    required this.name,
    required this.country,
    required this.accent,
    this.titles = 0,
  });

  String get initials => name.replaceFirst('DJ ', '').substring(0, 2).toUpperCase();
}
