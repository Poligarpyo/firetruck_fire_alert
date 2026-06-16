// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cachedAccount)
const cachedAccountProvider = CachedAccountProvider._();

final class CachedAccountProvider
    extends $FunctionalProvider<AccountModel?, AccountModel?, AccountModel?>
    with $Provider<AccountModel?> {
  const CachedAccountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cachedAccountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cachedAccountHash();

  @$internal
  @override
  $ProviderElement<AccountModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AccountModel? create(Ref ref) {
    return cachedAccount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountModel?>(value),
    );
  }
}

String _$cachedAccountHash() => r'8b92f9cd2dcb4d4f7227da4f63d948f9054e9a5b';
