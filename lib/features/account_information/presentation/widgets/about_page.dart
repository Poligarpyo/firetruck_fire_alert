import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/enums/sg_route.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../router/app_router.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void goBackToProfile() {
      // ref.read(selectedTabProvider.notifier).state = 2;
      context.go(SGRoute.home.route);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: AppTheme.textWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: goBackToProfile,
        ),
      ),
      backgroundColor: AppTheme.backgroundWhite,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Name
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/img/fire-icon.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryRed,
                            borderRadius: BorderRadius.circular(
                              AppTheme.radius20,
                            ),
                          ),
                          child: const Icon(
                            Icons.error,
                            color: Colors.white,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  Text(
                    'Fire Alert',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppTheme.primaryRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Text(
                    'Version 1.0.0',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing32),

            // Description
            _buildSection(
              title: 'About Fire Alert',
              content:
                  'Fire Alert is a comprehensive emergency reporting system designed to help users quickly report fire incidents and other emergency situations. Our mission is to provide fast, reliable communication during emergencies to help save lives and property.',
              context: context,
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Key Features
            _buildSection(
              title: 'Key Features',
              content: '',
              context: context,
              child: Column(
                children: [
                  _buildFeatureItem(
                    icon: Ionicons.flash_outline,
                    title: 'Quick Incident Reporting',
                    description:
                        'Report emergencies instantly with detailed information',
                  ),
                  _buildFeatureItem(
                    icon: Ionicons.location_outline,
                    title: 'GPS Location Tracking',
                    description:
                        'Automatically capture and share incident locations',
                  ),
                  _buildFeatureItem(
                    icon: Ionicons.notifications_outline,
                    title: 'Real-time Notifications',
                    description:
                        'Receive instant updates about emergency incidents',
                  ),
                  _buildFeatureItem(
                    icon: Ionicons.phone_portrait_outline,
                    title: 'Offline SMS Support',
                    description:
                        'Send reports via SMS when internet is unavailable',
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Contact Information
            _buildSection(
              title: 'Contact Us',
              content: '',
              context: context,
              child: Column(
                children: [
                  _buildContactItem(
                    icon: Ionicons.mail_outline,
                    title: 'Email',
                    value: 'support@firealert.com',
                  ),
                  _buildContactItem(
                    icon: Ionicons.call_outline,
                    title: 'Emergency Hotline',
                    value: '+1-800-FIRE-HELP',
                  ),
                  _buildContactItem(
                    icon: Ionicons.globe_outline,
                    title: 'Website',
                    value: 'www.firealert.com',
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing32),

            // Copyright
            Center(
              child: Text(
                '© 2026 Fire Alert. All rights reserved.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required BuildContext context,
    Widget? child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacing12),
        if (content.isNotEmpty)
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        if (child != null) child,
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radius8),
            ),
            child: Icon(icon, color: AppTheme.primaryRed, size: 20),
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryRed, size: 20),
          const SizedBox(width: AppTheme.spacing12),
          Text(
            '$title: ',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
