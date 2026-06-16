import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/common/logout_confimation.dart';
import '../../../../shared/theme/app_theme.dart';
import '../providers/account_providers.dart';
import '../widgets/account_error.dart';
import '../widgets/account_header.dart';
import '../widgets/account_loading.dart';
import '../widgets/stats_grid.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: Text(
          'Account',
          style: AppTheme.h6.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppTheme.backgroundWhite,
        foregroundColor: AppTheme.textPrimary,
      ),
      body: state.when(
        loading: () => const AccountLoading(),
        error: (error, _) => AccountError(error.toString()),
        data: (account) => SingleChildScrollView(
          padding: context.responsivePadding(
            small: EdgeInsets.all(AppTheme.spacing12),
            medium: EdgeInsets.all(AppTheme.spacing16),
            large: EdgeInsets.all(AppTheme.spacing20),
            extraLarge: EdgeInsets.all(AppTheme.spacing24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AccountHeader(account: account),
              SizedBox(
                height: context.responsiveValue(
                  small: AppTheme.spacing12,
                  medium: AppTheme.spacing16,
                  large: AppTheme.spacing20,
                  extraLarge: AppTheme.spacing24,
                ),
              ),
              StatsGrid(account: account),
              SizedBox(
                height: context.responsiveValue(
                  small: AppTheme.spacing20,
                  medium: AppTheme.spacing24,
                  large: AppTheme.spacing28,
                  extraLarge: AppTheme.spacing32,
                ),
              ),
              Text(
                'Account Details',
                style: context.responsiveBodyText(
                  fontSizeSmall: AppTheme.fontSize18,
                  fontSizeMedium: AppTheme.fontSize20,
                  fontSizeLarge: AppTheme.fontSize22,
                  fontSizeExtraLarge: AppTheme.fontSize24,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: context.responsiveValue(
                  small: AppTheme.spacing8,
                  medium: AppTheme.spacing12,
                  large: AppTheme.spacing16,
                  extraLarge: AppTheme.spacing16,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.logout, color: AppTheme.errorRed),
                    title: Text(
                      'Logout',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.errorRed,
                      ),
                    ),
                    onTap: () {
                      showLogoutDialog(context, ref);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
