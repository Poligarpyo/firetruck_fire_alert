import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/enums/auth_status.dart';
import '../../../data/enums/sg_route.dart';
import '../../authentication/domain/auth/auth_controller.dart';
import '../../../core/storage/auth_local_datasource_provider.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();
    print('SplashScreen: initState called');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authLocalDataSourceProvider).setSplashShown();
    });

    _initializeAnimations();
    _navigateToNextScreen();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.65)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
          ),
        );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.83, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        final authStatus = ref.read(authControllerProvider);

        if (authStatus == AuthStatus.authenticated) {
          context.go(SGRoute.firetruckGPS.route);
        } else {
          context.go(SGRoute.login.route);
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('SplashScreen: build method called');
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Image.asset(
                        'assets/img/Screenshot_2026-04-10_161648-removebg-preview.png',
                        width: 150,
                        height: 150,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.local_fire_department,
                            size: 150,
                            color: AppTheme.primaryRed,
                          );
                        },
                      ),
                    ),
                  ),
                ),

                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 160),
                      Text(
                        'FireTrack',
                        style: AppTheme.h3.copyWith(
                          fontSize: AppTheme.fontSize32,
                          color: AppTheme.primaryRed,
                          letterSpacing: 2,
                        ),
                      ),

                      SizedBox(height: AppTheme.spacing12),

                      Text(
                        'Incident Tracking System',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textSecondary,
                          letterSpacing: 1.0,
                        ),
                      ),

                      SizedBox(height: AppTheme.spacing56),

                      SizedBox(
                        width: AppTheme.iconSize40,
                        height: AppTheme.iconSize40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
