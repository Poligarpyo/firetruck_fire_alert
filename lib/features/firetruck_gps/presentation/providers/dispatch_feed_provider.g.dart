// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispatch_feed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(assignedDispatchFeed)
const assignedDispatchFeedProvider = AssignedDispatchFeedProvider._();

final class AssignedDispatchFeedProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DispatchInfo>>,
          List<DispatchInfo>,
          Stream<List<DispatchInfo>>
        >
    with
        $FutureModifier<List<DispatchInfo>>,
        $StreamProvider<List<DispatchInfo>> {
  const AssignedDispatchFeedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assignedDispatchFeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assignedDispatchFeedHash();

  @$internal
  @override
  $StreamProviderElement<List<DispatchInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<DispatchInfo>> create(Ref ref) {
    return assignedDispatchFeed(ref);
  }
}

String _$assignedDispatchFeedHash() =>
    r'ff7a9a1b7522a0fa31a77737bf87068eda1c39e2';
