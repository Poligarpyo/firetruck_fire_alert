import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.sms,
    Permission.location,
  ].request();

  if (statuses[Permission.sms] != PermissionStatus.granted) {
    throw Exception('SMS permission denied');
  }

  if (statuses[Permission.location] != PermissionStatus.granted) {
    throw Exception('Location permission denied');
  }
}
