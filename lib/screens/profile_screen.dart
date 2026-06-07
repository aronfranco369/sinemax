import 'package:flutter/material.dart';
import '../data/local_data.dart';
import '../theme/app_theme.dart';
import '../widgets/sinemax_icon.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  // Avatar + name
                  _AvatarCard(),
                  const SizedBox(height: 16),

                  // Stats
                  _StatsRow(),
                  const SizedBox(height: 16),

                  // Subscription
                  _SubscriptionCard(),
                  const SizedBox(height: 24),

                  Text('Settings', style: SinemaxTextStyles.display(16, weight: FontWeight.w700, color: SinemaxColors.muted)),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // Settings list
          SliverList(
            delegate: SliverChildListDelegate([
              _SettingsTile(icon: 'bell',    label: 'Notifications',        trailing: _Toggle(on: true)),
              _SettingsTile(icon: 'wifi',    label: 'Download on Wi-Fi only', trailing: _Toggle(on: true)),
              _SettingsTile(icon: 'quality', label: 'Video Quality',        value: 'Auto'),
              _SettingsTile(icon: 'globe',   label: 'Language',             value: 'English'),
              _SettingsTile(icon: 'info',    label: 'About Sinemax'),
              _SettingsTile(icon: 'help',    label: 'Help & Support'),
              _LogoutTile(),
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
          // Avatar
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [SinemaxColors.blue, SinemaxColors.blueBright],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              profileInitials,
              style: SinemaxTextStyles.display(22, weight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profileName, style: SinemaxTextStyles.display(18, weight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(profileHandle, style: SinemaxTextStyles.body(13, color: SinemaxColors.muted)),
              const SizedBox(height: 2),
              Text(
                'Member since $profileMemberSince',
                style: SinemaxTextStyles.body(12, color: SinemaxColors.muted2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatBox(label: 'Watched',    value: '$statWatched'),
        const SizedBox(width: 10),
        _StatBox(label: 'Saved',      value: '$statSaved'),
        const SizedBox(width: 10),
        _StatBox(label: 'Downloaded', value: '$statDownloaded'),
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
            Text(value, style: SinemaxTextStyles.display(22, weight: FontWeight.w800, color: SinemaxColors.blue)),
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SinemaxColors.blue.withAlpha(40), SinemaxColors.purple.withAlpha(30)],
        ),
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
              Text(subPlan, style: SinemaxTextStyles.display(16, weight: FontWeight.w800, color: SinemaxColors.gold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: SinemaxColors.teal.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(subStatus, style: SinemaxTextStyles.body(11, color: SinemaxColors.teal, weight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(subPrice, style: SinemaxTextStyles.body(14, weight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text('Renews $subRenews', style: SinemaxTextStyles.body(12, color: SinemaxColors.muted)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: subPerks.map((perk) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SinemaxIcon('check', size: 12, color: SinemaxColors.teal),
                const SizedBox(width: 4),
                Text(perk, style: SinemaxTextStyles.body(12, color: SinemaxColors.muted)),
              ],
            )).toList(),
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

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
  });

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
          if (value != null)
            Text(value!, style: SinemaxTextStyles.body(13, color: SinemaxColors.muted2)),
          ?trailing,
          if (trailing == null)
            const SinemaxIcon('chevR', size: 18, color: SinemaxColors.muted2),
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoutTile extends StatelessWidget {
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
