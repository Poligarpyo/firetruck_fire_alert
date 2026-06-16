import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/auth_local_datasource_provider.dart';
import '../../../account_information/presentation/providers/account_providers.dart';
import '../../../authentication/domain/auth/auth_controller.dart';
import '../../../../shared/theme/app_theme.dart';

class ProfileDropdown extends ConsumerWidget {
  const ProfileDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(cachedAccountProvider);
    if (account == null) return const Text('No user data');
    return IconButton(
      onPressed: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final RenderBox? overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox?;
          if (overlay != null && overlay.hasSize) {
            final result =
                showMenu<String>(
                  context: context,
                  position: RelativeRect.fromRect(
                    Rect.fromLTWH(
                      context.responsiveValue(
                        small: overlay.size.width - 160,
                        medium: overlay.size.width - 200,
                        large: overlay.size.width - 240,
                        extraLarge: overlay.size.width - 280,
                      ),
                      context.responsiveValue(
                        small: 40.0,
                        medium: 50.0,
                        large: 60.0,
                        extraLarge: 70.0,
                      ),
                      context.responsiveValue(
                        small: 160.0,
                        medium: 200.0,
                        large: 240.0,
                        extraLarge: 280.0,
                      ),
                      context.responsiveValue(
                        small: 120.0,
                        medium: 140.0,
                        large: 160.0,
                        extraLarge: 180.0,
                      ),
                    ),
                    Offset.zero & overlay.size,
                  ),
                  items: [
                    PopupMenuItem<String>(
                      value: 'profile_header',
                      enabled: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.display_name,
                            style: AppTheme.bodyLarge.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: AppTheme.spacing2),
                          Text(
                            account.phone,
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(
                            Icons.exit_to_app,
                            color: AppTheme.textPrimary,
                            size: AppTheme.iconSize16,
                          ),
                          SizedBox(width: AppTheme.spacing8),
                          Text(
                            'Logout',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).then((value) {
                  if (value == 'logout') {
                    ref
                        .read(authControllerProvider.notifier)
                        .logout(message: "Logged out successfully");
                  }
                });
          }
        });
      },
      icon: Icon(
        Icons.person_outline,
        color: AppTheme.textWhite,
        size: context.responsiveIconSize(
          small: AppTheme.iconSize20,
          medium: AppTheme.iconSize24,
          large: AppTheme.iconSize24,
          extraLarge: AppTheme.iconSize24,
        ),
      ),
    );
  }
}
