import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/connectivity_notifier.dart';
import '../theme/app_theme.dart';

/// Wraps the whole app (via `MaterialApp.builder`) and slides a floating toast
/// up from the bottom when connectivity changes: a red "you're offline" notice
/// when the link drops, and a teal "back online" confirmation when it returns.
///
/// It's anchored at the bottom (clear of the detail-screen video player at the
/// top) and auto-dismisses after a few seconds, so it never permanently covers
/// the player or the bottom navigation. Persistent offline state is still shown
/// in-context (the player slot and list-screen empty states).
class ConnectivityOverlay extends ConsumerStatefulWidget {
  final Widget child;
  const ConnectivityOverlay({super.key, required this.child});

  @override
  ConsumerState<ConnectivityOverlay> createState() => _ConnectivityOverlayState();
}

class _ConnectivityOverlayState extends ConsumerState<ConnectivityOverlay> {
  bool _visible = false;
  bool _online = true;
  Timer? _timer;

  void _flash({required bool online, required Duration duration}) {
    _timer?.cancel();
    setState(() {
      _online = online;
      _visible = true;
    });
    _timer = Timer(duration, () {
      if (mounted) setState(() => _visible = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(connectionStatusProvider, (prev, next) {
      if (prev == next) return;
      if (next == false) {
        _flash(online: false, duration: const Duration(seconds: 6));
      } else if (prev == false) {
        _flash(online: true, duration: const Duration(milliseconds: 2500));
      }
    });

    return Stack(
      children: [
        widget.child,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedSlide(
            offset: _visible ? Offset.zero : const Offset(0, 1.4),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            child: _Banner(online: _online),
          ),
        ),
      ],
    );
  }
}

class _Banner extends StatelessWidget {
  final bool online;
  const _Banner({required this.online});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.fromLTRB(12, 0, 12, bottomPad + 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: online ? [SinemaxColors.teal.withValues(alpha: 0.97), const Color(0xFF169B7C)] : [const Color(0xFFB3344C), SinemaxColors.red.withValues(alpha: 0.97)]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 14, offset: Offset(0, 4))],
        ),
        child: Row(
          children: [
            FaIcon(online ? FontAwesomeIcons.wifi : FontAwesomeIcons.triangleExclamation, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                online ? 'Intaneti imeunganishwa' : 'Haujaunganisha intaneti',
                style: SinemaxTextStyles.body(13, weight: FontWeight.w600, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Inline offline placeholder for content areas that need internet (empty
/// first-launch home, video player, etc.). Shows an icon, message and a
/// retry button that re-probes connectivity and runs [onRetry].
class OfflineNotice extends ConsumerWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  /// Compact layout for tight spaces like the 16:9 player slot.
  final bool compact;

  /// Override for non-connectivity problems (e.g. playback errors).
  final FaIconData icon;

  const OfflineNotice({super.key, this.title = 'You\'re offline', this.message = 'Connect to the internet to load new content.', this.onRetry, this.compact = false, this.icon = FontAwesomeIcons.triangleExclamation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconSize = compact ? 26.0 : 34.0;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? 12 : 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(compact ? 10 : 16),
              decoration: BoxDecoration(
                color: SinemaxColors.panel2,
                shape: BoxShape.circle,
                border: Border.all(color: SinemaxColors.line2),
              ),
              child: FaIcon(icon, color: SinemaxColors.muted, size: iconSize),
            ),
            SizedBox(height: compact ? 8 : 14),
            Text(title, style: SinemaxTextStyles.display(compact ? 16 : 20, weight: FontWeight.w700)),
            SizedBox(height: compact ? 2 : 6),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: SinemaxTextStyles.body(compact ? 11 : 13, color: SinemaxColors.muted),
            ),
            SizedBox(height: compact ? 8 : 16),
            GestureDetector(
              onTap: () async {
                final online = await ref.read(connectionStatusProvider.notifier).recheck();
                if (online) onRetry?.call();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 20, vertical: compact ? 6 : 9),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [SinemaxColors.blue, SinemaxColors.blueDeep]),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FaIcon(FontAwesomeIcons.arrowsRotate, color: Colors.white, size: 15),
                    const SizedBox(width: 6),
                    Text(
                      'Jaribu tena',
                      style: SinemaxTextStyles.body(12, weight: FontWeight.w700, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
