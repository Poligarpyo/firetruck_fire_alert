import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/firetruck_gps/presentation/providers/assignment_provider.dart';
import '../../features/firetruck_gps/presentation/providers/firetruck_location_providers.dart';
import '../../features/firetruck_gps/presentation/providers/incident_photo_providers.dart';
import '../../shared/common/navigation_keys.dart';
import 'connectivity_provider.dart';

/// Listens to connectivity changes and triggers a full data resync the
/// moment the device transitions from offline → online.
///
/// Without this, three things go stale after a reconnect:
///   * Firebase RTDB's `onDisconnect` handler has already flipped the
///     truck to `offline`, and nothing re-arms it.
///   * The publisher's last GPS write may have been silently queued by
///     the SDK while offline, so the dispatcher's `lastSeen` and lat/lng
///     stay frozen until the next 30s heartbeat (or the next position
///     fix that passes the 5m distance gate — could be much longer if
///     the truck is parked).
///   * The one-shot assignment lookup (`firetruckAssignmentControllerProvider`)
///     may have failed mid-resolution and wedged in an error state.
///
/// `MyApp` activates this with `ref.watch(autoSyncProvider)`.
final Provider<void> autoSyncProvider = Provider<void>((Ref ref) {
  // Tracks the most recent *known* connectivity state so we only react
  // to real transitions, not the initial AsyncValue<bool> emission at
  // app startup.
  bool? wasConnected;

  ref.listen<AsyncValue<bool>>(connectivityStatusProvider, (
    AsyncValue<bool>? previous,
    AsyncValue<bool> next,
  ) async {
    final isConnected = next.value;
    if (isConnected == null) return;

    final transitionedFromOffline = wasConnected == false;
    final transitionedToOffline = wasConnected == true && !isConnected;
    wasConnected = isConnected;

    if (transitionedToOffline) {
      _showBanner(
        'You are offline. Changes will sync when the connection returns.',
        isError: true,
      );
      return;
    }

    if (!isConnected || !transitionedFromOffline) return;

    _showBanner('Reconnected — syncing data…');

    try {
      // Defensive: nudge the RTDB SDK out of any stuck offline state so
      // queued writes flush immediately and `.onValue` streams re-emit.
      FirebaseDatabase.instance.goOnline();

      // Re-arm `onDisconnect`, flip the truck back to its real status,
      // and re-push the last GPS fix without waiting for the heartbeat.
      final publisher = ref.read(firetruckLocationPublisherProvider);
      await publisher.resyncAfterReconnect();

      // The one-shot assignment resolver isn't a stream — if it threw
      // during the offline window it stays errored until invalidated.
      // The realtime + truck-id streams re-emit naturally as soon as
      // RTDB / Firestore reconnect, which in turn rebuilds the controller.
      ref.invalidate(firetruckAssignmentControllerProvider);

      final syncedPhotos =
          await ref.read(incidentPhotoServiceProvider).syncPendingPhotos();
      if (syncedPhotos > 0) {
        debugPrint('[autoSync] uploaded $syncedPhotos incident photo(s)');
      }

      _showBanner('Back online — data synced.');
    } catch (e) {
      debugPrint('[autoSync] reconnect resync failed: $e');
      _showBanner('Reconnected, but sync failed. Retrying…', isError: true);
    }
  });
});

void _showBanner(String message, {bool isError = false}) {
  final messenger = scaffoldMessengerKey.currentState;
  if (messenger == null) return;
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
      margin: const EdgeInsets.all(16),
    ),
  );
}
