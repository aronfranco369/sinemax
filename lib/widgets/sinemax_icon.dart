import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// SVG path data for each icon (24×24 viewBox, stroke-based, Lucide-style).
// Filled variants exist only for the five nav icons.

const _paths = <String, String>{
  'home': 'M3 9.5L12 3l9 6.5V20a1 1 0 01-1 1H14v-6h-4v6H4a1 1 0 01-1-1V9.5z',
  'home-filled': 'M3 9.5L12 3l9 6.5V20a1 1 0 01-1 1H14v-6h-4v6H4a1 1 0 01-1-1V9.5z',
  'compass': 'M12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10-4.477 10-10 10zm3.5-13.5l-5 2.5-2.5 5 5-2.5 2.5-5z',
  'compass-filled': 'M12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10-4.477 10-10 10zm3.5-13.5l-5 2.5-2.5 5 5-2.5 2.5-5z',
  'inbox': 'M4 4h16a1 1 0 011 1v14a1 1 0 01-1 1H4a1 1 0 01-1-1V5a1 1 0 011-1zm0 10h4a2 2 0 004 0h4',
  'inbox-filled': 'M4 4h16a1 1 0 011 1v14a1 1 0 01-1 1H4a1 1 0 01-1-1V5a1 1 0 011-1zm0 10h4a2 2 0 004 0h4',
  'bookmark': 'M6 3h12a1 1 0 011 1v17l-7-4-7 4V4a1 1 0 011-1z',
  'bookmark-filled': 'M6 3h12a1 1 0 011 1v17l-7-4-7 4V4a1 1 0 011-1z',
  'user': 'M12 12a4 4 0 100-8 4 4 0 000 8zm-8 8a8 8 0 1116 0H4z',
  'user-filled': 'M12 12a4 4 0 100-8 4 4 0 000 8zm-8 8a8 8 0 1116 0H4z',
  'search': 'M21 21l-4.35-4.35M17 11A6 6 0 115 11a6 6 0 0112 0z',
  'play': 'M5 3l14 9-14 9V3z',
  'pause': 'M6 4h3v16H6V4zm9 0h3v16h-3V4z',
  'download': 'M12 3v13m0 0l-4-4m4 4l4-4M3 20h18',
  'download-filled': 'M11 3h2v7h3l-4 5-4-5h3z M4 18h16v2H4z',
  'star': 'M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z',
  'chevR': 'M9 18l6-6-6-6',
  'chevD': 'M6 9l6 6 6-6',
  'x': 'M18 6L6 18M6 6l12 12',
  'plus': 'M12 5v14M5 12h14',
  'check': 'M20 6L9 17l-5-5',
  'bell': 'M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9m-4.27 13a2 2 0 01-3.46 0',
  'wifi': 'M5 12.55a11 11 0 0114.08 0M1.42 9a16 16 0 0121.16 0M8.53 16.11a6 6 0 016.95 0M12 20h.01',
  'globe': 'M12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10-4.477 10-10 10zm0 0c-2.5 0-4-4-4-10s1.5-10 4-10 4 4 4 10-1.5 10-4 10zM2 12h20',
  'info': 'M12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10-4.477 10-10 10zm0-9v5m0-8v1',
  'help': 'M12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10-4.477 10-10 10zm0-4h.01M9.09 9a3 3 0 015.83 1c0 2-3 3-3 3',
  'logout': 'M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4m7 14l5-5-5-5m5 5H9',
  'fullscreen': 'M8 3H5a2 2 0 00-2 2v3m18 0V5a2 2 0 00-2-2h-3m0 18h3a2 2 0 002-2v-3M3 16v3a2 2 0 002 2h3',
  'gear':
      'M12 15a3 3 0 100-6 3 3 0 000 6zm7.07-1.07l1.27-1.46a1 1 0 000-1.34l-1.27-1.46a9.1 9.1 0 00-.65-1.13l.27-1.9a1 1 0 00-.67-1.1l-1.83-.61a8.9 8.9 0 00-1-.65L14.5 3.6a1 1 0 00-1.26 0L11.77 4.8a9 9 0 00-1 .65l-1.83.6a1 1 0 00-.67 1.1l.27 1.9a9.1 9.1 0 00-.65 1.14L6.62 11.6a1 1 0 000 1.34l1.27 1.46c.17.38.4.74.65 1.13l-.27 1.9a1 1 0 00.67 1.1l1.83.61c.32.24.65.46 1 .65l1.47 1.22a1 1 0 001.26 0l1.47-1.22c.35-.19.68-.41 1-.65l1.83-.6a1 1 0 00.67-1.1l-.27-1.9c.25-.39.48-.75.65-1.14z',
  'clock': 'M12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10-4.477 10-10 10zm0-14v4l3 3',
  'trash': 'M3 6h18m-2 0v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a1 1 0 011-1h4a1 1 0 011 1v2',
  'crown': 'M3 17l3-9 6 5 6-5 3 9H3zm1 3h16',
  'quality': 'M9 3H5a2 2 0 00-2 2v4m6-6h10a2 2 0 012 2v4M9 3v18m0 0h10a2 2 0 002-2V9M9 21H5a2 2 0 01-2-2V9m0 0h18',
  'arrowL': 'M19 12H5m0 0l7 7m-7-7l7-7',
  'send': 'M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z',
  'list': 'M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01',
  'edit': 'M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z',
  'cast': 'M2 8V6a2 2 0 012-2h16a2 2 0 012 2v12a2 2 0 01-2 2h-6M2 12a9 9 0 019 9M2 16a5 5 0 015 5M2 20h.01',
  'volume': 'M11 5L6 9H2v6h4l5 4V5zm7.07 1.93a10 10 0 010 14.14M15.54 8.46a5 5 0 010 7.07',
  'sliders': 'M4 21v-7m0-4V3m8 18v-9m0-4V3m8 18v-5m0-4V3M1 14h6m2-6h6m2 7h6',
};

// Whether an icon should be rendered filled (solid) vs stroked outline.
// Only the five nav icons have meaningful filled variants.
const _filledIcons = {'home-filled', 'compass-filled', 'inbox-filled', 'bookmark-filled', 'download-filled', 'user-filled'};

class SinemaxIcon extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;

  const SinemaxIcon(this.name, {super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    final path = _paths[name] ?? _paths['x']!;
    final isFilled = _filledIcons.contains(name);
    final c = color ?? Theme.of(context).colorScheme.onSurface;

    return SvgPicture.string(
      '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="$size" height="$size"
            fill="${isFilled ? _hex(c) : 'none'}"
            stroke="${_hex(c)}"
            stroke-width="${isFilled ? 0 : 1.8}"
            stroke-linecap="round" stroke-linejoin="round">
        <path d="$path"/>
      </svg>''',
      width: size,
      height: size,
    );
  }

  static String _hex(Color c) {
    return '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}
