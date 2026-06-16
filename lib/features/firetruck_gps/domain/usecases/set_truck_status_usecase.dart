import '../entities/firetruck_status.dart';
import '../repositories/firetruck_location_repository.dart';

class SetTruckStatusUseCase {
  final FiretruckLocationRepository _repository;

  const SetTruckStatusUseCase(this._repository);

  Future<void> call({
    required String truckId,
    required FiretruckStatus status,
  }) => _repository.setStatus(truckId: truckId, status: status);
}
