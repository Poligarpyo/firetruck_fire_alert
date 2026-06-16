class Strings {
  Strings._();

  static const String appName = 'template';
  static const String appVersion = '1.0.0';
  static const String localizationsPath = 'assets/translations';
  static const String kRoutesApiUrl =
      'https://routes.googleapis.com/directions/v2:computeRoutes';

  /// How far the truck must move (meters) before we write to Firebase.
  /// Avoids spamming RTDB while the truck is stationary.
  ///
  /// Kept as a low-level fallback only; the canonical filter lives in
  /// [LocationPublisherConfig.minDistanceMeters] (default 5 m).
  static const double kLocationWriteThresholdMeters = 5.0;

  /// Minimum gap between two RTDB writes for the same truck.
  /// Hard-caps publish rate even when the truck is moving fast.
  static const Duration kLocationWriteMinInterval = Duration(seconds: 2);

  /// Drop GPS samples worse than this many meters of horizontal accuracy.
  static const double kLocationMaxAcceptableAccuracyMeters = 50.0;

  /// How long the dispatcher waits before treating a stale `lastSeen` as
  /// "offline" in the UI, even if the status field hasn't flipped.
  static const Duration kTruckStaleAfter = Duration(seconds: 30);
}
