import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_ce/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/providers.dart';
import '../data/subscription_notifier.dart';
import '../models/media.dart';
import '../theme/app_theme.dart';

const _kSwahiliMonths = ['Jan', 'Feb', 'Mac', 'Apr', 'Mei', 'Jun', 'Jul', 'Ago', 'Sep', 'Okt', 'Nov', 'Des'];

String _fmtDate(DateTime d) => '${d.day} ${_kSwahiliMonths[d.month - 1]} ${d.year}';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subAsync = ref.watch(subscriptionProvider);
    final sub = subAsync.value ?? SubscriptionState.free;

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
                  _IdentityCard(sub: sub),
                  const SizedBox(height: 16),
                  if (sub.isActive) _ActiveCard(sub: sub) else const _PlansCard(),
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
              const _SettingsTile(icon: FontAwesomeIcons.gauge, label: 'Video Quality', value: 'Auto'),
              const _SettingsTile(icon: FontAwesomeIcons.globe, label: 'Lugha', value: 'English'),
              _SettingsTile(icon: FontAwesomeIcons.circleInfo, label: 'Kuhusu Sinemax', onTap: () => _showAboutSheet(context)),
              _SettingsTile(icon: FontAwesomeIcons.circleQuestion, label: 'Msaada', onTap: () => _showHelpSheet(context)),
              const _RefreshDataTile(),
            ]),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// ── Identity ─────────────────────────────────────────────────────────────────

class _IdentityCard extends StatelessWidget {
  final SubscriptionState sub;
  const _IdentityCard({required this.sub});

  String get _initials {
    final name = sub.username?.trim() ?? '';
    if (name.length < 2) return 'SX';
    return name.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final active = sub.isActive;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SinemaxColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SinemaxColors.line, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [SinemaxColors.blue, SinemaxColors.blueBright], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(_initials, style: SinemaxTextStyles.display(22, weight: FontWeight.w800)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sub.username?.trim().isNotEmpty == true ? sub.username!.trim() : 'Mgeni',
                  style: SinemaxTextStyles.display(19, weight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(sub.msisdn ?? 'Hujajiunga bado', style: SinemaxTextStyles.body(13, color: SinemaxColors.muted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: (active ? SinemaxColors.teal : SinemaxColors.muted2).withAlpha(30), borderRadius: BorderRadius.circular(8)),
            child: Text(
              sub.statusLabel,
              style: SinemaxTextStyles.body(11, weight: FontWeight.w600, color: active ? SinemaxColors.teal : SinemaxColors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Active subscription ───────────────────────────────────────────────────────

class _ActiveCard extends StatelessWidget {
  final SubscriptionState sub;
  const _ActiveCard({required this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [SinemaxColors.blue.withAlpha(45), SinemaxColors.purple.withAlpha(32)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SinemaxColors.blue.withAlpha(70), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.crown, size: 18, color: SinemaxColors.gold),
              const SizedBox(width: 8),
              Text(
                'Kifurushi cha ${sub.plan?.swahili ?? ''}',
                style: SinemaxTextStyles.display(17, weight: FontWeight.w800, color: SinemaxColors.gold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(color: SinemaxColors.teal.withAlpha(30), borderRadius: BorderRadius.circular(7)),
                child: Text(
                  'Inatumika',
                  style: SinemaxTextStyles.body(11, color: SinemaxColors.teal, weight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (sub.expiresAt != null) Text('Inaisha tarehe ${_fmtDate(sub.expiresAt!)}', style: SinemaxTextStyles.body(14, weight: FontWeight.w500)),
          if (sub.renewalCount > 0) ...[const SizedBox(height: 2), Text('Umehuisha mara ${sub.renewalCount}', style: SinemaxTextStyles.body(12, color: SinemaxColors.muted))],
          const SizedBox(height: 16),
          _PrimaryButton(
            label: 'Ongeza muda',
            icon: FontAwesomeIcons.crown,
            onTap: () => _showSubscriptionSheet(context, plan: sub.plan ?? SubPlan.mwezi),
          ),
        ],
      ),
    );
  }
}

// ── Plans (not subscribed) ──────────────────────────────────────────────────

class _PlansCard extends StatelessWidget {
  const _PlansCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SinemaxColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SinemaxColors.line, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.crown, size: 18, color: SinemaxColors.gold),
              const SizedBox(width: 8),
              Text('Jiunge SINEMAX', style: SinemaxTextStyles.display(18, weight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Tazama filamu na sizoni zote bila kikomo.', style: SinemaxTextStyles.body(13, color: SinemaxColors.muted)),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _PlanTile(plan: SubPlan.wiki)),
                const SizedBox(width: 12),
                Expanded(child: _PlanTile(plan: SubPlan.mwezi)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _showSubscriptionSheet(context, plan: null),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: SinemaxColors.panel2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: SinemaxColors.line2, width: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(FontAwesomeIcons.arrowRotateLeft, size: 14, color: SinemaxColors.blue),
                  const SizedBox(width: 8),
                  Text(
                    'Tayari una kifurushi? Rejesha',
                    style: SinemaxTextStyles.body(13, color: SinemaxColors.ink, weight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  final SubPlan plan;
  const _PlanTile({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [SinemaxColors.blue.withAlpha(55), SinemaxColors.purple.withAlpha(40)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SinemaxColors.blue.withAlpha(90), width: 1),
      ),
      child: Column(
        children: [
          Text(plan.swahili, style: SinemaxTextStyles.display(18, weight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(
            plan.priceLabel,
            style: SinemaxTextStyles.display(22, weight: FontWeight.w800, color: SinemaxColors.blueBright),
          ),
          const SizedBox(height: 2),
          Text('kwa ${plan.periodLabel}', style: SinemaxTextStyles.body(11, color: SinemaxColors.muted)),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => _showSubscriptionSheet(context, plan: plan),
            child: Container(
              width: double.infinity,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [SinemaxColors.blue, SinemaxColors.blueBright], begin: Alignment.centerLeft, end: Alignment.centerRight),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Lipia',
                style: SinemaxTextStyles.display(15, weight: FontWeight.w800, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Subscribe / Restore sheet ─────────────────────────────────────────────────

/// [plan] null → restore mode; otherwise pay/extend for that plan.
void _showSubscriptionSheet(BuildContext context, {required SubPlan? plan}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _SubscriptionSheet(plan: plan),
  );
}

class _SubscriptionSheet extends ConsumerStatefulWidget {
  final SubPlan? plan;
  const _SubscriptionSheet({required this.plan});

  @override
  ConsumerState<_SubscriptionSheet> createState() => _SubscriptionSheetState();
}

class _SubscriptionSheetState extends ConsumerState<_SubscriptionSheet> {
  final _phone = TextEditingController();
  final _name = TextEditingController();
  bool _busy = false;
  String? _error;

  bool get _isRestore => widget.plan == null;

  @override
  void dispose() {
    _phone.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final notifier = ref.read(subscriptionProvider.notifier);
    try {
      if (_isRestore) {
        await notifier.restore(phone: _phone.text, username: _name.text);
      } else {
        await notifier.subscribe(phone: _phone.text, plan: widget.plan!);
      }
      if (!mounted) return;
      final username = ref.read(subscriptionProvider).value?.username;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_isRestore ? 'Kifurushi chako kimerejeshwa.' : 'Karibu! Jina lako la mtumiaji ni $username. Tafadhali lihifadhi.')));
    } on SubscriptionException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'Imeshindikana. Tafadhali jaribu tena.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final title = _isRestore ? 'Rejesha kifurushi' : 'Lipa kifurushi cha ${plan!.swahili}';
    final cta = _isRestore ? 'Rejesha' : 'Lipa ${plan!.priceLabel}';

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: SinemaxColors.bg2,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(color: SinemaxColors.line2, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Text(title, style: SinemaxTextStyles.display(20, weight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(_isRestore ? 'Weka namba na jina ulilotumia kujiunga.' : 'Utalipa kupitia M-Pesa, Tigo Pesa au Airtel Money.', style: SinemaxTextStyles.body(13, color: SinemaxColors.muted)),
            const SizedBox(height: 18),
            _Field(controller: _phone, label: 'Namba ya simu', hint: '07XX XXX XXX', keyboardType: TextInputType.phone),
            if (_isRestore) ...[
              const SizedBox(height: 12),
              _Field(controller: _name, label: 'Jina la mtumiaji', hint: 'sinemax00000'),
            ] else ...[
              const SizedBox(height: 14),
              Builder(
                builder: (context) {
                  final username = ref.watch(subscriptionProvider).value?.username;
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: SinemaxColors.panel,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: SinemaxColors.blue.withAlpha(70), width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.idCard, size: 18, color: SinemaxColors.blue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kumbukumbu ya jina (Tafadhari kumbuka)',
                                style: SinemaxTextStyles.body(11, color: SinemaxColors.muted, weight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                username ?? '...',
                                style: SinemaxTextStyles.display(18, weight: FontWeight.w800, color: SinemaxColors.ink),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
            if (_error != null) ...[const SizedBox(height: 12), Text(_error!, style: SinemaxTextStyles.body(13, color: SinemaxColors.red))],
            const SizedBox(height: 20),
            _PrimaryButton(label: cta, busy: _busy, onTap: _submit),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  const _Field({required this.controller, required this.label, required this.hint, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: SinemaxTextStyles.body(12, color: SinemaxColors.muted, weight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: SinemaxTextStyles.body(15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: SinemaxTextStyles.body(14, color: SinemaxColors.muted2),
            filled: true,
            fillColor: SinemaxColors.panel,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: SinemaxColors.line, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: SinemaxColors.blue, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final FaIconData? icon;
  final bool busy;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, this.icon, this.busy = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: busy ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [SinemaxColors.blue, SinemaxColors.blueBright], begin: Alignment.centerLeft, end: Alignment.centerRight),
          borderRadius: BorderRadius.circular(14),
        ),
        child: busy
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[FaIcon(icon!, size: 18, color: Colors.white), const SizedBox(width: 8)],
                  Text(
                    label,
                    style: SinemaxTextStyles.display(17, weight: FontWeight.w800, color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Settings (unchanged behaviour) ─────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({required this.icon, required this.label, this.value, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: SinemaxColors.panel,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: SinemaxColors.line, width: 0.5),
        ),
        child: Row(
          children: [
            FaIcon(icon, size: 18, color: SinemaxColors.muted),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: SinemaxTextStyles.body(14))),
            if (value != null) Text(value!, style: SinemaxTextStyles.body(13, color: SinemaxColors.muted2)),
            if (trailing != null) trailing!,
            if (trailing == null && value == null) const FaIcon(FontAwesomeIcons.chevronRight, size: 16, color: SinemaxColors.muted2),
          ],
        ),
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Taarifa zimesasishwa kutoka seva')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imeshindikana: $e')));
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: SinemaxColors.line, width: 0.5),
        ),
        child: Row(
          children: [
            const FaIcon(FontAwesomeIcons.arrowsRotate, size: 18, color: SinemaxColors.blue),
            const SizedBox(width: 14),
            Expanded(
              child: Text('Sasisha Taarifa', style: SinemaxTextStyles.body(14, color: SinemaxColors.blue)),
            ),
            if (_busy)
              const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(SinemaxColors.blue)))
            else
              const FaIcon(FontAwesomeIcons.chevronRight, size: 16, color: SinemaxColors.muted2),
          ],
        ),
      ),
    );
  }
}

// ── Contact details (replace with the real SINEMAX channels) ─────────────────

const _kSupportPhone = '+255712000000'; // dialer + call
const _kSupportWhatsApp = '255712000000'; // wa.me wants no '+'
const _kSupportEmail = 'msaada@sinemax.app';
const _kSupportInstagram = 'https://instagram.com/sinemax';

Future<void> _launch(BuildContext context, Uri uri) async {
  try {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Imeshindikana kufungua. Hakikisha programu husika ipo.')));
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Imeshindikana kufungua.')));
    }
  }
}

// ── About overlay (Kuhusu Sinemax) ───────────────────────────────────────────

void _showAboutSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, controller) => _SheetShell(
        child: ListView(
          controller: controller,
          padding: EdgeInsets.zero,
          children: [
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.circleInfo, size: 20, color: SinemaxColors.blue),
                const SizedBox(width: 8),
                Text('Kuhusu SINEMAX', style: SinemaxTextStyles.display(20, weight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'SINEMAX ni jukwaa la kutazama na kupakua filamu, sizoni na tamthlia '
              'zilizotafsiriwa kwa Kiswahili na DJ mbalimbali wa Tanzania.',
              style: SinemaxTextStyles.body(14, color: SinemaxColors.muted),
            ),
            const SizedBox(height: 10),
            Text(
              'Tunakuletea burudani bora sehemu moja — filamu mpya, sizoni,  '
              'tamthlia, na kazi za DJ unaowapenda, popote ulipo na wakati wowote.',
              style: SinemaxTextStyles.body(14, color: SinemaxColors.muted),
            ),
            const SizedBox(height: 20),
            Text('Kwa nini SINEMAX?', style: SinemaxTextStyles.display(15, weight: FontWeight.w700)),
            const SizedBox(height: 10),
            ...const [
              'Filamu na sizoni zilizotafsiriwa kwa Kiswahili',
              'Pakua na utazame bila intaneti (offline)',
              'Maudhui mapya huongezwa mara kwa mara',
              'Omba filamu unayoitaka kupitia ukurasa wa Agiza',
            ].map(
              (t) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FaIcon(FontAwesomeIcons.check, size: 15, color: SinemaxColors.teal),
                    const SizedBox(width: 10),
                    Expanded(child: Text(t, style: SinemaxTextStyles.body(14))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text('Toleo 1.0.0', style: SinemaxTextStyles.body(12, color: SinemaxColors.muted2)),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

// ── Help / Contacts overlay (Msaada) ──────────────────────────────────────────

void _showHelpSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _SheetShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Wasiliana Nasi', style: SinemaxTextStyles.display(20, weight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('Tupo tayari kukusaidia. Chagua njia yoyote hapa chini.', style: SinemaxTextStyles.body(13, color: SinemaxColors.muted)),
          const SizedBox(height: 18),
          _ContactRow(
            icon: FontAwesomeIcons.whatsapp,
            tint: SinemaxColors.teal,
            label: 'WhatsApp',
            value: _kSupportPhone,
            onTap: () => _launch(context, Uri.parse('https://wa.me/$_kSupportWhatsApp?text=${Uri.encodeComponent('Habari SINEMAX, nahitaji msaada.')}')),
          ),
          _ContactRow(
            icon: FontAwesomeIcons.envelope,
            tint: SinemaxColors.orange,
            label: 'Barua pepe',
            value: _kSupportEmail,
            onTap: () => _launch(context, Uri(scheme: 'mailto', path: _kSupportEmail, query: 'subject=${Uri.encodeComponent('Msaada wa SINEMAX')}')),
          ),
          _ContactRow(icon: FontAwesomeIcons.instagram, tint: SinemaxColors.purple, label: 'Instagram', value: '@sinemax', onTap: () => _launch(context, Uri.parse(_kSupportInstagram))),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

/// Rounded grab-handle container shared by the About and Help overlays.
class _SheetShell extends StatelessWidget {
  final Widget child;
  const _SheetShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: SinemaxColors.bg2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(color: SinemaxColors.line2, borderRadius: BorderRadius.circular(2)),
          ),
          Flexible(child: child),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final FaIconData icon;
  final Color tint;
  final String label;
  final String value;
  final VoidCallback onTap;
  const _ContactRow({required this.icon, required this.tint, required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: SinemaxColors.panel,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: SinemaxColors.line, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: tint.withAlpha(36), borderRadius: BorderRadius.circular(12)),
              child: FaIcon(icon, size: 20, color: tint),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: SinemaxTextStyles.body(14, weight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(value, style: SinemaxTextStyles.body(12, color: SinemaxColors.muted)),
                ],
              ),
            ),
            const FaIcon(FontAwesomeIcons.chevronRight, size: 16, color: SinemaxColors.muted2),
          ],
        ),
      ),
    );
  }
}
