// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Emits `true` when the device can actually reach the internet.
///
/// Combines connectivity_plus interface events (Wi-Fi/mobile toggles) with a
/// real reachability probe (TCP handshake to a public DNS server), so dead
/// Wi-Fi and captive portals are detected too. While offline it re-probes
/// every few seconds so the app recovers automatically when the connection
/// comes back — data notifiers listen to this to re-sync with Supabase.

@ProviderFor(ConnectionStatus)
final connectionStatusProvider = ConnectionStatusProvider._();

/// Emits `true` when the device can actually reach the internet.
///
/// Combines connectivity_plus interface events (Wi-Fi/mobile toggles) with a
/// real reachability probe (TCP handshake to a public DNS server), so dead
/// Wi-Fi and captive portals are detected too. While offline it re-probes
/// every few seconds so the app recovers automatically when the connection
/// comes back — data notifiers listen to this to re-sync with Supabase.
final class ConnectionStatusProvider
    extends $NotifierProvider<ConnectionStatus, bool> {
  /// Emits `true` when the device can actually reach the internet.
  ///
  /// Combines connectivity_plus interface events (Wi-Fi/mobile toggles) with a
  /// real reachability probe (TCP handshake to a public DNS server), so dead
  /// Wi-Fi and captive portals are detected too. While offline it re-probes
  /// every few seconds so the app recovers automatically when the connection
  /// comes back — data notifiers listen to this to re-sync with Supabase.
  ConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionStatusHash();

  @$internal
  @override
  ConnectionStatus create() => ConnectionStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$connectionStatusHash() => r'c3a75318dca8bcc6de2b1eccc7e5fb6175e8103f';

/// Emits `true` when the device can actually reach the internet.
///
/// Combines connectivity_plus interface events (Wi-Fi/mobile toggles) with a
/// real reachability probe (TCP handshake to a public DNS server), so dead
/// Wi-Fi and captive portals are detected too. While offline it re-probes
/// every few seconds so the app recovers automatically when the connection
/// comes back — data notifiers listen to this to re-sync with Supabase.

abstract class _$ConnectionStatus extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
