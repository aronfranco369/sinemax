import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SinemaxColors {
  SinemaxColors._();

  static const bg = Color(0xFF050D1A);
  static const bg2 = Color(0xFF0A1628);
  static const panel = Color(0xFF0E1D33);
  static const panel2 = Color(0xFF11233D);

  // rgba(120,160,220, 0.14)  →  A=0x24, R=0x78, G=0xA0, B=0xDC
  static const line = Color(0x2478A0DC);
  // rgba(120,160,220, 0.26)  →  A=0x42
  static const line2 = Color(0x4278A0DC);

  static const blue = Color(0xFF2D8EFF);
  static const blueBright = Color(0xFF19C3FB);
  static const blueDeep = Color(0xFF1A6FE8);
  static const ink = Color(0xFFEAF2FF);
  static const muted = Color(0xFF8FA6C8);
  static const muted2 = Color(0xFF5E7298);
  static const gold = Color(0xFFF4C13B);
  static const red = Color(0xFFFF5D7A);
  static const orange = Color(0xFFFF8A3D);
  static const purple = Color(0xFF7C5CFF);
  static const teal = Color(0xFF22D3A6);

  // DJ accent colors
  static const djBlue = Color(0xFF2D8EFF);
  static const djCyan = Color(0xFF19C3FB);
  static const djPurple = Color(0xFF7C5CFF);
  static const djTeal = Color(0xFF22D3A6);
  static const djOrange = Color(0xFFFF8A3D);
  static const djPink = Color(0xFFFF5D7A);
  static const djGold = Color(0xFFF4C13B);
}

class SinemaxTextStyles {
  SinemaxTextStyles._();

  static TextStyle display(double size, {FontWeight weight = FontWeight.w800, Color color = SinemaxColors.ink}) {
    return GoogleFonts.barlowCondensed(fontSize: size, fontWeight: weight, color: color, letterSpacing: 0.5);
  }

  static TextStyle body(double size, {FontWeight weight = FontWeight.w400, Color color = SinemaxColors.ink}) {
    return GoogleFonts.dmSans(fontSize: size, fontWeight: weight, color: color);
  }
}

ThemeData buildSinemaxTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: SinemaxColors.bg,
    colorScheme: const ColorScheme.dark(primary: SinemaxColors.blue, secondary: SinemaxColors.blueBright, surface: SinemaxColors.panel, onSurface: SinemaxColors.ink),
    textTheme: GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme).apply(bodyColor: SinemaxColors.ink, displayColor: SinemaxColors.ink),
    iconTheme: const IconThemeData(color: SinemaxColors.ink),
    appBarTheme: AppBarTheme(
      backgroundColor: SinemaxColors.bg,
      foregroundColor: SinemaxColors.ink,
      elevation: 0,
      titleTextStyle: GoogleFonts.barlowCondensed(fontSize: 22, fontWeight: FontWeight.w700, color: SinemaxColors.ink, letterSpacing: 1),
    ),
    dividerColor: SinemaxColors.line,
    useMaterial3: true,
  );
}
