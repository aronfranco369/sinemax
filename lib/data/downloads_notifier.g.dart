// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloads_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Mirrors the `download_records` Hive box, keyed by fileId. The actual work
/// (downloading, encrypting, persisting) happens in [DownloadEngine]; this just
/// keeps the UI in sync and forwards user actions.

@ProviderFor(Downloads)
final downloadsProvider = DownloadsProvider._();

/// Mirrors the `download_records` Hive box, keyed by fileId. The actual work
/// (downloading, encrypting, persisting) happens in [DownloadEngine]; this just
/// keeps the UI in sync and forwards user actions.
final class DownloadsProvider
    extends $NotifierProvider<Downloads, Map<String, DownloadRecord>> {
  /// Mirrors the `download_records` Hive box, keyed by fileId. The actual work
  /// (downloading, encrypting, persisting) happens in [DownloadEngine]; this just
  /// keeps the UI in sync and forwards user actions.
  DownloadsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadsHash();

  @$internal
  @override
  Downloads create() => Downloads();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, DownloadRecord> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, DownloadRecord>>(value),
    );
  }
}

String _$downloadsHash() => r'841a08246ce86025ac7e27db22423e40a29b62a4';

/// Mirrors the `download_records` Hive box, keyed by fileId. The actual work
/// (downloading, encrypting, persisting) happens in [DownloadEngine]; this just
/// keeps the UI in sync and forwards user actions.

abstract class _$Downloads extends $Notifier<Map<String, DownloadRecord>> {
  Map<String, DownloadRecord> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<Map<String, DownloadRecord>, Map<String, DownloadRecord>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, DownloadRecord>,
                Map<String, DownloadRecord>
              >,
              Map<String, DownloadRecord>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Download records grouped per media for the Downloads screen, newest first.

@ProviderFor(downloadsContent)
final downloadsContentProvider = DownloadsContentProvider._();

/// Download records grouped per media for the Downloads screen, newest first.

final class DownloadsContentProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<(Media, List<DownloadRecord>)>>,
          List<(Media, List<DownloadRecord>)>,
          FutureOr<List<(Media, List<DownloadRecord>)>>
        >
    with
        $FutureModifier<List<(Media, List<DownloadRecord>)>>,
        $FutureProvider<List<(Media, List<DownloadRecord>)>> {
  /// Download records grouped per media for the Downloads screen, newest first.
  DownloadsContentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadsContentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadsContentHash();

  @$internal
  @override
  $FutureProviderElement<List<(Media, List<DownloadRecord>)>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<(Media, List<DownloadRecord>)>> create(Ref ref) {
    return downloadsContent(ref);
  }
}

String _$downloadsContentHash() => r'a3f409eb622e878653cca199775cb89c7c9be1fd';
