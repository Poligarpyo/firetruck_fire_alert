import 'dart:async'; 
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  static final Uri _reachabilityUri = Uri.parse('https://clients3.google.com/generate_204');

  late final StreamController<bool> _controller;
  Stream<bool> get connectivityStream => _controller.stream;

  ConnectivityService() {
    _controller = StreamController<bool>.broadcast();
    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((_) => _checkInternet());
    // Initial check
    _checkInternet();
  }

  Future<void> _checkInternet() async {
    bool connected = false;
    try {
      final result = await http
          .get(_reachabilityUri)
          .timeout(const Duration(seconds: 3));
      // Consider any successful/redirect response as online.
      if (result.statusCode >= 200 && result.statusCode < 400) {
        connected = true;
      }
    } catch (_) {
      connected = false;
    }
    _controller.add(connected);
  }

  Future<bool> get isConnected async {
    try {
      final result = await http
          .get(_reachabilityUri)
          .timeout(const Duration(seconds: 3));
      return result.statusCode >= 200 && result.statusCode < 400;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _controller.close();
  }

  
}
