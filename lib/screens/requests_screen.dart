import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers.dart';
import '../models/request.dart';
import '../theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RequestsScreen extends ConsumerStatefulWidget {
  const RequestsScreen({super.key});

  @override
  ConsumerState<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends ConsumerState<RequestsScreen> {
  bool _sheetOpen = false; // guards against opening two sheets at once

  @override
  void initState() {
    super.initState();
    // A title forwarded from a no-result search should open the composer
    // pre-filled, as soon as this screen is mounted.
    final pending = ref.read(pendingRequestTitleProvider)?.trim();
    if (pending != null && pending.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openComposer(prefill: pending);
        ref.read(pendingRequestTitleProvider.notifier).clear();
      });
    }
  }

  Future<void> _openComposer({String? prefill}) async {
    if (_sheetOpen) return;
    setState(() => _sheetOpen = true);
    final sent = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(140),
      builder: (_) => _OrderSheet(initialTitle: prefill),
    );
    if (mounted) setState(() => _sheetOpen = false);
    if (sent == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: SinemaxColors.panel,
          content: Row(
            children: [
              const FaIcon(FontAwesomeIcons.check, size: 18, color: SinemaxColors.teal),
              const SizedBox(width: 10),
              Text('Ombi limetumwa!',
                  style: SinemaxTextStyles.body(14,
                      weight: FontWeight.w600, color: SinemaxColors.teal)),
            ],
          ),
        ),
      );
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
        _openComposer(prefill: t);
        ref.read(pendingRequestTitleProvider.notifier).clear();
      }
    });

    return Scaffold(
      backgroundColor: SinemaxColors.bg,
      appBar: AppBar(
        backgroundColor: SinemaxColors.bg,
        title: Text('Maombi', style: SinemaxTextStyles.display(22, weight: FontWeight.w700)),
      ),
      // The orders feed is the whole screen; ordering is a compose overlay.
      floatingActionButton: _ComposeFab(onTap: () => _openComposer()),
      body: RefreshIndicator(
        color: SinemaxColors.blue,
        backgroundColor: SinemaxColors.panel,
        onRefresh: () => ref.refresh(requestsProvider.future),
        child: requestsAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: SinemaxColors.blue)),
          error: (e, _) => ListView(
            // ListView keeps pull-to-refresh working in the error state.
            children: [
              const SizedBox(height: 120),
              Center(
                child: Text('Could not load requests.',
                    style: SinemaxTextStyles.body(13, color: SinemaxColors.muted)),
              ),
            ],
          ),
          data: (requests) {
            if (requests.isEmpty) {
              return _EmptyFeed(onCompose: () => _openComposer());
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              itemCount: requests.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _ComposePrompt(onTap: () => _openComposer()),
                  );
                }
                return _RequestCard(request: requests[i - 1]);
              },
            );
          },
        ),
      ),
    );
  }
}

/// Tappable "compose" prompt pinned to the top of the feed — the primary way
/// to start an order without stealing half the screen.
class _ComposePrompt extends StatelessWidget {
  final VoidCallback onTap;
  const _ComposePrompt({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [SinemaxColors.blue.withAlpha(38), SinemaxColors.panel],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: SinemaxColors.blue.withAlpha(90), width: 0.6),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: SinemaxColors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: FaIcon(FontAwesomeIcons.penToSquare, size: 18, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Agiza filamu au series',
                      style: SinemaxTextStyles.body(14, weight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('Hupati unachotafuta? Tujulishe.',
                      style: SinemaxTextStyles.body(12, color: SinemaxColors.muted)),
                ],
              ),
            ),
            const FaIcon(FontAwesomeIcons.chevronRight,
                size: 14, color: SinemaxColors.muted2),
          ],
        ),
      ),
    );
  }
}

/// Floating "order" button — always reachable while scrolling the feed.
class _ComposeFab extends StatelessWidget {
  final VoidCallback onTap;
  const _ComposeFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      backgroundColor: SinemaxColors.blue,
      foregroundColor: Colors.white,
      icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 16, color: Colors.white),
      label: Text('Agiza',
          style: SinemaxTextStyles.body(14, weight: FontWeight.w700, color: Colors.white)),
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  final VoidCallback onCompose;
  const _EmptyFeed({required this.onCompose});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        _ComposePrompt(onTap: onCompose),
        const SizedBox(height: 48),
        Center(
          child: FaIcon(FontAwesomeIcons.inbox, size: 40, color: SinemaxColors.muted2),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text('Hakuna maombi bado.',
              style: SinemaxTextStyles.body(14, color: SinemaxColors.muted)),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text('Kuwa wa kwanza kuagiza.',
              style: SinemaxTextStyles.body(12, color: SinemaxColors.muted2)),
        ),
      ],
    );
  }
}

/// Bottom-sheet composer. Owns the form controllers and submit logic so the
/// feed screen stays purely about browsing orders.
class _OrderSheet extends ConsumerStatefulWidget {
  final String? initialTitle;
  const _OrderSheet({this.initialTitle});

  @override
  ConsumerState<_OrderSheet> createState() => _OrderSheetState();
}

class _OrderSheetState extends ConsumerState<_OrderSheet> {
  final _titleCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _djCtrl = TextEditingController();

  String _type = 'movie'; // 'movie' | 'series'
  bool _sending = false;

  // Required fields: type (always set), DJ, and title. Notes stay optional.
  bool get _canSubmit =>
      _titleCtrl.text.trim().isNotEmpty && _djCtrl.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    final t = widget.initialTitle?.trim();
    if (t != null && t.isNotEmpty) _titleCtrl.text = t;
    // Re-evaluate the submit guard as the required fields change.
    _titleCtrl.addListener(_onFieldChanged);
    _djCtrl.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
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
    if (!_canSubmit || _sending) return;
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
              const FaIcon(FontAwesomeIcons.triangleExclamation, color: SinemaxColors.red, size: 18),
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
      Navigator.of(context).pop(true); // parent shows the confirmation
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: SinemaxColors.panel,
          content: Text('Could not send request. Try again.',
              style: SinemaxTextStyles.body(13, color: SinemaxColors.red)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: SinemaxColors.bg2,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: SinemaxColors.line2,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('Agiza Filamu / Series',
                          style: SinemaxTextStyles.display(18, weight: FontWeight.w700)),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const FaIcon(FontAwesomeIcons.xmark,
                          size: 22, color: SinemaxColors.muted2),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _RequestForm(
                  titleCtrl: _titleCtrl,
                  noteCtrl: _noteCtrl,
                  djCtrl: _djCtrl,
                  type: _type,
                  onTypeChanged: (v) => setState(() => _type = v),
                  submitted: false,
                  sending: _sending,
                  canSubmit: _canSubmit,
                  onSubmit: _submit,
                ),
              ],
            ),
          ),
        ),
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
  final bool canSubmit;
  final VoidCallback onSubmit;

  const _RequestForm({
    required this.titleCtrl,
    required this.noteCtrl,
    required this.djCtrl,
    required this.type,
    required this.onTypeChanged,
    required this.submitted,
    required this.sending,
    required this.canSubmit,
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
                  _FieldLabel('Aina', required: true),
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
                  _FieldLabel('DJ', required: true),
                  _DjAutocomplete(controller: djCtrl, options: djs),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Title
        _FieldLabel('Jina la Filamu / Series', required: true),
        _InputField(controller: titleCtrl, hint: 'Andika jina...', icon: FontAwesomeIcons.penToSquare),
        const SizedBox(height: 10),

        // Extra details
        _FieldLabel('Maelezo ya Ziada (hiari)'),
        _InputField(
          controller: noteCtrl,
          hint: 'Mwaka, lugha, msimu, n.k...',
          icon: FontAwesomeIcons.listUl,
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
                    onTap: canSubmit ? onSubmit : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: !canSubmit
                            ? SinemaxColors.panel2
                            : (sending ? SinemaxColors.blueDeep : SinemaxColors.blue),
                        borderRadius: BorderRadius.circular(10),
                        border: !canSubmit
                            ? Border.all(color: SinemaxColors.line, width: 0.5)
                            : null,
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
                            FaIcon(FontAwesomeIcons.paperPlane,
                                size: 16,
                                color: canSubmit ? Colors.white : SinemaxColors.muted2),
                          const SizedBox(width: 8),
                          Text(
                            sending ? 'Inatuma...' : 'Tuma Ombi',
                            style: SinemaxTextStyles.body(15,
                                weight: FontWeight.w600,
                                color: canSubmit ? Colors.white : SinemaxColors.muted2),
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
  final bool required;
  const _FieldLabel(this.text, {this.required = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text.rich(
        TextSpan(
          text: text,
          style: SinemaxTextStyles.body(12,
              weight: FontWeight.w600, color: SinemaxColors.muted),
          children: required
              ? [
                  TextSpan(
                    text: ' *',
                    style: SinemaxTextStyles.body(12,
                        weight: FontWeight.w600, color: SinemaxColors.red),
                  ),
                ]
              : null,
        ),
      ),
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
          FaIcon(value == 'series' ? FontAwesomeIcons.inbox : FontAwesomeIcons.play, size: 18, color: SinemaxColors.muted2),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor: SinemaxColors.panel,
                icon: const FaIcon(FontAwesomeIcons.chevronDown, color: SinemaxColors.muted2),
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
                child: FaIcon(FontAwesomeIcons.user, size: 18, color: SinemaxColors.muted2),
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
                          const FaIcon(FontAwesomeIcons.user, size: 14, color: SinemaxColors.muted2),
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
  final FaIconData icon;
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
            child: FaIcon(icon, size: 18, color: SinemaxColors.muted2),
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
          const FaIcon(FontAwesomeIcons.check, size: 18, color: SinemaxColors.teal),
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
                        child: _MetaChip(request.dj!, icon: FontAwesomeIcons.user),
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
  final FaIconData? icon;
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
            FaIcon(icon!, size: 11, color: SinemaxColors.muted2),
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
