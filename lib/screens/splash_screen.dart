import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SinemaxColors.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo glyph pulse
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [SinemaxColors.blue, SinemaxColors.purple],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  'S',
                  style: SinemaxTextStyles.display(52, weight: FontWeight.w900),
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(
                  begin: 1.0,
                  end: 1.08,
                  duration: 900.ms,
                  curve: Curves.easeInOut,
                )
                .then()
                .shimmer(
                  duration: 1200.ms,
                  color: SinemaxColors.blueBright.withAlpha(80),
                ),

            const SizedBox(height: 28),

            // Wordmark
            Text(
              'SINEMAX',
              style: SinemaxTextStyles.display(38, weight: FontWeight.w900, color: SinemaxColors.ink),
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 600.ms)
                .slideY(begin: 0.2, end: 0, duration: 600.ms, curve: Curves.easeOut),

            const SizedBox(height: 6),

            Text(
              'Translated Movies & Series',
              style: SinemaxTextStyles.body(14, color: SinemaxColors.muted),
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
