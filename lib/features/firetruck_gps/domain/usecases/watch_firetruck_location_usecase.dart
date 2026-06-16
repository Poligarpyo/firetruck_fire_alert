import '../entities/firetruck_location.dart';
import '../repositories/firetruck_location_repository.dart';

class WatchFiretruckLocationUseCase {
  final FiretruckLocationRepository _repository;

  const WatchFiretruckLocationUseCase(this._repository);

  /// Returns a stream that emits a [FiretruckLocation] (or `null` when the
  /// truck has no record yet) on every RTDB change.
  Stream<FiretruckLocation?> call(String truckId) =>
      _repository.watchTruck(truckId);
}
