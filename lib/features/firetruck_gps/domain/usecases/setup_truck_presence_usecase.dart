import '../entities/firetruck_status.dart';
import '../repositories/firetruck_location_repository.dart';

/// Hooks up `onDisconnect` for the given truck so it flips to `offline`
/// the moment its socket dies, and immediately marks itself online.
class SetupTruckPresenceUseCase {
  final FiretruckLocationRepository _repository;

  const SetupTruckPresenceUseCase(this._repository);

  Future<void> call({
    required String truckId,
    FiretruckStatus initialStatus = FiretruckStatus.available,
  }) => _repository.setupPresence(
    truckId: truckId,
    initialStatus: initialStatus,
  );
}
