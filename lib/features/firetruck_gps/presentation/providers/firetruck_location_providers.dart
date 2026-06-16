import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/repositories/firetruck_location_repository_impl.dart';
import '../../data/services/firetruck_location_publisher.dart';
import '../../data/source/firetruck_location_remote_source.dart';
import '../../domain/entities/firetruck_location.dart';
import '../../domain/repositories/firetruck_location_repository.dart';
import '../../domain/usecases/set_truck_status_usecase.dart';
import '../../domain/usecases/setup_truck_presence_usecase.dart';
import '../../domain/usecases/update_firetruck_location_usecase.dart';
import '../../domain/usecases/watch_firetruck_fleet_usecase.dart';
import '../../domain/usecases/watch_firetruck_location_usecase.dart';
import 'dispatch_provider.dart';

// ── Data layer ──────────────────────────────────────────────────────────────

final firetruckLocationRemoteSourceProvider =
    Provider<FiretruckLocationRemoteSource>(
      (_) => FiretruckLocationRemoteSourceImpl(),
    );

final firetruckLocationRepositoryProvider =
    Provider<FiretruckLocationRepository>(
      (ref) => FiretruckLocationRepositoryImpl(
        ref.read(firetruckLocationRemoteSourceProvider),
      ),
    );

// ── Use cases ───────────────────────────────────────────────────────────────

final updateFiretruckLocationUseCaseProvider =
    Provider<UpdateFiretruckLocationUseCase>(
      (ref) => UpdateFiretruckLocationUseCase(
        ref.read(firetruckLocationRepositoryProvider),
      ),
    );

final watchFiretruckLocationUseCaseProvider =
    Provider<WatchFiretruckLocationUseCase>(
      (ref) => WatchFiretruckLocationUseCase(
        ref.read(firetruckLocationRepositoryProvider),
      ),
    );

final watchFiretruckFleetUseCaseProvider =
    Provider<WatchFiretruckFleetUseCase>(
      (ref) => WatchFiretruckFleetUseCase(
        ref.read(firetruckLocationRepositoryProvider),
      ),
    );

final setTruckStatusUseCaseProvider = Provider<SetTruckStatusUseCase>(
  (ref) => SetTruckStatusUseCase(
    ref.read(firetruckLocationRepositoryProvider),
  ),
);

final setupTruckPresenceUseCaseProvider = Provider<SetupTruckPresenceUseCase>(
  (ref) => SetupTruckPresenceUseCase(
    ref.read(firetruckLocationRepositoryProvider),
  ),
);

// ── Publisher (truck-side, owns GPS subscription) ──────────────────────────

/// Singleton publisher. Lives for the app session — `start(truckId)` from
/// the screen, `stop()` on logout. Auto-disposed by Riverpod.
final firetruckLocationPublisherProvider =
    Provider<FiretruckLocationPublisher>((ref) {
      final publisher = FiretruckLocationPublisher(
        update: ref.read(updateFiretruckLocationUseCaseProvider),
        presence: ref.read(setupTruckPresenceUseCaseProvider),
        setStatus: ref.read(setTruckStatusUseCaseProvider),
      );
      ref.onDispose(publisher.stop);
      return publisher;
    });

// ── Streams (consumer side) ─────────────────────────────────────────────────

/// Watches a single truck. Emits `null` when the truck has no record yet.
final firetruckLocationStreamProvider =
    StreamProvider.family<FiretruckLocation?, String>(
      (ref, truckId) =>
          ref.read(watchFiretruckLocationUseCaseProvider).call(truckId),
    );

/// Convenience: just the `LatLng` for the map. Filters out null/no-fix frames.
final firetruckLatLngProvider = StreamProvider.family<LatLng?, String>(
  (ref, truckId) => ref
      .read(watchFiretruckLocationUseCaseProvider)
      .call(truckId)
      .map((loc) {
        if (loc == null || !loc.hasFix) return null;
        return LatLng(loc.latitude!, loc.longitude!);
      }),
);

/// Whole-fleet stream — one socket subscription instead of N.
final firetruckFleetStreamProvider =
    StreamProvider<List<FiretruckLocation>>(
      (ref) => ref.read(watchFiretruckFleetUseCaseProvider).call(),
    );

// ── Existing dispatch provider (kept for compatibility) ─────────────────────

final dispatchProvider =
    StateNotifierProvider<DispatchNotifier, DispatchState>((ref) {
      return DispatchNotifier();
    });
