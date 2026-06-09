// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(catalog)
final catalogProvider = CatalogProvider._();

final class CatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Media>>,
          List<Media>,
          FutureOr<List<Media>>
        >
    with $FutureModifier<List<Media>>, $FutureProvider<List<Media>> {
  CatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogHash();

  @$internal
  @override
  $FutureProviderElement<List<Media>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Media>> create(Ref ref) {
    return catalog(ref);
  }
}

String _$catalogHash() => r'b60d96ab01d08dc74a6cedcdacc4de8722bafe90';

@ProviderFor(mediaById)
final mediaByIdProvider = MediaByIdFamily._();

final class MediaByIdProvider
    extends $FunctionalProvider<AsyncValue<Media?>, Media?, FutureOr<Media?>>
    with $FutureModifier<Media?>, $FutureProvider<Media?> {
  MediaByIdProvider._({
    required MediaByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'mediaByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mediaByIdHash();

  @override
  String toString() {
    return r'mediaByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Media?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Media?> create(Ref ref) {
    final argument = this.argument as String;
    return mediaById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MediaByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mediaByIdHash() => r'2d3458890176c60377337a0449da2e67be528b3a';

final class MediaByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Media?>, String> {
  MediaByIdFamily._()
    : super(
        retry: null,
        name: r'mediaByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MediaByIdProvider call(String id) =>
      MediaByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'mediaByIdProvider';
}

@ProviderFor(homeRows)
final homeRowsProvider = HomeRowsProvider._();

final class HomeRowsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HomeRow>>,
          List<HomeRow>,
          FutureOr<List<HomeRow>>
        >
    with $FutureModifier<List<HomeRow>>, $FutureProvider<List<HomeRow>> {
  HomeRowsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeRowsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeRowsHash();

  @$internal
  @override
  $FutureProviderElement<List<HomeRow>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HomeRow>> create(Ref ref) {
    return homeRows(ref);
  }
}

String _$homeRowsHash() => r'76c7c322b4da3cf42c5c4c36a4743cd9ef47af76';

@ProviderFor(mediaFiles)
final mediaFilesProvider = MediaFilesFamily._();

final class MediaFilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MediaFile>>,
          List<MediaFile>,
          FutureOr<List<MediaFile>>
        >
    with $FutureModifier<List<MediaFile>>, $FutureProvider<List<MediaFile>> {
  MediaFilesProvider._({
    required MediaFilesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'mediaFilesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mediaFilesHash();

  @override
  String toString() {
    return r'mediaFilesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<MediaFile>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MediaFile>> create(Ref ref) {
    final argument = this.argument as String;
    return mediaFiles(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MediaFilesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mediaFilesHash() => r'e9bda10179fddc8b981782c2e186cf6010dbf3cb';

final class MediaFilesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<MediaFile>>, String> {
  MediaFilesFamily._()
    : super(
        retry: null,
        name: r'mediaFilesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MediaFilesProvider call(String mediaId) =>
      MediaFilesProvider._(argument: mediaId, from: this);

  @override
  String toString() => r'mediaFilesProvider';
}

@ProviderFor(relatedMedia)
final relatedMediaProvider = RelatedMediaFamily._();

final class RelatedMediaProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Media>>,
          List<Media>,
          FutureOr<List<Media>>
        >
    with $FutureModifier<List<Media>>, $FutureProvider<List<Media>> {
  RelatedMediaProvider._({
    required RelatedMediaFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'relatedMediaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$relatedMediaHash();

  @override
  String toString() {
    return r'relatedMediaProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Media>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Media>> create(Ref ref) {
    final argument = this.argument as String;
    return relatedMedia(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RelatedMediaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$relatedMediaHash() => r'4c824b2bf75d1257a27b08538625a7f13aedb107';

final class RelatedMediaFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Media>>, String> {
  RelatedMediaFamily._()
    : super(
        retry: null,
        name: r'relatedMediaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RelatedMediaProvider call(String mediaId) =>
      RelatedMediaProvider._(argument: mediaId, from: this);

  @override
  String toString() => r'relatedMediaProvider';
}

@ProviderFor(filterYears)
final filterYearsProvider = FilterYearsProvider._();

final class FilterYearsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  FilterYearsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filterYearsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filterYearsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return filterYears(ref);
  }
}

String _$filterYearsHash() => r'ea6aec26023d98c9d738469b1325dc0ae5e0298b';

@ProviderFor(filterDjs)
final filterDjsProvider = FilterDjsProvider._();

final class FilterDjsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  FilterDjsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filterDjsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filterDjsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return filterDjs(ref);
  }
}

String _$filterDjsHash() => r'79e13bc2fe28dc2b564d60ab1e25333e62a3ea6d';

@ProviderFor(filterCountries)
final filterCountriesProvider = FilterCountriesProvider._();

final class FilterCountriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  FilterCountriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filterCountriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filterCountriesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return filterCountries(ref);
  }
}

String _$filterCountriesHash() => r'3bc1449d142249f88c6a6e16ced0c3aed4f347cd';

@ProviderFor(DiscoverFilters)
final discoverFiltersProvider = DiscoverFiltersProvider._();

final class DiscoverFiltersProvider
    extends $NotifierProvider<DiscoverFilters, DiscoverFilter> {
  DiscoverFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoverFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoverFiltersHash();

  @$internal
  @override
  DiscoverFilters create() => DiscoverFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscoverFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscoverFilter>(value),
    );
  }
}

String _$discoverFiltersHash() => r'a61dd1b05b98de6e2c348cade0b6977b7bdfd6da';

abstract class _$DiscoverFilters extends $Notifier<DiscoverFilter> {
  DiscoverFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DiscoverFilter, DiscoverFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiscoverFilter, DiscoverFilter>,
              DiscoverFilter,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(discoverResults)
final discoverResultsProvider = DiscoverResultsProvider._();

final class DiscoverResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Media>>,
          List<Media>,
          FutureOr<List<Media>>
        >
    with $FutureModifier<List<Media>>, $FutureProvider<List<Media>> {
  DiscoverResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoverResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoverResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<Media>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Media>> create(Ref ref) {
    return discoverResults(ref);
  }
}

String _$discoverResultsHash() => r'5548191fc003f5d8bbc42d159d3f52ac95e6831d';

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'eade1e6597edd69e5cbf599d41b96561f4759074';

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsProvider._();

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Media>>,
          List<Media>,
          FutureOr<List<Media>>
        >
    with $FutureModifier<List<Media>>, $FutureProvider<List<Media>> {
  SearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<Media>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Media>> create(Ref ref) {
    return searchResults(ref);
  }
}

String _$searchResultsHash() => r'c306197cfe686f964c7c409c42a526c5df16a038';

@ProviderFor(Saved)
final savedProvider = SavedProvider._();

final class SavedProvider extends $NotifierProvider<Saved, Set<String>> {
  SavedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedHash();

  @$internal
  @override
  Saved create() => Saved();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$savedHash() => r'ea395a36fc3dcaa2403698136ec22af63e09b028';

abstract class _$Saved extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(savedContent)
final savedContentProvider = SavedContentProvider._();

final class SavedContentProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Media>>,
          List<Media>,
          FutureOr<List<Media>>
        >
    with $FutureModifier<List<Media>>, $FutureProvider<List<Media>> {
  SavedContentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedContentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedContentHash();

  @$internal
  @override
  $FutureProviderElement<List<Media>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Media>> create(Ref ref) {
    return savedContent(ref);
  }
}

String _$savedContentHash() => r'6ed2eee871d84a6a4b2fdef8a0929fab43b84365';

@ProviderFor(Recent)
final recentProvider = RecentProvider._();

final class RecentProvider
    extends $NotifierProvider<Recent, List<WatchedItem>> {
  RecentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentHash();

  @$internal
  @override
  Recent create() => Recent();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<WatchedItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<WatchedItem>>(value),
    );
  }
}

String _$recentHash() => r'56d8f5b8013bd7a0794dc398891a2f012cdbea42';

abstract class _$Recent extends $Notifier<List<WatchedItem>> {
  List<WatchedItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<WatchedItem>, List<WatchedItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<WatchedItem>, List<WatchedItem>>,
              List<WatchedItem>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(recentContent)
final recentContentProvider = RecentContentProvider._();

final class RecentContentProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<(WatchedItem, Media)>>,
          List<(WatchedItem, Media)>,
          FutureOr<List<(WatchedItem, Media)>>
        >
    with
        $FutureModifier<List<(WatchedItem, Media)>>,
        $FutureProvider<List<(WatchedItem, Media)>> {
  RecentContentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentContentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentContentHash();

  @$internal
  @override
  $FutureProviderElement<List<(WatchedItem, Media)>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<(WatchedItem, Media)>> create(Ref ref) {
    return recentContent(ref);
  }
}

String _$recentContentHash() => r'012a0d84ad075f526861047ab04c89a1e525451c';

@ProviderFor(Downloads)
final downloadsProvider = DownloadsProvider._();

final class DownloadsProvider
    extends $NotifierProvider<Downloads, List<DownloadItem>> {
  DownloadsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadsHash();

  @$internal
  @override
  Downloads create() => Downloads();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DownloadItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DownloadItem>>(value),
    );
  }
}

String _$downloadsHash() => r'8d07a15c9e3ee9d96ea219a9296740af4e2c2c1e';

abstract class _$Downloads extends $Notifier<List<DownloadItem>> {
  List<DownloadItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<DownloadItem>, List<DownloadItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<DownloadItem>, List<DownloadItem>>,
              List<DownloadItem>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(downloadsContent)
final downloadsContentProvider = DownloadsContentProvider._();

final class DownloadsContentProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<(DownloadItem, Media)>>,
          List<(DownloadItem, Media)>,
          FutureOr<List<(DownloadItem, Media)>>
        >
    with
        $FutureModifier<List<(DownloadItem, Media)>>,
        $FutureProvider<List<(DownloadItem, Media)>> {
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
  $FutureProviderElement<List<(DownloadItem, Media)>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<(DownloadItem, Media)>> create(Ref ref) {
    return downloadsContent(ref);
  }
}

String _$downloadsContentHash() => r'e47407c85c122b3bcd4939aa9eed263868454964';

@ProviderFor(Requests)
final requestsProvider = RequestsProvider._();

final class RequestsProvider
    extends $NotifierProvider<Requests, List<ContentRequest>> {
  RequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestsHash();

  @$internal
  @override
  Requests create() => Requests();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ContentRequest> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ContentRequest>>(value),
    );
  }
}

String _$requestsHash() => r'6372b4f4888abdd5ebdf91ac84a1ad7a2c8864cc';

abstract class _$Requests extends $Notifier<List<ContentRequest>> {
  List<ContentRequest> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<ContentRequest>, List<ContentRequest>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ContentRequest>, List<ContentRequest>>,
              List<ContentRequest>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
