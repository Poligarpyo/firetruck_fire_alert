import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/handleLogin.dart';
import 'controller/auth_ui_model.dart';
import 'controller/login_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    setState(() => _isSubmitting = false); // reset spinner here too
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: AppTheme.backgroundWhite.withValues(alpha: 0),
        insetPadding: EdgeInsets.symmetric(horizontal: AppTheme.spacing32),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: BorderRadius.circular(AppTheme.radius20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.textPrimary.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Red top strip
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spacing12,
                ),
                decoration: const BoxDecoration(
                  color: AppTheme.errorRed,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppTheme.radius20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacing12),
                      decoration: BoxDecoration(
                        color: AppTheme.textWhite.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        color: AppTheme.textWhite,
                        size: AppTheme.iconSize36,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing10),
                    Text(
                      'Login Failed',
                      style: AppTheme.h6.copyWith(
                        color: AppTheme.textWhite,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Message body
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppTheme.spacing24,
                  AppTheme.spacing20,
                  AppTheme.spacing24,
                  AppTheme.spacing8,
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textPrimary,
                    height: 1.6,
                  ),
                ),
              ),

              // Divider
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
                child: Divider(
                  height: AppTheme.spacing24,
                  color: AppTheme.textSecondary.withValues(alpha: 0.3),
                ),
              ),

              // Actions
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppTheme.spacing16,
                  0,
                  AppTheme.spacing16,
                  AppTheme.spacing16,
                ),
                child: Row(
                  children: [
                    // Dismiss
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: AppTheme.spacing12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radius12,
                            ),
                            side: BorderSide(
                              color: AppTheme.textSecondary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Dismiss',
                          style: AppTheme.buttonMedium.copyWith(
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacing10),
                    // Try Again
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorRed,
                          foregroundColor: AppTheme.textWhite,
                          padding: EdgeInsets.symmetric(
                            vertical: AppTheme.spacing12,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radius12,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          // re-trigger the form submit on retry
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isSubmitting = true);
                            handleLogin(
                              context,
                              ref,
                              _usernameController,
                              _passwordController,
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.refresh_rounded,
                              size: AppTheme.iconSize16,
                            ),
                            SizedBox(width: AppTheme.spacing6),
                            Text(
                              'Try Again',
                              style: AppTheme.buttonMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Responsive helper methods
  EdgeInsets _getResponsivePadding(
    bool isSmallScreen,
    bool isTablet,
    bool isLargeTablet,
    bool isDesktop,
  ) {
    if (isSmallScreen) {
      return EdgeInsets.all(AppTheme.spacing16);
    } else if (isTablet) {
      return EdgeInsets.all(AppTheme.spacing24);
    } else if (isLargeTablet) {
      return EdgeInsets.all(AppTheme.spacing32);
    } else if (isDesktop) {
      return EdgeInsets.all(AppTheme.spacing40);
    } else {
      return EdgeInsets.all(AppTheme.spacing16);
    }
  }

  EdgeInsets _getResponsiveContainerPadding(
    bool isSmallScreen,
    bool isTablet,
    bool isLargeTablet,
    bool isDesktop,
  ) {
    if (isSmallScreen) {
      return EdgeInsets.all(AppTheme.spacing16);
    } else if (isTablet) {
      return EdgeInsets.all(AppTheme.spacing24);
    } else if (isLargeTablet) {
      return EdgeInsets.all(AppTheme.spacing28);
    } else if (isDesktop) {
      return EdgeInsets.all(AppTheme.spacing32);
    } else {
      return EdgeInsets.all(AppTheme.spacing20);
    }
  }

  double _getResponsiveLogoSize(
    bool isSmallScreen,
    bool isTablet,
    bool isLargeTablet,
    bool isDesktop,
  ) {
    if (isSmallScreen) return 60;
    if (isTablet) return 80;
    if (isLargeTablet) return 90;
    if (isDesktop) return 100;
    return 80; // default mobile
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(loginControllerProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < AppTheme.smallScreenBreakpoint;
    final isTablet =
        screenWidth >= AppTheme.tabletBreakpoint &&
        screenWidth < AppTheme.largeTabletBreakpoint;
    final isLargeTablet =
        screenWidth >= AppTheme.largeTabletBreakpoint &&
        screenWidth < AppTheme.desktopBreakpoint;
    final isDesktop = screenWidth >= AppTheme.desktopBreakpoint;

    // Listen to login state changes
    ref.listen<AuthUiModel>(loginControllerProvider, (previous, next) {
      if (previous == next) return;

      // Sync spinner with controller's isLoading
      if (next.isLoading != _isSubmitting) {
        setState(() => _isSubmitting = next.isLoading);
      }

      // Error -> show dialog
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        _showErrorDialog(next.errorMessage!);
        return;
      }

      // Success -> already handled inside controller via authController
      // so nothing needed here
    });
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: const Text('FireTrack Login').tr(),
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: AppTheme.textWhite,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: _getResponsivePadding(
            isSmallScreen,
            isTablet,
            isLargeTablet,
            isDesktop,
          ),
          child: Container(
            padding: _getResponsiveContainerPadding(
              isSmallScreen,
              isTablet,
              isLargeTablet,
              isDesktop,
            ),
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(AppTheme.radius12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowColor.withValues(alpha: 0.15),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/img/Screenshot_2026-04-10_161648-removebg-preview.png',
                      width: _getResponsiveLogoSize(
                        isSmallScreen,
                        isTablet,
                        isLargeTablet,
                        isDesktop,
                      ),
                      height: _getResponsiveLogoSize(
                        isSmallScreen,
                        isTablet,
                        isLargeTablet,
                        isDesktop,
                      ),
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to icon if image not found
                        return Icon(
                          Icons.local_fire_department,
                          size:
                              _getResponsiveLogoSize(
                                isSmallScreen,
                                isTablet,
                                isLargeTablet,
                                isDesktop,
                              ) -
                              20,
                          color: AppTheme.primaryRed,
                        );
                      },
                    ),
                    SizedBox(height: AppTheme.spacing16),
                    Text(
                      'Firetruck GPS System',
                      style: AppTheme.h4.copyWith(color: AppTheme.primaryRed),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Please login with your agent account',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppTheme.spacing24),
                    CustomTextField(
                      controller: _usernameController,
                      hintText: 'Username',
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.text,
                      inputFormatters: [],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppTheme.spacing16),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: authState.showPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onSuffixIconPressed: () {
                        ref
                            .read(loginControllerProvider.notifier)
                            .togglePasswordVisibility();
                      },
                      keyboardType: TextInputType.text,
                      obscureText: !authState.showPassword,
                      inputFormatters: [],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppTheme.spacing20),
                    CustomButton(
                      text: 'Login',
                      textColor: AppTheme.textWhite,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isSubmitting = true;
                          });
                          handleLogin(
                            context,
                            ref,
                            _usernameController,
                            _passwordController,
                          );
                        }
                      },
                      isLoading: _isSubmitting,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
