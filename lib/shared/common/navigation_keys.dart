// lib/core/navigation/navigation_keys.dart
import 'package:flutter/material.dart';

/// Root navigator key used for showing global snackbars, dialogs, etc.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>();
