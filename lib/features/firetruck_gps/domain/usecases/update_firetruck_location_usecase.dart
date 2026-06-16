import '../repositories/firetruck_location_repository.dart';

class UpdateFiretruckLocationUseCase {
  final FiretruckLocationRepository _repository;

  const UpdateFiretruckLocationUseCase(this._repository);

  Future<void> call({
    required String truckId,
    required double latitude,
    required double longitude,
    double? heading,
    double? speed,
    double? accuracy,
  }) => _repository.updateLocation(
    truckId: truckId,
    latitude: latitude,
    longitude: longitude,
    heading: heading,
    speed: speed,
    accuracy: accuracy,
  );
}
