import 'dart:math' show pi;

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit/media_kit.dart' as mk;
import 'package:media_kit_video/media_kit_video.dart';
import 'package:readmore/readmore.dart';

import '../data/providers.dart';
import '../models/media.dart';
import '../theme/app_theme.dart';
import '../widgets/action_btn.dart';
import '../widgets/detail_skeleton.dart';
import '../widgets/download_controls.dart';
import '../widgets/info_chip.dart';
import '../widgets/offline_banner.dart';
import '../widgets/player_loading_view.dart';
import '../widgets/poster_card.dart';
import '../widgets/ripple_play_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final String contentId;

  /// Start playing immediately on open (set when arriving from library /
  /// history / saved / downloads / a notification). Browse surfaces leave it
  /// false so the idle ripple play button is shown instead.
  final bool autoplay;

  /// Optional MediaFile id to play instead of the first file — lets a Downloads
  /// row open straight onto, say, episode 2.
  final String? fileId;

  const DetailScreen({super.key, required this.contentId, this.autoplay = false, this.fileId});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  mk.Player? _player;
  VideoController? _controller;
  // False until the user taps the ripple play button (or autoplay/deep-link
  // kicks in). While false the idle poster + ripple play button is shown and
  // nothing has been loaded.
  bool _started = false;
  bool _playerReady = false;
  bool _playerFailed = false;
  // Non-null when playback failed for a reason other than connectivity
  // (bad codec, server rejection, …) — shown in the player slot.
  String? _playerError;
  // Last URL handed to the player — logged alongside any player error.
  String? _currentUrl;
  bool _episodesExpanded = false;
  int _activeFileIndex = 0;

  @override
  void initState() {
    super.initState();
    // Autoplay only when we were sent here to play something (library, history,
    // saved, downloads, notification). Otherwise wait for the user to tap play.
    if (widget.autoplay) {
      _started = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadAndInitPlayer());
    } else if (widget.fileId != null) {
      // Deep-linked to a specific file but not autoplaying — preselect it so the
      // now-playing label and episode highlight point at the right one.
      WidgetsBinding.instance.addPostFrameCallback((_) => _preselectDeepLinkedFile());
    }
  }

  /// Resolves [DetailScreen.fileId] to its index once files are loaded, without
  /// starting playback. No-op when no file was deep-linked.
  Future<void> _preselectDeepLinkedFile() async {
    if (!mounted || widget.fileId == null) return;
    final files = await ref.read(mediaFilesProvider(widget.contentId).future);
    final i = files.indexWhere((f) => f.id == widget.fileId);
    if (i >= 0 && mounted) setState(() => _activeFileIndex = i);
  }

  /// User tapped the idle ripple play button — begin playback of the current
  /// (possibly deep-linked) file.
  void _startPlayback() {
    if (_started) return;
    setState(() => _started = true);
    _loadAndInitPlayer();
  }

  Future<void> _loadAndInitPlayer() async {
    if (!mounted) return;
    try {
      // The catalog files list can be unavailable offline (never cached). Don't
      // let that block a title that's already downloaded — fall back to an empty
      // list and resolve playback straight from the download record below.
      List<MediaFile> files;
      try {
        files = await ref.read(mediaFilesProvider(widget.contentId).future);
      } catch (_) {
        files = const [];
      }
      String? url;
      if (files.isNotEmpty) {
        // Honour a deep-linked file id; otherwise keep the current selection.
        if (widget.fileId != null) {
          final i = files.indexWhere((f) => f.id == widget.fileId);
          if (i >= 0) _activeFileIndex = i;
        }
        final index = _activeFileIndex.clamp(0, files.length - 1);
        final file = files[index];
        debugPrint('[Sinemax] Playing file size: ${file.fileSize} bytes (${file.sizeDisplay})');
        url = await _resolvePlayUrl(file);
      } else {
        // No catalog files — only an offline copy can play here.
        url = await _resolveOfflineUrl();
      }
      if (url == null) {
        _showPlayerError('Video hii bado haijapatikana');
        return;
      }
      debugPrint('[Sinemax] Playing URL: $url');
      await _initPlayer(url);
      // Record this title in watch history (powers Library → History).
      if (mounted) ref.read(recentProvider.notifier).markWatched(widget.contentId);
      // TODO: [DO NOT TOUCH] After player initializes, increment view_count on Supabase for widget.contentId.
      // Use: supabase.rpc('increment_view_count', params: {'media_id': widget.contentId}) or a direct UPDATE.
      // TODO: [DO NOT TOUCH] After player initializes, restore saved playback position for the first file
      // from Hive (box: 'watch_progress', key: '${widget.contentId}_0'). Seek _vpc to saved Duration.
    } catch (e, st) {
      await _handlePlayerError(e, st);
    }
  }

  /// Resolve a playable local path purely from download records — used when the
  /// catalog files list isn't available (offline + uncached). `playbackUrl`
  /// only needs the fileId, which the record already carries. Prefers a
  /// deep-linked file id, else the first completed download for this title.
  Future<String?> _resolveOfflineUrl() async {
    if (widget.fileId != null) {
      return DownloadEngine.instance.playbackUrl(widget.fileId!);
    }
    for (final rec in ref.read(downloadsProvider).values) {
      if (rec.mediaId == widget.contentId && rec.isCompleted) {
        return DownloadEngine.instance.playbackUrl(rec.fileId);
      }
    }
    return null;
  }

  /// Decides whether a playback failure is a connectivity problem or a real
  /// player error. Offline → offline notice; online → friendly "couldn't play"
  /// notice with a retry button (covers transient server errors, e.g. 403).
  Future<void> _handlePlayerError(Object e, StackTrace st) async {
    debugPrint('[Sinemax] Player error on URL: $_currentUrl');
    debugPrint('[Sinemax] Player error: $e\n$st');
    if (!mounted) return;
    final online = await ref.read(connectionStatusProvider.notifier).recheck();
    _showPlayerError(online ? 'Imeshindwa kucheza video. Jaribu tena baadaye.' : null);
  }

  /// Shows the in-player error slot. A null [message] renders the offline
  /// notice; a non-null one renders the generic playback-failure notice.
  void _showPlayerError(String? message) {
    if (!mounted) return;
    setState(() {
      _playerFailed = true;
      _playerError = message;
    });
  }

  Future<void> _switchToFile(MediaFile file, int index) async {
    if (!mounted) return;
    // TODO: [DO NOT TOUCH] Before disposing _vpc, save current playback position to Hive.
    // Key: '${widget.contentId}_$_activeFileIndex', value: _vpc?.value.position (Duration → microseconds).
    setState(() {
      _started = true;
      _playerReady = false;
      _playerFailed = false;
      _playerError = null;
      _activeFileIndex = index;
    });
    _player?.dispose();
    _player = null;
    _controller = null;
    try {
      final url = await _resolvePlayUrl(file);
      if (url == null) {
        _showPlayerError('Video hii bado haijapatikana');
        return;
      }
      debugPrint('[Sinemax] Playing URL: $url');
      await _initPlayer(url);
    } catch (e, st) {
      await _handlePlayerError(e, st);
    }
    // TODO: [DO NOT TOUCH] After new file's player initializes, restore saved position for 'index'
    // from Hive key '${widget.contentId}_$index'. Seek _vpc to saved Duration.
  }

  /// Prefer the encrypted offline copy (streamed via the loopback decrypting
  /// server) over the remote Backblaze URL.
  Future<String?> _resolvePlayUrl(MediaFile file) async {
    final local = await DownloadEngine.instance.playbackUrl(file.id);
    if (local != null) return local;
    return (file.downloadUrl != null && file.downloadUrl!.isNotEmpty) ? file.downloadUrl : null;
  }

  Future<void> _initPlayer(String url) async {
    _currentUrl = url;
    debugPrint('[Sinemax] NOW PLAYING URL: $url');
    // Drop any previous player before building a new one (guards the
    // tap-A-then-B race when switching episodes quickly).
    _player?.dispose();
    final player = mk.Player();
    final controller = VideoController(player);
    _player = player;
    _controller = controller;
    // Playback errors (bad codec, server rejection, mid-stream drop) surface
    // here rather than throwing — route them through the same handler.
    player.stream.error.listen((e) {
      if (mounted && identical(_player, player)) _handlePlayerError(e, StackTrace.current);
    });
    // `Media` accepts both a remote URL and a local file path; libmpv probes
    // the container/codec itself, so any downloaded file type plays.
    await player.open(mk.Media(url)); // autoplays by default
    if (mounted && identical(_player, player)) setState(() => _playerReady = true);
  }

  @override
  void dispose() {
    // TODO: [DO NOT TOUCH] Save current playback position before leaving the screen.
    // Key: '${widget.contentId}_$_activeFileIndex', value: _vpc?.value.position (Duration → microseconds).
    _player?.dispose();
    super.dispose();
  }

  // Collapsible description via readmore: collapsed clamps to 2 lines ending
  // with "… Soma zaidi"; tapping expands to full text with "Funga".
  Widget _buildDescription(String text) {
    final style = SinemaxTextStyles.body(14, color: SinemaxColors.muted);
    final linkStyle = SinemaxTextStyles.body(14, weight: FontWeight.w600, color: SinemaxColors.blue);

    return ReadMoreText(
      text,
      trimMode: TrimMode.Line,
      trimLines: 3,
      style: style,
      colorClickableText: SinemaxColors.blue,
      delimiter: ' ',
      trimCollapsedText: '… Soma zaidi',
      trimExpandedText: '  Funga',
      moreStyle: linkStyle,
      lessStyle: linkStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaAsync = ref.watch(mediaByIdProvider(widget.contentId));

    return mediaAsync.when(
      loading: () => const DetailSkeleton(),
      error: (e, _) => Scaffold(
        backgroundColor: SinemaxColors.bg,
        body: Center(
          child: Text('Error loading content', style: SinemaxTextStyles.body(15, color: SinemaxColors.muted)),
        ),
      ),
      data: (media) {
        if (media == null) {
          return Scaffold(
            backgroundColor: SinemaxColors.bg,
            body: Center(
              child: Text('Not found', style: SinemaxTextStyles.body(16, color: SinemaxColors.muted)),
            ),
          );
        }
        return _buildDetail(context, media);
      },
    );
  }

  Widget _buildDetail(BuildContext context, Media media) {
    final filesAsync = ref.watch(mediaFilesProvider(widget.contentId));
    final saved = ref.watch(savedProvider).contains(media.id);
    final topPad = MediaQuery.of(context).padding.top;

    final files = filesAsync.value ?? [];
    final hasFiles = files.isNotEmpty && (media.isSeries || files.length > 1);
    final isFilesLoading = filesAsync.isLoading;

    return Scaffold(
      backgroundColor: SinemaxColors.bg,
      body: Column(
        children: [
          // ── FIXED zone: Player ───────────────────────────────────────────
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: _playerReady && _controller != null
                    // media_kit's default controls show a buffering spinner
                    // (instead of a stuck play button) whenever the stream
                    // stalls on an unstable connection.
                    ? Video(controller: _controller!)
                    : _playerFailed
                    ? ColoredBox(
                        color: SinemaxColors.panel,
                        child: OfflineNotice(
                          compact: true,
                          icon: _playerError == null ? FontAwesomeIcons.triangleExclamation : FontAwesomeIcons.circleExclamation,
                          title: _playerError == null ? 'Unganisha intaneti kuonesha hii video' : 'Imeshindwa kucheza video',
                          message: _playerError ?? '',
                          onRetry: () {
                            setState(() {
                              _playerFailed = false;
                              _playerError = null;
                            });
                            _loadAndInitPlayer();
                          },
                        ),
                      )
                    : !_started
                    // Idle: poster + ripple play button — tap to start.
                    ? PlayerIdleView(posterUrl: media.posterUrl, onPlay: _startPlayback)
                    // TEMP: loader UI disabled so we can observe how the player
                    // itself handles the URL (buffering/init) with no overlay
                    // masking it. Restore PlayerLoadingView later.
                    // : PlayerLoadingView(posterUrl: media.posterUrl),
                    : const ColoredBox(color: Colors.black),
              ),
              Positioned(
                top: topPad + 8,
                left: 12,
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                    child: const FaIcon(FontAwesomeIcons.arrowLeft, size: 20),
                  ),
                ),
              ),
            ],
          ),

          // ── Now-playing label ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Builder(
              builder: (_) {
                final files = ref.watch(mediaFilesProvider(widget.contentId)).value ?? [];
                final String label;
                if (media.isSeries && files.isNotEmpty) {
                  final active = files[_activeFileIndex.clamp(0, files.length - 1)];
                  label = '${media.title}  ·  ${active.label ?? 'Episode ${_activeFileIndex + 1}'}';
                } else {
                  label = media.title;
                }
                return Text(
                  label,
                  style: SinemaxTextStyles.body(13, weight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),

          // ── FIXED zone: Action buttons ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: DownloadActionBtn(media: media, file: files.isNotEmpty ? files[_activeFileIndex.clamp(0, files.length - 1)] : null),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionBtn(
                    icon: saved ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark,
                    label: 'Save',
                    active: saved,
                    onTap: () => ref.read(savedProvider.notifier).toggle(media.id),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionBtn(icon: FontAwesomeIcons.shareNodes, label: 'Share'),
                ),
              ],
            ),
          ),

          // ── SCROLLABLE zone ──────────────────────────────────────────────
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: CustomScrollView(
                slivers: [
                  // Info
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(media.title, style: SinemaxTextStyles.display(28, weight: FontWeight.w900)),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              // Media type — leads the row, blue-tinted so it reads at a glance.
                              InfoChip(label: media.isSeries ? 'Series' : 'Movie', accent: true),
                              if (media.djDisplay.isNotEmpty) InfoChip(label: media.djDisplay),
                              if (media.year != null) InfoChip(label: '${media.year}'),
                              if (media.countryDisplay.isNotEmpty) InfoChip(label: media.countryDisplay),
                              if (media.genreDisplay.isNotEmpty) InfoChip(label: media.genreDisplay),
                              // Single-file movie (no parts): show its size here, since
                              // there's no episode/part list to attach it to.
                              if (!hasFiles && !media.isSeries && files.length == 1 && files.first.sizeDisplay.isNotEmpty) InfoChip(label: files.first.sizeDisplay),
                            ],
                          ),
                          if (media.description != null && media.description!.isNotEmpty) ...[const SizedBox(height: 10), _buildDescription(media.description!)],
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // While files are fetching for a series, show skeleton episodes
                  if (isFilesLoading) const SliverToBoxAdapter(child: EpisodesSkeleton()),

                  // Episodes header (pinned)
                  if (hasFiles)
                    SliverAppBar(
                      pinned: true,
                      automaticallyImplyLeading: false,
                      toolbarHeight: 46,
                      backgroundColor: SinemaxColors.bg,
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      surfaceTintColor: Colors.transparent,
                      titleSpacing: 0,
                      actions: const [],
                      title: _EpisodesHeader(
                        label: media.isSeries ? 'EPISODES' : 'PARTS',
                        count: '${files.length} ${media.isSeries ? (files.length == 1 ? 'episode' : 'episodes') : (files.length == 1 ? 'part' : 'parts')}',
                        expanded: _episodesExpanded,
                        onToggle: () => setState(() => _episodesExpanded = !_episodesExpanded),
                      ),
                    ),

                  // Collapsed: horizontal scroll + Related
                  if (hasFiles && !_episodesExpanded) ...[
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 96,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: files.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, i) => _FileCard(file: files[i], index: i, posterUrl: media.posterUrl, isActive: i == _activeFileIndex, onTap: () => _switchToFile(files[i], i)),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    SliverToBoxAdapter(child: _RelatedGrid(mediaId: widget.contentId)),
                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],

                  // Expanded: vertical list, Related hidden
                  if (hasFiles && _episodesExpanded) ...[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => _FileRow(
                          file: files[i],
                          media: media,
                          index: i,
                          posterUrl: media.posterUrl,
                          isActive: i == _activeFileIndex,
                          isPlaying: i == _activeFileIndex && _started,
                          onTap: () => _switchToFile(files[i], i),
                        ),
                        childCount: files.length,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],

                  // Movie always; series only once files confirmed empty
                  if (!hasFiles && !isFilesLoading) ...[SliverToBoxAdapter(child: _RelatedGrid(mediaId: widget.contentId)), const SliverToBoxAdapter(child: SizedBox(height: 32))],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Episodes header ───────────────────────────────────────────────────────────

class _EpisodesHeader extends StatelessWidget {
  final String label;
  final String count;
  final bool expanded;
  final VoidCallback onToggle;

  const _EpisodesHeader({required this.label, required this.count, required this.expanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(label, style: SinemaxTextStyles.display(16, weight: FontWeight.w700)),
          const SizedBox(width: 8),
          Text(count, style: SinemaxTextStyles.body(13, color: SinemaxColors.muted)),
          const Spacer(),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: SinemaxColors.panel2,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: SinemaxColors.line, width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(expanded ? 'Collapse' : 'Expand', style: SinemaxTextStyles.body(12, color: SinemaxColors.muted)),
                  const SizedBox(width: 4),
                  Transform.rotate(
                    angle: expanded ? pi : 0,
                    child: const FaIcon(FontAwesomeIcons.chevronDown, size: 13, color: SinemaxColors.muted),
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

// ── Horizontal file card (collapsed) ─────────────────────────────────────────

class _FileCard extends StatelessWidget {
  final MediaFile file;
  final int index;
  final String? posterUrl;
  final bool isActive;
  final VoidCallback? onTap;
  const _FileCard({required this.file, required this.index, this.posterUrl, this.isActive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final label = file.label ?? 'Episode ${file.episodeNumber ?? index + 1}';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 118,
        height: 96,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isActive ? SinemaxColors.blue : Colors.transparent, width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isActive ? 6.5 : 8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // poster background
              if (posterUrl != null && posterUrl!.isNotEmpty)
                Opacity(
                  opacity: isActive ? 0.55 : 0.35,
                  child: CachedNetworkImage(
                    imageUrl: posterUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const ColoredBox(color: SinemaxColors.panel2),
                  ),
                )
              else
                const ColoredBox(color: SinemaxColors.panel2),
              // gradient overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black87], stops: [0.35, 1.0]),
                ),
              ),
              // play icon + label
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(color: isActive ? SinemaxColors.blue.withValues(alpha: 0.9) : Colors.black45, shape: BoxShape.circle),
                      child: const FaIcon(FontAwesomeIcons.play, size: 16),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        label,
                        style: SinemaxTextStyles.body(10, weight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              // "NOW" badge when active
              if (isActive)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(color: SinemaxColors.blue, borderRadius: BorderRadius.circular(4)),
                    child: Text('NOW', style: SinemaxTextStyles.body(8, weight: FontWeight.w700)),
                  ),
                ),
              // TODO: [DO NOT TOUCH] Show a thin progress bar at the very top of this card.
              // Read saved position from Hive key '${mediaId}_$index' and total duration from Hive.
              // Render as a Positioned(top:0) FractionallySizedBox with height 3, color SinemaxColors.blue.
            ],
          ),
        ),
      ),
    );
  }
}

// ── Vertical file row (expanded) ──────────────────────────────────────────────

class _FileRow extends StatelessWidget {
  final MediaFile file;
  final Media media;
  final int index;
  final String? posterUrl;
  final bool isActive;

  /// True for the episode currently loaded in the player — shows the animated
  /// ripple indicator in place of the static play button.
  final bool isPlaying;
  final VoidCallback? onTap;
  const _FileRow({required this.file, required this.media, required this.index, this.posterUrl, this.isActive = false, this.isPlaying = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final label = file.label ?? 'Episode ${file.episodeNumber ?? index + 1}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        height: 72,
        decoration: BoxDecoration(
          color: isActive ? SinemaxColors.blue.withValues(alpha: 0.07) : SinemaxColors.panel,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isActive ? SinemaxColors.blue.withValues(alpha: 0.7) : SinemaxColors.line, width: isActive ? 1.0 : 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // poster bleeds in from the right
              if (posterUrl != null && posterUrl!.isNotEmpty)
                Opacity(
                  opacity: isActive ? 0.35 : 0.20,
                  child: CachedNetworkImage(imageUrl: posterUrl!, fit: BoxFit.cover, alignment: Alignment.centerRight, errorBuilder: (_, _, _) => const SizedBox.shrink()),
                ),
              // steeper gradient: solid left → transparent by 72% so poster shows on right
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [isActive ? SinemaxColors.blue.withValues(alpha: 0.12) : SinemaxColors.panel, SinemaxColors.panel.withValues(alpha: 0.6), Colors.transparent],
                    stops: const [0.0, 0.42, 0.72],
                  ),
                ),
              ),
              // left accent bar when active
              if (isActive)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 3,
                    decoration: const BoxDecoration(
                      color: SinemaxColors.blue,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                    ),
                  ),
                ),
              // TODO: [DO NOT TOUCH] Show watch progress as a filled overlay across the full row height.
              // Read saved position from Hive key '${mediaId}_$index' and total duration from Hive.
              // Render as Positioned.fill with an AlignmentDirectional FractionallySizedBox (widthFactor =
              // (savedPosition / totalDuration).clamp(0,1)) aligned to the left, low-opacity SinemaxColors.blue
              // (alpha ~0.12) so the existing content (text, icons) remains readable on top.
              // content row
              Padding(
                padding: EdgeInsets.only(left: isActive ? 17 : 14, right: 14),
                child: Row(
                  children: [
                    // label + season
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            label,
                            style: SinemaxTextStyles.body(13, weight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Builder(
                            builder: (_) {
                              final parts = [if (file.season != null) 'Season ${file.season}', if (file.sizeDisplay.isNotEmpty) file.sizeDisplay];
                              if (parts.isEmpty) return const SizedBox.shrink();
                              return Text(parts.join('  ·  '), style: SinemaxTextStyles.body(11, color: SinemaxColors.muted2));
                            },
                          ),
                        ],
                      ),
                    ),
                    // download control — idle / progress ring / done
                    FileDownloadIcon(media: media, file: file),
                    const SizedBox(width: 12),
                    // now-playing ripple when this row is the one in the player;
                    // otherwise a static play circle (filled when active).
                    if (isPlaying)
                      const SizedBox(width: 44, height: 44, child: Center(child: RipplePlayButton(size: 6, maxRingScale: 1.7)))
                    else
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive ? SinemaxColors.blue : SinemaxColors.blue.withValues(alpha: 0.15),
                          border: Border.all(color: SinemaxColors.blue.withValues(alpha: isActive ? 1.0 : 0.6), width: 1.0),
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.play, size: 13, color: isActive ? SinemaxColors.ink : SinemaxColors.blue)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Related row ───────────────────────────────────────────────────────────────

class _RelatedGrid extends ConsumerWidget {
  final String mediaId;
  const _RelatedGrid({required this.mediaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relatedAsync = ref.watch(relatedMediaProvider(mediaId));
    return relatedAsync.when(
      loading: () => const RelatedSkeleton(),
      error: (_, __) => const SizedBox.shrink(),
      data: (related) {
        if (related.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Text('RELATED', style: SinemaxTextStyles.display(18, weight: FontWeight.w700)),
            ),
            GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.62),
              itemCount: related.length,
              itemBuilder: (context, i) => LayoutBuilder(
                builder: (context, constraints) =>
                    PosterCard(media: related[i], width: constraints.maxWidth, height: constraints.maxHeight, onTap: () => context.pushReplacement('/detail/${related[i].id}')),
              ),
            ),
          ],
        );
      },
    );
  }
}
