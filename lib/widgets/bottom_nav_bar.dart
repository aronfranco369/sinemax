import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';

const _navItems = [
  (label: 'Home', icon: FontAwesomeIcons.house),
  (label: 'Discover', icon: FontAwesomeIcons.compass),
  (label: 'Requests', icon: FontAwesomeIcons.inbox),
  (label: 'Downloads', icon: FontAwesomeIcons.download),
  (label: 'Profile', icon: FontAwesomeIcons.user),
];

class SinemaxBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const SinemaxBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SinemaxColors.bg2,
        border: Border(top: BorderSide(color: SinemaxColors.line, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: List.generate(_navItems.length, (i) {
              final item = _navItems[i];
              final active = i == currentIndex;
              final color = active ? SinemaxColors.blue : SinemaxColors.muted2;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Underline indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        height: 2,
                        width: active ? 20 : 0,
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(color: SinemaxColors.blue, borderRadius: BorderRadius.circular(1)),
                      ),
                      FaIcon(item.icon, size: 20, color: color),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: SinemaxTextStyles.body(10, color: color, weight: active ? FontWeight.w600 : FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
