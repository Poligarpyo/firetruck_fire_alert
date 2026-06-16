import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'data/enums/auth_status.dart';
import 'shared/common/connectivity_listener.dart';
import 'shared/common/navigation_keys.dart';
import 'shared/theme/app_theme.dart';
import 'core/provider/connectivity_listener_provider.dart';
import 'features/authentication/domain/auth/auth_controller.dart';
import 'router/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(autoSyncProvider); // 👈 activate sync listener

    final GoRouter router = ref.watch(goRouterProvider);

    ref.listen<AuthStatus>(authControllerProvider, (previous, next) {
      if (previous == AuthStatus.authenticated &&
          next == AuthStatus.unauthenticated) {}
    });

    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldMessengerKey,
      routerConfig: router,
      title: 'FireTrack',
      theme: AppTheme.lightTheme,
      // themeMode: currentTheme.themeMode,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        return ConnectivityListener(child: child!);
      },
    );
  }
}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
}
