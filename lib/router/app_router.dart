import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/enums/auth_status.dart';
import '../data/enums/sg_route.dart';
import '../shared/common/navigation_keys.dart';
import '../core/storage/auth_local_datasource_provider.dart';
import '../features/authentication/domain/auth/auth_controller.dart';
import '../features/authentication/presentation/login/login_screen.dart';
import '../features/firetruck_gps/presentation/screen/firetruck_gps.dart';
import '../features/splash/presentation/splash_screen.dart';
import 'fade_extension.dart';

part 'app_router.g.dart';
 
@riverpod
GoRouter goRouter(Ref ref) {
  final authStatus = ref.watch(authControllerProvider);
  final authLocalDataSource = ref.read(authLocalDataSourceProvider);
  final publicRoutes = [
    SGRoute.login.route,
    SGRoute.firetruckGPS.route,
    SGRoute.firetruckGPSLogin.route,
    SGRoute.reportHistory.route,
  ];

  // Determine initial location based on splash screen flag and auth status
  final splashShown = authLocalDataSource.isSplashShown();
  final initialLocation = () {
    if (!splashShown) {
      // First time app launch - show splash screen
      return SGRoute.splash.route;
    } else if (authStatus == AuthStatus.authenticated) {
      // User is authenticated - go to firetruck GPS
      return SGRoute.firetruckGPS.route;
    } else {
      // User not authenticated - go to login
      return SGRoute.login.route;
    }
  }();

  return GoRouter(
    initialLocation: initialLocation,
    // initialLocation: SGRoute.reportIncident.route,
    // initialLocation: SGRoute.trackfiretruck.route,
    // initialLocation: SGRoute.firetruckGPS.route,
    // initialLocation: SGRoute.firetruckGPSLogin.route,
    navigatorKey: rootNavigatorKey, // ✅ Pass here
    redirect: (context, state) {
      final isAuthenticated = authStatus == AuthStatus.authenticated;
      final isPublicRoute = publicRoutes.contains(state.matchedLocation);
      final isSplashRoute = state.matchedLocation == SGRoute.splash.route;

      // Don't redirect from splash screen - let it handle navigation
      if (isSplashRoute) {
        return null;
      }

      // If not logged in and trying to access protected route
      if (!isAuthenticated && !isPublicRoute) {
        return SGRoute.login.route;
      }

      // If logged in and trying to access public route (except splash)
      if (isAuthenticated && isPublicRoute) {
        return SGRoute.firetruckGPS.route;
      }

      return null;
    },

    routes: <GoRoute>[
      GoRoute(
        path: SGRoute.splash.route,
        builder: (_, __) => const SplashScreen(),
      ).fade(),

      GoRoute(
        path: SGRoute.login.route,
        builder: (_, __) => const LoginScreen(),
      ).fade(),

      GoRoute(
        path: SGRoute.firetruckGPS.route,
        builder: (_, __) => const FiretruckGPSPage(),
      ).fade(),
    ],
  );
}
