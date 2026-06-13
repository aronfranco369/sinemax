// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MediaNotifier)
final mediaProvider = MediaNotifierProvider._();

final class MediaNotifierProvider
    extends $AsyncNotifierProvider<MediaNotifier, List<Media>> {
  MediaNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaNotifierHash();

  @$internal
  @override
  MediaNotifier create() => MediaNotifier();
}

String _$mediaNotifierHash() => r'e9ce58845daa498c2c79e76e55583fb0d26a7f21';

abstract class _$MediaNotifier extends $AsyncNotifier<List<Media>> {
  FutureOr<List<Media>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Media>>, List<Media>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Media>>, List<Media>>,
              AsyncValue<List<Media>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
