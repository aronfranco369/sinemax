import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_theme.dart';

class ActionBtn extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const ActionBtn({
    super.key,
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? SinemaxColors.blue : SinemaxColors.muted;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: SinemaxColors.panel,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active
                ? SinemaxColors.blue.withAlpha(90)
                : SinemaxColors.line,
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(label,
                style: SinemaxTextStyles.body(12,
                    weight: FontWeight.w500, color: color)),
          ],
        ),
      ),
    );
  }
}
