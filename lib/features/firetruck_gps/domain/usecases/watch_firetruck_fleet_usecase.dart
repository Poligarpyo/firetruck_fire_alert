import '../entities/firetruck_location.dart';
import '../repositories/firetruck_location_repository.dart';

/// Streams the entire fleet for the dispatcher map.
///
/// This is one socket subscription regardless of fleet size, much cheaper
/// than spinning up one `WatchFiretruckLocationUseCase` per truck.
class WatchFiretruckFleetUseCase {
  final FiretruckLocationRepository _repository;

  const WatchFiretruckFleetUseCase(this._repository);

  Stream<List<FiretruckLocation>> call() => _repository.watchFleet();
}
