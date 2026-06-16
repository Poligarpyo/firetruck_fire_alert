// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Resolves the firetruck doc id assigned to the currently logged-in user.
///
/// This is a stripped-down version of [firetruckAssignmentControllerProvider]
/// that does *not* require an active incident — used to start the location
/// publisher the moment the driver signs in, so dispatchers see them as
/// "available" on the fleet map immediately.
///
/// Re-emits whenever the `firetrucks` collection changes (e.g. when the
/// dispatcher reassigns the truck to a different officer).

@ProviderFor(myAssignedTruckId)
const myAssignedTruckIdProvider = MyAssignedTruckIdProvider._();

/// Resolves the firetruck doc id assigned to the currently logged-in user.
///
/// This is a stripped-down version of [firetruckAssignmentControllerProvider]
/// that does *not* require an active incident — used to start the location
/// publisher the moment the driver signs in, so dispatchers see them as
/// "available" on the fleet map immediately.
///
/// Re-emits whenever the `firetrucks` collection changes (e.g. when the
/// dispatcher reassigns the truck to a different officer).

final class MyAssignedTruckIdProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, Stream<String?>>
    with $FutureModifier<String?>, $StreamProvider<String?> {
  /// Resolves the firetruck doc id assigned to the currently logged-in user.
  ///
  /// This is a stripped-down version of [firetruckAssignmentControllerProvider]
  /// that does *not* require an active incident — used to start the location
  /// publisher the moment the driver signs in, so dispatchers see them as
  /// "available" on the fleet map immediately.
  ///
  /// Re-emits whenever the `firetrucks` collection changes (e.g. when the
  /// dispatcher reassigns the truck to a different officer).
  const MyAssignedTruckIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myAssignedTruckIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myAssignedTruckIdHash();

  @$internal
  @override
  $StreamProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String?> create(Ref ref) {
    return myAssignedTruckId(ref);
  }
}

String _$myAssignedTruckIdHash() => r'e12fd4660eff97eaf06fd1c189d38a85416e55fc';

@ProviderFor(firetruckAssignmentRealtime)
const firetruckAssignmentRealtimeProvider =
    FiretruckAssignmentRealtimeProvider._();

final class FiretruckAssignmentRealtimeProvider
    extends
        $FunctionalProvider<
          AsyncValue<FiretruckAssignment?>,
          FiretruckAssignment?,
          Stream<FiretruckAssignment?>
        >
    with
        $FutureModifier<FiretruckAssignment?>,
        $StreamProvider<FiretruckAssignment?> {
  const FiretruckAssignmentRealtimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firetruckAssignmentRealtimeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firetruckAssignmentRealtimeHash();

  @$internal
  @override
  $StreamProviderElement<FiretruckAssignment?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<FiretruckAssignment?> create(Ref ref) {
    return firetruckAssignmentRealtime(ref);
  }
}

String _$firetruckAssignmentRealtimeHash() =>
    r'f7b297b880716d017865be95bff2b03de5d9b108';

@ProviderFor(FiretruckAssignmentController)
const firetruckAssignmentControllerProvider =
    FiretruckAssignmentControllerProvider._();

final class FiretruckAssignmentControllerProvider
    extends
        $AsyncNotifierProvider<
          FiretruckAssignmentController,
          FiretruckAssignment
        > {
  const FiretruckAssignmentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firetruckAssignmentControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firetruckAssignmentControllerHash();

  @$internal
  @override
  FiretruckAssignmentController create() => FiretruckAssignmentController();
}

String _$firetruckAssignmentControllerHash() =>
    r'9933813def2876a44cccd3fb798c11674490afb3';

abstract class _$FiretruckAssignmentController
    extends $AsyncNotifier<FiretruckAssignment> {
  FutureOr<FiretruckAssignment> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<FiretruckAssignment>, FiretruckAssignment>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FiretruckAssignment>, FiretruckAssignment>,
              AsyncValue<FiretruckAssignment>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
