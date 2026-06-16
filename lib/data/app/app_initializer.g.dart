// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_initializer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appInitializer)
const appInitializerProvider = AppInitializerProvider._();

final class AppInitializerProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const AppInitializerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appInitializerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appInitializerHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return appInitializer(ref);
  }
}

String _$appInitializerHash() => r'cf3455e8cb0201f4fa34690225c49ba1e0a0b93f';
