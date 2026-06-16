import '../../domain/entities/firetruck_location.dart';
import '../../domain/entities/firetruck_status.dart';
import '../../domain/repositories/firetruck_location_repository.dart';
import '../source/firetruck_location_remote_source.dart';

class FiretruckLocationRepositoryImpl implements FiretruckLocationRepository {
  final FiretruckLocationRemoteSource _source;

  const FiretruckLocationRepositoryImpl(this._source);

  @override
  Future<void> updateLocation({
    required String truckId,
    required double latitude,
    required double longitude,
    double? heading,
    double? speed,
    double? accuracy,
  }) => _source.updateLocation(
    truckId: truckId,
    latitude: latitude,
    longitude: longitude,
    heading: heading,
    speed: speed,
    accuracy: accuracy,
  );

  @override
  Future<void> setStatus({
    required String truckId,
    required FiretruckStatus status,
  }) => _source.setStatus(truckId: truckId, status: status);

  @override
  Stream<FiretruckLocation?> watchTruck(String truckId) =>
      _source.watchTruck(truckId);

  @override
  Stream<List<FiretruckLocation>> watchFleet() => _source.watchFleet();

  @override
  Future<void> setupPresence({
    required String truckId,
    FiretruckStatus initialStatus = FiretruckStatus.available,
  }) => _source.setupPresence(
    truckId: truckId,
    initialStatus: initialStatus,
  );
}
