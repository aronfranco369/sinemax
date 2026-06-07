import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers.dart';
import '../models/request.dart';
import '../theme/app_theme.dart';
import '../widgets/sinemax_icon.dart';

class RequestsScreen extends ConsumerStatefulWidget {
  const RequestsScreen({super.key});

  @override
  ConsumerState<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends ConsumerState<RequestsScreen> {
  final _titleCtrl = TextEditingController();
  final _noteCtrl  = TextEditingController();
  bool _submitted  = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;
    ref.read(requestsProvider.notifier).add(title, _noteCtrl.text.trim());
    _titleCtrl.clear();
    _noteCtrl.clear();
    setState(() => _submitted = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _submitted = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(requestsProvider);

    return Scaffold(
      backgroundColor: SinemaxColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: SinemaxColors.bg,
            pinned: true,
            title: Text('Requests', style: SinemaxTextStyles.display(22, weight: FontWeight.w700)),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request a Movie or Series',
                    style: SinemaxTextStyles.display(18, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Can't find what you're looking for? Let us know and we'll add it as soon as we can.",
                    style: SinemaxTextStyles.body(13, color: SinemaxColors.muted),
                  ),
                  const SizedBox(height: 16),

                  // Title input
                  _InputField(
                    controller: _titleCtrl,
                    hint: 'Type a movie or series name...',
                    icon: 'edit',
                  ),
                  const SizedBox(height: 10),

                  // Notes input
                  _InputField(
                    controller: _noteCtrl,
                    hint: 'Any extra details? (year, language, season, DJ...)',
                    icon: 'list',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 14),

                  // Submit button
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _submitted
                        ? _SuccessBanner()
                        : SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: _submit,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: SinemaxColors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SinemaxIcon('send', size: 16, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text('Send Request',
                                        style: SinemaxTextStyles.body(15, weight: FontWeight.w600, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    'We review all requests and add them as soon as possible.',
                    style: SinemaxTextStyles.body(12, color: SinemaxColors.muted2),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  Text('Your Requests', style: SinemaxTextStyles.display(18, weight: FontWeight.w700)),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // History
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _RequestCard(request: history[i]),
              childCount: history.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String icon;
  final int maxLines;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SinemaxColors.panel,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: SinemaxColors.line, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 14, top: maxLines > 1 ? 14 : 0),
            child: SinemaxIcon(icon, size: 18, color: SinemaxColors.muted2),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              style: SinemaxTextStyles.body(14),
              cursorColor: SinemaxColors.blue,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: SinemaxTextStyles.body(14, color: SinemaxColors.muted2),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: maxLines > 1 ? 12 : 14,
                  horizontal: 0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: SinemaxColors.teal.withAlpha(30),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: SinemaxColors.teal.withAlpha(80), width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SinemaxIcon('check', size: 18, color: SinemaxColors.teal),
          const SizedBox(width: 8),
          Text('Request sent!', style: SinemaxTextStyles.body(15, weight: FontWeight.w600, color: SinemaxColors.teal)),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final ContentRequest request;
  const _RequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SinemaxColors.panel,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: SinemaxColors.line, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request.title, style: SinemaxTextStyles.body(14, weight: FontWeight.w500)),
                if (request.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(request.note, style: SinemaxTextStyles.body(12, color: SinemaxColors.muted2)),
                ],
                const SizedBox(height: 6),
                Text(request.date, style: SinemaxTextStyles.body(11, color: SinemaxColors.muted2)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: request.status.color.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: request.status.color.withAlpha(80), width: 0.5),
                ),
                child: Text(
                  request.status.label,
                  style: SinemaxTextStyles.body(11, color: request.status.color, weight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                request.status.note,
                style: SinemaxTextStyles.body(11, color: SinemaxColors.muted2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
