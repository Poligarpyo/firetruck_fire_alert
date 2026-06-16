import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/enums/sg_route.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../router/app_router.dart';
 

class PrivacyPolicyPage extends ConsumerWidget {
  const PrivacyPolicyPage({super.key});

  /// Go back to HomeScreen at the Profile tab (index 2).

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void goBackToProfile() {
      // ref.read(selectedTabProvider.notifier).state = 2;
      context.go(SGRoute.home.route);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
            // Header
            Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppTheme.primaryRed,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'Last updated: April 11, 2026',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Introduction
            _buildSection(
              title: 'Introduction',
              content:
                  'Fire Alert ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our Fire Alert mobile application.',
              context: context,
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Information We Collect
            _buildSection(
              title: 'Information We Collect',
              content: '',
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSubsection(
                    title: 'Personal Information',
                    content:
                        'When you register for an account, we collect:\n'
                        '· Name and email address\n'
                        '· Phone number\n'
                        '· Profile information (optional)\n'
                        '· Emergency contact details',
                  ),
                  _buildSubsection(
                    title: 'Location Information',
                    content:
                        'With your explicit consent, we collect:\n'
                        '· GPS coordinates when reporting incidents\n'
                        '· Approximate location based on network\n'
                        '· Location history for incident tracking',
                  ),
                  _buildSubsection(
                    title: 'Device Information',
                    content:
                        'We automatically collect:\n'
                        '· Device type and operating system\n'
                        '· Unique device identifiers\n'
                        '· Mobile network information\n'
                        '· App usage statistics',
                  ),
                  _buildSubsection(
                    title: 'Incident Reports',
                    content:
                        'When you report incidents, we collect:\n'
                        '· Incident type and description\n'
                        '· Photos and videos (with permission)\n'
                        '· Timestamp of report\n'
                        '· Location data',
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing24),

            // How We Use Your Information
            _buildSection(
              title: 'How We Use Your Information',
              content: '',
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUsageItem(
                    'Emergency Response',
                    'To coordinate with emergency services and first responders',
                  ),
                  _buildUsageItem(
                    'Service Improvement',
                    'To analyze incident patterns and improve our services',
                  ),
                  _buildUsageItem(
                    'Communication',
                    'To send you important notifications and updates',
                  ),
                  _buildUsageItem(
                    'Safety Features',
                    'To provide location tracking and safety monitoring',
                  ),
                  _buildUsageItem(
                    'Legal Compliance',
                    'To comply with legal obligations and protect public safety',
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Information Sharing
            _buildSection(
              title: 'Information Sharing',
              content:
                  'We may share your information in the following circumstances:',
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSharingItem(
                    'Emergency Services',
                    'With fire departments, police, and medical services during emergencies',
                  ),
                  _buildSharingItem(
                    'Government Agencies',
                    'When required by law or to protect public safety',
                  ),
                  _buildSharingItem(
                    'Service Providers',
                    'With trusted third-party service providers who help us operate our service',
                  ),
                  _buildSharingItem(
                    'Research',
                    'Anonymized data for fire safety research and prevention studies',
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Data Security
            _buildSection(
              title: 'Data Security',
              content:
                  'We implement industry-standard security measures to protect your information, including:\n\n'
                  '· End-to-end encryption for sensitive data\n'
                  '· Secure servers with 24/7 monitoring\n'
                  '· Regular security audits and updates\n'
                  '· Employee training on data protection\n'
                  '· Limited access to personal information\n\n'
                  'However, no method of transmission over the internet is 100% secure.',
              context: context,
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Your Rights
            _buildSection(
              title: 'Your Rights',
              content:
                  'You have the right to:\n\n'
                  '· Access your personal information\n'
                  '· Correct inaccurate information\n'
                  '· Delete your account and data\n'
                  '· Opt-out of non-essential communications\n'
                  '· Request data portability\n'
                  '· Restrict processing of certain information\n\n'
                  'To exercise these rights, contact us at privacy@firealert.com',
              context: context,
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Data Retention
            _buildSection(
              title: 'Data Retention',
              content:
                  'We retain your information only as long as necessary for:\n\n'
                  '· Providing our services\n'
                  '· Legal compliance requirements\n'
                  '· Safety and emergency response purposes\n'
                  '· Legitimate business interests\n\n'
                  'Incident reports may be retained longer for safety analysis and prevention purposes.',
              context: context,
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Children's Privacy
            _buildSection(
              title: 'Children\'s Privacy',
              content:
                  'Our service is not intended for children under 13. We do not knowingly collect personal information from children under 13. If we become aware that we have collected such information, we will delete it promptly.',
              context: context,
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Changes to This Policy
            _buildSection(
              title: 'Changes to This Policy',
              content:
                  'We may update this Privacy Policy from time to time. We will notify you of any changes by:\n\n'
                  '· Posting the new policy in the app\n'
                  '· Sending you an email notification\n'
                  '· In-app notifications for significant changes\n\n'
                  'Your continued use of the service after changes constitutes acceptance of the updated policy.',
              context: context,
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Contact Information
            _buildSection(
              title: 'Contact Us',
              content:
                  'If you have questions about this Privacy Policy or our data practices, please contact us:\n\n'
                  'Email: privacy@firealert.com\n'
                  'Phone: +1-800-FIRE-HELP\n'
                  'Website: www.firealert.com\n\n'
                  'For data protection inquiries: dpo@firealert.com',
              context: context,
            ),

            const SizedBox(height: AppTheme.spacing32),
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

  Widget _buildSubsection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryRed,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          Padding(
            padding: const EdgeInsets.only(left: AppTheme.spacing20),
            child: Text(
              content,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radius6),
            ),
            child: const Icon(
              Ionicons.checkmark_outline,
              color: AppTheme.primaryRed,
              size: 16,
            ),
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
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing2),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSharingItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.secondaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radius6),
            ),
            child: const Icon(
              Ionicons.share_outline,
              color: AppTheme.secondaryOrange,
              size: 16,
            ),
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
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing2),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
