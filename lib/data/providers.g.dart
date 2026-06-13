// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$mediaByIdHash() => r'b06fc6b8073f18889758f8793db2dd1077f01700';

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

String _$homeRowsHash() => r'65fa47e66b0d283b94bd3634f7a8dd207f55cd4f';

/// Files for a specific media — reads from Hive via FilesNotifier.
/// Triggers a background Supabase fetch on first access for this mediaId.

@ProviderFor(mediaFiles)
final mediaFilesProvider = MediaFilesFamily._();

/// Files for a specific media — reads from Hive via FilesNotifier.
/// Triggers a background Supabase fetch on first access for this mediaId.

final class MediaFilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MediaFile>>,
          List<MediaFile>,
          FutureOr<List<MediaFile>>
        >
    with $FutureModifier<List<MediaFile>>, $FutureProvider<List<MediaFile>> {
  /// Files for a specific media — reads from Hive via FilesNotifier.
  /// Triggers a background Supabase fetch on first access for this mediaId.
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

String _$mediaFilesHash() => r'05d954ce950f216b77f35c6a9b60797640eb805c';

/// Files for a specific media — reads from Hive via FilesNotifier.
/// Triggers a background Supabase fetch on first access for this mediaId.

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

  /// Files for a specific media — reads from Hive via FilesNotifier.
  /// Triggers a background Supabase fetch on first access for this mediaId.

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

String _$relatedMediaHash() => r'88edfbb2657115d303f0114f91b0420873f45d6f';

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

String _$filterYearsHash() => r'a207cc24970f9dfe74e984867105e4f8162ca39e';

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

String _$filterDjsHash() => r'3066b61b74e8c3bcd82b6ae52802c784048e1ff3';

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

String _$filterCountriesHash() => r'df2443e3ad7a0aa277de20f495ea54f0b4ebd2fc';

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

String _$discoverFiltersHash() => r'0e0b5e9ef40f23f535f50ca8efcdd88378360463';

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

String _$discoverResultsHash() => r'1d8937c580cff4ed346cf6809e5abdfe2e7a18ea';

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

/// Title to pre-fill the request form with, set when a user is forwarded from a
/// no-result search. Consumed (and cleared) by [RequestsScreen].

@ProviderFor(PendingRequestTitle)
final pendingRequestTitleProvider = PendingRequestTitleProvider._();

/// Title to pre-fill the request form with, set when a user is forwarded from a
/// no-result search. Consumed (and cleared) by [RequestsScreen].
final class PendingRequestTitleProvider
    extends $NotifierProvider<PendingRequestTitle, String?> {
  /// Title to pre-fill the request form with, set when a user is forwarded from a
  /// no-result search. Consumed (and cleared) by [RequestsScreen].
  PendingRequestTitleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingRequestTitleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingRequestTitleHash();

  @$internal
  @override
  PendingRequestTitle create() => PendingRequestTitle();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$pendingRequestTitleHash() =>
    r'ed81f0d18396f97f2f4da8bbfb3a70c4f9f81422';

/// Title to pre-fill the request form with, set when a user is forwarded from a
/// no-result search. Consumed (and cleared) by [RequestsScreen].

abstract class _$PendingRequestTitle extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
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

String _$searchResultsHash() => r'2a20290c6c35f50369ab28019e691b0d5280161f';

/// Recently searched query strings, most-recent first. Backed by Hive box
/// `recent_searches` under key `terms`. Powers the chip row on the search screen.

@ProviderFor(RecentSearchTerms)
final recentSearchTermsProvider = RecentSearchTermsProvider._();

/// Recently searched query strings, most-recent first. Backed by Hive box
/// `recent_searches` under key `terms`. Powers the chip row on the search screen.
final class RecentSearchTermsProvider
    extends $NotifierProvider<RecentSearchTerms, List<String>> {
  /// Recently searched query strings, most-recent first. Backed by Hive box
  /// `recent_searches` under key `terms`. Powers the chip row on the search screen.
  RecentSearchTermsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentSearchTermsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentSearchTermsHash();

  @$internal
  @override
  RecentSearchTerms create() => RecentSearchTerms();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$recentSearchTermsHash() => r'f23da296fa396deeb9c63d8f67f5ea16baac6e97';

/// Recently searched query strings, most-recent first. Backed by Hive box
/// `recent_searches` under key `terms`. Powers the chip row on the search screen.

abstract class _$RecentSearchTerms extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Media IDs the user opened from search results, most-recent first. Backed by
/// Hive box `recent_searches` under key `media`.

@ProviderFor(RecentSearchMedia)
final recentSearchMediaProvider = RecentSearchMediaProvider._();

/// Media IDs the user opened from search results, most-recent first. Backed by
/// Hive box `recent_searches` under key `media`.
final class RecentSearchMediaProvider
    extends $NotifierProvider<RecentSearchMedia, List<String>> {
  /// Media IDs the user opened from search results, most-recent first. Backed by
  /// Hive box `recent_searches` under key `media`.
  RecentSearchMediaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentSearchMediaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentSearchMediaHash();

  @$internal
  @override
  RecentSearchMedia create() => RecentSearchMedia();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$recentSearchMediaHash() => r'2dc45624428f5c1970c49d2647505c0baa4ed350';

/// Media IDs the user opened from search results, most-recent first. Backed by
/// Hive box `recent_searches` under key `media`.

abstract class _$RecentSearchMedia extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(recentSearchContent)
final recentSearchContentProvider = RecentSearchContentProvider._();

final class RecentSearchContentProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Media>>,
          List<Media>,
          FutureOr<List<Media>>
        >
    with $FutureModifier<List<Media>>, $FutureProvider<List<Media>> {
  RecentSearchContentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentSearchContentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentSearchContentHash();

  @$internal
  @override
  $FutureProviderElement<List<Media>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Media>> create(Ref ref) {
    return recentSearchContent(ref);
  }
}

String _$recentSearchContentHash() =>
    r'bc18293d447741e8772b4129ed60622ed3341d33';

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

String _$savedContentHash() => r'5ca0bd3931ed4b16662264c77efd37f1f534b6ca';

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

String _$recentContentHash() => r'df66d4489f5003be8113f85256afddfcfe07d6ee';

/// Distinct DJ names pulled from the cached media catalog (Hive). Used to power
/// the DJ autocomplete in the Agiza (requests) screen.

@ProviderFor(djNames)
final djNamesProvider = DjNamesProvider._();

/// Distinct DJ names pulled from the cached media catalog (Hive). Used to power
/// the DJ autocomplete in the Agiza (requests) screen.

final class DjNamesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// Distinct DJ names pulled from the cached media catalog (Hive). Used to power
  /// the DJ autocomplete in the Agiza (requests) screen.
  DjNamesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'djNamesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$djNamesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return djNames(ref);
  }
}

String _$djNamesHash() => r'0ec01c6c885b93977e304a410f750abffa593b71';

@ProviderFor(Requests)
final requestsProvider = RequestsProvider._();

final class RequestsProvider
    extends $AsyncNotifierProvider<Requests, List<ContentRequest>> {
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
}

String _$requestsHash() => r'1ab413efc3db74fff37d7e6a17dbc9f8fa83265a';

abstract class _$Requests extends $AsyncNotifier<List<ContentRequest>> {
  FutureOr<List<ContentRequest>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ContentRequest>>, List<ContentRequest>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ContentRequest>>,
                List<ContentRequest>
              >,
              AsyncValue<List<ContentRequest>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
