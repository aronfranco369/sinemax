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
  final _noteCtrl = TextEditingController();
  final _djCtrl = TextEditingController();

  String _type = 'movie'; // 'movie' | 'series'
  bool _submitted = false;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    // Consume any pending prefill (e.g. forwarded from a no-result search).
    final pending = ref.read(pendingRequestTitleProvider)?.trim();
    if (pending != null && pending.isNotEmpty) {
      _titleCtrl.text = pending;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ref.read(pendingRequestTitleProvider.notifier).clear();
      });
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    _djCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty || _sending) return;
    FocusScope.of(context).unfocus();

    // Re-probe connectivity; requests need an internet connection.
    final online = await ref.read(connectionStatusProvider.notifier).recheck();
    if (!online) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: SinemaxColors.panel,
          content: Row(
            children: [
              const Icon(Icons.wifi_off_rounded, color: SinemaxColors.red, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Ombi haliwezi kutumwa. Tafadhali angalia muunganisho wako wa intaneti.',
                  style: SinemaxTextStyles.body(13, color: SinemaxColors.ink),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    setState(() => _sending = true);
    try {
      await ref.read(requestsProvider.notifier).submit(
            title: title,
            note: _noteCtrl.text.trim(),
            type: _type,
            dj: _djCtrl.text.trim(),
          );
      if (!mounted) return;
      _titleCtrl.clear();
      _noteCtrl.clear();
      _djCtrl.clear();
      setState(() => _submitted = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _submitted = false);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: SinemaxColors.panel,
          content: Text('Could not send request. Try again.',
              style: SinemaxTextStyles.body(13, color: SinemaxColors.red)),
        ),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(requestsProvider);

    // Repeat forwards from search arrive while this tab is kept alive in the
    // IndexedStack, so initState won't re-run — react to the provider instead.
    ref.listen(pendingRequestTitleProvider, (_, next) {
      final t = next?.trim();
      if (t != null && t.isNotEmpty) {
        _titleCtrl.text = t;
        ref.read(pendingRequestTitleProvider.notifier).clear();
      }
    });

    return Scaffold(
      backgroundColor: SinemaxColors.bg,
      appBar: AppBar(
        backgroundColor: SinemaxColors.bg,
        title: Text('Agiza', style: SinemaxTextStyles.display(22, weight: FontWeight.w700)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Top 60% — request form ──────────────────────────────────────
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              child: _RequestForm(
                titleCtrl: _titleCtrl,
                noteCtrl: _noteCtrl,
                djCtrl: _djCtrl,
                type: _type,
                onTypeChanged: (v) => setState(() => _type = v),
                submitted: _submitted,
                sending: _sending,
                onSubmit: _submit,
              ),
            ),
          ),

          const Divider(height: 1, thickness: 0.5),

          // ── Bottom 40% — requests from Supabase ─────────────────────────
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                  child: Text('Maombi ya Hivi Karibuni',
                      style: SinemaxTextStyles.display(16, weight: FontWeight.w700)),
                ),
                Expanded(
                  child: requestsAsync.when(
                    loading: () => const Center(
                        child: CircularProgressIndicator(color: SinemaxColors.blue)),
                    error: (e, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('Could not load requests.',
                            style: SinemaxTextStyles.body(13, color: SinemaxColors.muted)),
                      ),
                    ),
                    data: (requests) {
                      if (requests.isEmpty) {
                        return Center(
                          child: Text('No requests yet.',
                              style: SinemaxTextStyles.body(13, color: SinemaxColors.muted2)),
                        );
                      }
                      return RefreshIndicator(
                        color: SinemaxColors.blue,
                        backgroundColor: SinemaxColors.panel,
                        onRefresh: () => ref.refresh(requestsProvider.future),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: requests.length,
                          itemBuilder: (context, i) => _RequestCard(request: requests[i]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestForm extends ConsumerWidget {
  final TextEditingController titleCtrl;
  final TextEditingController noteCtrl;
  final TextEditingController djCtrl;
  final String type;
  final ValueChanged<String> onTypeChanged;
  final bool submitted;
  final bool sending;
  final VoidCallback onSubmit;

  const _RequestForm({
    required this.titleCtrl,
    required this.noteCtrl,
    required this.djCtrl,
    required this.type,
    required this.onTypeChanged,
    required this.submitted,
    required this.sending,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final djs = ref.watch(djNamesProvider).value ?? const <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Hupati unachotafuta? Tujulishe na tutakiweka haraka iwezekanavyo.",
            style: SinemaxTextStyles.body(13, color: SinemaxColors.muted)),
        const SizedBox(height: 12),

        // Type + DJ on the same row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Aina'),
                  _TypeDropdown(value: type, onChanged: onTypeChanged),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('DJ'),
                  _DjAutocomplete(controller: djCtrl, options: djs),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Title
        _FieldLabel('Jina la Filamu / Series'),
        _InputField(controller: titleCtrl, hint: 'Andika jina...', icon: 'edit'),
        const SizedBox(height: 10),

        // Extra details
        _FieldLabel('Maelezo ya Ziada'),
        _InputField(
          controller: noteCtrl,
          hint: 'Mwaka, lugha, msimu, n.k...',
          icon: 'list',
          maxLines: 2,
        ),
        const SizedBox(height: 12),

        // Submit
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: submitted
              ? _SuccessBanner()
              : SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: onSubmit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: sending ? SinemaxColors.blueDeep : SinemaxColors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (sending)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          else
                            const SinemaxIcon('send', size: 16, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            sending ? 'Inatuma...' : 'Tuma Ombi',
                            style: SinemaxTextStyles.body(15,
                                weight: FontWeight.w600, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(text,
          style: SinemaxTextStyles.body(12, weight: FontWeight.w600, color: SinemaxColors.muted)),
    );
  }
}

class _TypeDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _TypeDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: SinemaxColors.panel,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: SinemaxColors.line, width: 0.5),
      ),
      child: Row(
        children: [
          SinemaxIcon(value == 'series' ? 'inbox' : 'play', size: 18, color: SinemaxColors.muted2),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor: SinemaxColors.panel,
                icon: const Icon(Icons.keyboard_arrow_down, color: SinemaxColors.muted2),
                style: SinemaxTextStyles.body(14, color: SinemaxColors.ink),
                items: const [
                  DropdownMenuItem(value: 'movie', child: Text('Movie')),
                  DropdownMenuItem(value: 'series', child: Text('Series')),
                ],
                onChanged: (v) {
                  if (v != null) onChanged(v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DjAutocomplete extends StatelessWidget {
  final TextEditingController controller;
  final List<String> options;
  const _DjAutocomplete({required this.controller, required this.options});

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      textEditingController: controller,
      focusNode: FocusNode(),
      optionsBuilder: (TextEditingValue value) {
        // Filter by the last word being typed, so "dj" matches nothing but
        // "dj six" matches DJs containing "six".
        final words = value.text.toLowerCase().split(RegExp(r'\s+'))
          ..removeWhere((w) => w.isEmpty);
        if (words.isEmpty) return const Iterable<String>.empty();
        final query = words.last;
        return options.where((dj) => dj.toLowerCase().contains(query));
      },
      fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
        return Container(
          decoration: BoxDecoration(
            color: SinemaxColors.panel,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: SinemaxColors.line, width: 0.5),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 14),
                child: SinemaxIcon('user', size: 18, color: SinemaxColors.muted2),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: textController,
                  focusNode: focusNode,
                  style: SinemaxTextStyles.body(14),
                  cursorColor: SinemaxColors.blue,
                  onSubmitted: (_) => onFieldSubmitted(),
                  decoration: InputDecoration(
                    hintText: 'Andika jina la DJ...',
                    hintStyle: SinemaxTextStyles.body(14, color: SinemaxColors.muted2),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 14),
            ],
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, results) {
        final list = results.toList();
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: SinemaxColors.panel2,
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 220,
                maxWidth: MediaQuery.of(context).size.width - 32,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final dj = list[i];
                  return InkWell(
                    onTap: () => onSelected(dj),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          const SinemaxIcon('user', size: 14, color: SinemaxColors.muted2),
                          const SizedBox(width: 10),
                          Expanded(child: Text(dj, style: SinemaxTextStyles.body(14))),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
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
                contentPadding: EdgeInsets.symmetric(vertical: maxLines > 1 ? 12 : 14, horizontal: 0),
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
          Text(
            'Ombi limetumwa!',
            style: SinemaxTextStyles.body(15, weight: FontWeight.w600, color: SinemaxColors.teal),
          ),
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
      margin: const EdgeInsets.only(bottom: 10),
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
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (request.typeLabel.isNotEmpty) ...[
                      _MetaChip(request.typeLabel),
                      const SizedBox(width: 6),
                    ],
                    if (request.dj != null && request.dj!.isNotEmpty)
                      Flexible(
                        child: _MetaChip(request.dj!, icon: 'user'),
                      ),
                  ],
                ),
                if (request.note.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(request.note,
                      style: SinemaxTextStyles.body(12, color: SinemaxColors.muted2)),
                ],
                if (request.dateLabel.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(request.dateLabel,
                      style: SinemaxTextStyles.body(11, color: SinemaxColors.muted2)),
                ],
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
                  style: SinemaxTextStyles.body(11,
                      color: request.status.color, weight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 110),
                child: Text(
                  request.displayNote,
                  textAlign: TextAlign.end,
                  style: SinemaxTextStyles.body(11, color: SinemaxColors.muted2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String text;
  final String? icon;
  const _MetaChip(this.text, {this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: SinemaxColors.panel2,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: SinemaxColors.line, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            SinemaxIcon(icon!, size: 11, color: SinemaxColors.muted2),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: SinemaxTextStyles.body(11, color: SinemaxColors.muted),
            ),
          ),
        ],
      ),
    );
  }
}
