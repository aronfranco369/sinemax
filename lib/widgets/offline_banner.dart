import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/connectivity_notifier.dart';
import '../theme/app_theme.dart';

/// Wraps the whole app (via `MaterialApp.builder`) and slides a banner in
/// from the top whenever the device loses internet. When the connection
/// returns it flashes a teal "Back online" confirmation, then hides.
/// Purely an overlay — never blocks interaction with cached/offline content.
class ConnectivityOverlay extends ConsumerStatefulWidget {
  final Widget child;
  const ConnectivityOverlay({super.key, required this.child});

  @override
  ConsumerState<ConnectivityOverlay> createState() => _ConnectivityOverlayState();
}

class _ConnectivityOverlayState extends ConsumerState<ConnectivityOverlay> {
  bool _showRestored = false;

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(connectionStatusProvider);

    ref.listen<bool>(connectionStatusProvider, (prev, next) {
      if (prev == false && next == true) {
        setState(() => _showRestored = true);
        Future.delayed(const Duration(milliseconds: 2500), () {
          if (mounted) setState(() => _showRestored = false);
        });
      }
    });

    final visible = !online || _showRestored;

    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AnimatedSlide(
            offset: visible ? Offset.zero : const Offset(0, -1.2),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            child: _Banner(online: online),
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
    final topPad = MediaQuery.of(context).padding.top;
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, topPad + 8, 16, 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: online ? [SinemaxColors.teal.withValues(alpha: 0.97), const Color(0xFF169B7C)] : [const Color(0xFFB3344C), SinemaxColors.red.withValues(alpha: 0.97)]),
          boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 12, offset: Offset(0, 3))],
        ),
        child: Row(
          children: [
            Icon(online ? Icons.wifi_rounded : Icons.wifi_off_rounded, color: Colors.white, size: 18),
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
  final IconData icon;

  const OfflineNotice({super.key, this.title = 'You\'re offline', this.message = 'Connect to the internet to load new content.', this.onRetry, this.compact = false, this.icon = Icons.wifi_off_rounded});

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
              child: Icon(icon, color: SinemaxColors.muted, size: iconSize),
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
                    const Icon(Icons.refresh_rounded, color: Colors.white, size: 15),
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
