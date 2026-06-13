import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:kitabu/screens/logo_animation.dart';

import '../data/providers.dart';
import '../models/media.dart';
import '../theme/app_theme.dart';
import '../widgets/sinemax_icon.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watched = ref.watch(recentProvider).length;
    final saved = ref.watch(savedProvider).length;
    final downloaded = ref.watch(downloadsProvider).values.where((r) => r.isCompleted).length;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnimatedSvgLogo())),
        backgroundColor: SinemaxColors.blue,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      backgroundColor: SinemaxColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: SinemaxColors.bg,
            pinned: true,
            title: Text('Profile', style: SinemaxTextStyles.display(22, weight: FontWeight.w700)),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AvatarCard(),
                  const SizedBox(height: 16),
                  _StatsRow(watched: watched, saved: saved, downloaded: downloaded),
                  const SizedBox(height: 16),
                  _SubscriptionCard(),
                  const SizedBox(height: 24),
                  Text(
                    'Settings',
                    style: SinemaxTextStyles.display(16, weight: FontWeight.w700, color: SinemaxColors.muted),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              const _SettingsTile(icon: 'bell', label: 'Notifications', trailing: _Toggle(on: true)),
              const _SettingsTile(icon: 'wifi', label: 'Download on Wi-Fi only', trailing: _Toggle(on: true)),
              const _SettingsTile(icon: 'quality', label: 'Video Quality', value: 'Auto'),
              const _SettingsTile(icon: 'globe', label: 'Language', value: 'English'),
              const _SettingsTile(icon: 'info', label: 'About Sinemax'),
              const _SettingsTile(icon: 'help', label: 'Help & Support'),
              const _RefreshDataTile(),
              const _LogoutTile(),
            ]),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _AvatarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SinemaxColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SinemaxColors.line, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [SinemaxColors.blue, SinemaxColors.blueBright], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text('AM', style: SinemaxTextStyles.display(22, weight: FontWeight.w800)),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amani Mushi', style: SinemaxTextStyles.display(18, weight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text('@amani', style: SinemaxTextStyles.body(13, color: SinemaxColors.muted)),
              const SizedBox(height: 2),
              Text('Member since Jan 2024', style: SinemaxTextStyles.body(12, color: SinemaxColors.muted2)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int watched;
  final int saved;
  final int downloaded;

  const _StatsRow({required this.watched, required this.saved, required this.downloaded});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatBox(label: 'Watched', value: '$watched'),
        const SizedBox(width: 10),
        _StatBox(label: 'Saved', value: '$saved'),
        const SizedBox(width: 10),
        _StatBox(label: 'Downloaded', value: '$downloaded'),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: SinemaxColors.panel,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: SinemaxColors.line, width: 0.5),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: SinemaxTextStyles.display(22, weight: FontWeight.w800, color: SinemaxColors.blue),
            ),
            const SizedBox(height: 2),
            Text(label, style: SinemaxTextStyles.body(12, color: SinemaxColors.muted)),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [SinemaxColors.blue.withAlpha(40), SinemaxColors.purple.withAlpha(30)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SinemaxColors.blue.withAlpha(60), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SinemaxIcon('crown', size: 18, color: SinemaxColors.gold),
              const SizedBox(width: 8),
              Text(
                'PREMIUM',
                style: SinemaxTextStyles.display(16, weight: FontWeight.w800, color: SinemaxColors.gold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: SinemaxColors.teal.withAlpha(30), borderRadius: BorderRadius.circular(6)),
                child: Text(
                  'Active',
                  style: SinemaxTextStyles.body(11, color: SinemaxColors.teal, weight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('TZS 5,000 / month', style: SinemaxTextStyles.body(14, weight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text('Renews Jul 1', style: SinemaxTextStyles.body(12, color: SinemaxColors.muted)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: ['Unlimited streaming', 'HD downloads', 'New releases']
                .map(
                  (perk) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SinemaxIcon('check', size: 12, color: SinemaxColors.teal),
                      const SizedBox(width: 4),
                      Text(perk, style: SinemaxTextStyles.body(12, color: SinemaxColors.muted)),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String icon;
  final String label;
  final String? value;
  final Widget? trailing;

  const _SettingsTile({required this.icon, required this.label, this.value, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: SinemaxColors.panel,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: SinemaxColors.line, width: 0.5),
      ),
      child: Row(
        children: [
          SinemaxIcon(icon, size: 20, color: SinemaxColors.muted),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: SinemaxTextStyles.body(14))),
          if (value != null) Text(value!, style: SinemaxTextStyles.body(13, color: SinemaxColors.muted2)),
          if (trailing != null) trailing!,
          if (trailing == null && value == null) const SinemaxIcon('chevR', size: 18, color: SinemaxColors.muted2),
        ],
      ),
    );
  }
}

class _Toggle extends StatefulWidget {
  final bool on;
  const _Toggle({required this.on});

  @override
  State<_Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<_Toggle> {
  late bool _on;

  @override
  void initState() {
    super.initState();
    _on = widget.on;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _on = !_on),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 22,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _on ? SinemaxColors.blue : SinemaxColors.panel2,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: _on ? SinemaxColors.blue : SinemaxColors.line2, width: 0.5),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: _on ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}

class _RefreshDataTile extends ConsumerStatefulWidget {
  const _RefreshDataTile();

  @override
  ConsumerState<_RefreshDataTile> createState() => _RefreshDataTileState();
}

class _RefreshDataTileState extends ConsumerState<_RefreshDataTile> {
  bool _busy = false;

  Future<void> _refresh() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      // Wipe the Supabase cache boxes so the notifiers re-pull everything.
      // Clearing `metadata` resets the sync watermarks, forcing a full fetch.
      await Future.wait([Hive.box<Media>('media_cache').clear(), Hive.box<MediaFile>('files_cache').clear(), Hive.box<bool>('files_fetched').clear(), Hive.box<String>('metadata').clear()]);

      // Rebuild the notifiers — with empty boxes they fetch fresh from the DB.
      ref.invalidate(mediaProvider);
      ref.invalidate(filesProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Library data refreshed from server')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Refresh failed: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _refresh,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: SinemaxColors.panel,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: SinemaxColors.line, width: 0.5),
        ),
        child: Row(
          children: [
            const SinemaxIcon('quality', size: 20, color: SinemaxColors.blue),
            const SizedBox(width: 14),
            Expanded(
              child: Text('Refresh Library Data', style: SinemaxTextStyles.body(14, color: SinemaxColors.blue)),
            ),
            if (_busy)
              const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(SinemaxColors.blue)))
            else
              const SinemaxIcon('chevR', size: 18, color: SinemaxColors.muted2),
          ],
        ),
      ),
    );
  }
}

class _LogoutTile extends StatelessWidget {
  const _LogoutTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: SinemaxColors.red.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: SinemaxColors.red.withAlpha(40), width: 0.5),
      ),
      child: Row(
        children: [
          const SinemaxIcon('logout', size: 20, color: SinemaxColors.red),
          const SizedBox(width: 14),
          Text('Log Out', style: SinemaxTextStyles.body(14, color: SinemaxColors.red)),
        ],
      ),
    );
  }
}
