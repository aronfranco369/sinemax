import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class SinemaxSearchBar extends StatelessWidget {
  const SinemaxSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/search'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: SinemaxColors.panel2,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: SinemaxColors.line, width: 0.5),
              ),
              child: Text('Search movies, series...', style: SinemaxTextStyles.body(13, color: SinemaxColors.muted2)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => context.push('/search'),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: SinemaxColors.blue, borderRadius: BorderRadius.circular(8)),
            child: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
