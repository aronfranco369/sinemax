import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class InfoChip extends StatelessWidget {
  final String label;

  /// Blue-tinted variant used to make a chip stand out (e.g. the media type).
  final bool accent;

  const InfoChip({super.key, required this.label, this.accent = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accent ? SinemaxColors.blue.withValues(alpha: 0.14) : SinemaxColors.panel2,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: accent ? SinemaxColors.blue.withValues(alpha: 0.55) : SinemaxColors.line, width: 0.5),
      ),
      child: Text(label,
          style: SinemaxTextStyles.body(12, weight: accent ? FontWeight.w600 : FontWeight.w400, color: accent ? SinemaxColors.blue : SinemaxColors.muted)),
    );
  }
}
