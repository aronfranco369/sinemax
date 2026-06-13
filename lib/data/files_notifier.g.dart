// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FilesNotifier)
final filesProvider = FilesNotifierProvider._();

final class FilesNotifierProvider
    extends $AsyncNotifierProvider<FilesNotifier, List<MediaFile>> {
  FilesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filesNotifierHash();

  @$internal
  @override
  FilesNotifier create() => FilesNotifier();
}

String _$filesNotifierHash() => r'aa304870af692713e83818f4df312339a6809802';

abstract class _$FilesNotifier extends $AsyncNotifier<List<MediaFile>> {
  FutureOr<List<MediaFile>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<MediaFile>>, List<MediaFile>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<MediaFile>>, List<MediaFile>>,
              AsyncValue<List<MediaFile>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
