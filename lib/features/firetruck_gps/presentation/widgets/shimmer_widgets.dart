import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/app_theme.dart';

class DispatchShimmerWidgets {
  static Widget shimmerEffect({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: AppTheme.surfaceGrey,
      highlightColor: AppTheme.backgroundWhite,
      child: child,
    );
  }

  static Widget shimmerContainer({
    BuildContext? context,
    double width = double.infinity,
    double? height,
    double? responsiveHeight,
  }) {
    final containerHeight =
        height ??
        (context != null
            ? context.responsiveValue(
                small: responsiveHeight ?? 16.0,
                medium: responsiveHeight != null
                    ? responsiveHeight * 1.2
                    : 20.0,
                large: responsiveHeight != null ? responsiveHeight * 1.4 : 24.0,
                extraLarge: responsiveHeight != null
                    ? responsiveHeight * 1.4
                    : 24.0,
              )
            : 16.0);

    return Container(
      width: width,
      height: containerHeight,
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  static Widget buildDispatchInfoShimmer(BuildContext context) {
    return shimmerEffect(
      child: Container(
        padding: context.responsivePadding(
          small: EdgeInsets.all(AppTheme.spacing8),
          medium: EdgeInsets.all(AppTheme.spacing12),
          large: EdgeInsets.all(AppTheme.spacing16),
          extraLarge: EdgeInsets.all(AppTheme.spacing16),
        ),
        decoration: BoxDecoration(
          color: AppTheme.secondaryOrange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radius8),
          border: Border.all(
            color: AppTheme.secondaryOrange.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: context.responsiveValue(
                small: 16.0,
                medium: 20.0,
                large: 24.0,
                extraLarge: 24.0,
              ),
              height: context.responsiveValue(
                small: 16.0,
                medium: 20.0,
                large: 24.0,
                extraLarge: 24.0,
              ),
              decoration: BoxDecoration(
                color: AppTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(
              width: context.responsiveValue(
                small: AppTheme.spacing6,
                medium: AppTheme.spacing8,
                large: AppTheme.spacing12,
                extraLarge: AppTheme.spacing12,
              ),
            ),
            Expanded(
              child: shimmerContainer(context: context, responsiveHeight: 16),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildReporterInfoShimmer(BuildContext context) {
    return shimmerEffect(
      child: Row(
        children: [
          Container(
            width: context.responsiveValue(
              small: 20.0,
              medium: 24.0,
              large: 28.0,
              extraLarge: 28.0,
            ),
            height: context.responsiveValue(
              small: 20.0,
              medium: 24.0,
              large: 28.0,
              extraLarge: 28.0,
            ),
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(
            width: context.responsiveValue(
              small: AppTheme.spacing8,
              medium: AppTheme.spacing12,
              large: AppTheme.spacing16,
              extraLarge: AppTheme.spacing16,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerContainer(
                  context: context,
                  width: 120,
                  responsiveHeight: 16,
                ),
                SizedBox(
                  height: context.responsiveValue(
                    small: AppTheme.spacing4,
                    medium: AppTheme.spacing6,
                    large: AppTheme.spacing8,
                    extraLarge: AppTheme.spacing8,
                  ),
                ),
                Row(
                  children: [
                    shimmerContainer(
                      context: context,
                      width: 60,
                      responsiveHeight: 20,
                    ),
                    SizedBox(
                      width: context.responsiveValue(
                        small: AppTheme.spacing8,
                        medium: AppTheme.spacing12,
                        large: AppTheme.spacing16,
                        extraLarge: AppTheme.spacing16,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: context.responsiveValue(
                            small: 14.0,
                            medium: 16.0,
                            large: 18.0,
                            extraLarge: 18.0,
                          ),
                          height: context.responsiveValue(
                            small: 14.0,
                            medium: 16.0,
                            large: 18.0,
                            extraLarge: 18.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundWhite,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(
                          width: context.responsiveValue(
                            small: AppTheme.spacing2,
                            medium: AppTheme.spacing4,
                            large: AppTheme.spacing6,
                            extraLarge: AppTheme.spacing6,
                          ),
                        ),
                        shimmerContainer(
                          context: context,
                          width: 80,
                          responsiveHeight: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildTimeShimmer(BuildContext context) {
    return shimmerEffect(
      child: Row(
        children: [
          Container(
            width: context.responsiveValue(
              small: 20.0,
              medium: 24.0,
              large: 28.0,
              extraLarge: 28.0,
            ),
            height: context.responsiveValue(
              small: 20.0,
              medium: 24.0,
              large: 28.0,
              extraLarge: 28.0,
            ),
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(
            width: context.responsiveValue(
              small: AppTheme.spacing8,
              medium: AppTheme.spacing12,
              large: AppTheme.spacing16,
              extraLarge: AppTheme.spacing16,
            ),
          ),
          shimmerContainer(context: context, width: 180, responsiveHeight: 16),
        ],
      ),
    );
  }

  static Widget buildIncidentDetailsShimmer(BuildContext context) {
    return Column(
      children: [
        shimmerEffect(
          child: shimmerContainer(
            context: context,
            width: 100,
            responsiveHeight: 16,
          ),
        ),
        SizedBox(
          height: context.responsiveValue(
            small: AppTheme.spacing6,
            medium: AppTheme.spacing8,
            large: AppTheme.spacing10,
            extraLarge: AppTheme.spacing10,
          ),
        ),
        shimmerEffect(
          child: Column(
            children: [
              shimmerContainer(context: context, responsiveHeight: 14),
              SizedBox(
                height: context.responsiveValue(
                  small: 3.0,
                  medium: 4.0,
                  large: 5.0,
                  extraLarge: 5.0,
                ),
              ),
              shimmerContainer(context: context, responsiveHeight: 14),
              SizedBox(
                height: context.responsiveValue(
                  small: 3.0,
                  medium: 4.0,
                  large: 5.0,
                  extraLarge: 5.0,
                ),
              ),
              shimmerContainer(
                context: context,
                width: 200,
                responsiveHeight: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildPhotoShimmer(BuildContext context) {
    return shimmerEffect(
      child: Column(
        children: [
          SizedBox(
            height: context.responsiveValue(
              small: AppTheme.spacing12,
              medium: AppTheme.spacing16,
              large: AppTheme.spacing20,
              extraLarge: AppTheme.spacing20,
            ),
          ),
          shimmerContainer(
            context: context,
            width: double.infinity,
            height: context.responsiveValue(
              small: 140.0,
              medium: 180.0,
              large: 220.0,
              extraLarge: 220.0,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildLocationShimmer(BuildContext context) {
    return shimmerEffect(
      child: Row(
        children: [
          Container(
            width: context.responsiveValue(
              small: 20.0,
              medium: 24.0,
              large: 28.0,
              extraLarge: 28.0,
            ),
            height: context.responsiveValue(
              small: 20.0,
              medium: 24.0,
              large: 28.0,
              extraLarge: 28.0,
            ),
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(
            width: context.responsiveValue(
              small: AppTheme.spacing6,
              medium: AppTheme.spacing8,
              large: AppTheme.spacing12,
              extraLarge: AppTheme.spacing12,
            ),
          ),
          Expanded(
            child: shimmerContainer(context: context, responsiveHeight: 12),
          ),
        ],
      ),
    );
  }

  static Widget buildCompleteDispatchShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDispatchInfoShimmer(context),
        SizedBox(
          height: context.responsiveValue(
            small: AppTheme.spacing16,
            medium: AppTheme.spacing20,
            large: AppTheme.spacing24,
            extraLarge: AppTheme.spacing24,
          ),
        ),
        buildReporterInfoShimmer(context),
        SizedBox(
          height: context.responsiveValue(
            small: AppTheme.spacing16,
            medium: AppTheme.spacing20,
            large: AppTheme.spacing24,
            extraLarge: AppTheme.spacing24,
          ),
        ),
        buildTimeShimmer(context),
        SizedBox(
          height: context.responsiveValue(
            small: AppTheme.spacing16,
            medium: AppTheme.spacing20,
            large: AppTheme.spacing24,
            extraLarge: AppTheme.spacing24,
          ),
        ),
        buildIncidentDetailsShimmer(context),
        buildPhotoShimmer(context),
        SizedBox(
          height: context.responsiveValue(
            small: AppTheme.spacing16,
            medium: AppTheme.spacing20,
            large: AppTheme.spacing24,
            extraLarge: AppTheme.spacing24,
          ),
        ),
        buildLocationShimmer(context),
        SizedBox(
          height: context.responsiveValue(
            small: AppTheme.spacing16,
            medium: AppTheme.spacing20,
            large: AppTheme.spacing24,
            extraLarge: AppTheme.spacing24,
          ),
        ),
      ],
    );
  }
}
