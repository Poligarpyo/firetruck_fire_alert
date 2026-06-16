import 'package:flutter/material.dart';
import '../controller/state.dart';
import '../widgets/line_painter.dart';
import '../../../../shared/theme/app_theme.dart';

class MapLegend extends StatelessWidget {
  final FireTruckState truckState;

  const MapLegend({super.key, required this.truckState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveValue(
          small: AppTheme.spacing6,
          medium: AppTheme.spacing8,
          large: AppTheme.spacing10,
          extraLarge: AppTheme.spacing12,
        ),
        vertical: context.responsiveValue(
          small: AppTheme.spacing4,
          medium: AppTheme.spacing6,
          large: AppTheme.spacing8,
          extraLarge: AppTheme.spacing10,
        ),
      ),
      decoration: BoxDecoration(
        color: AppTheme.textPrimary.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppTheme.radius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _legendItem(
            context,
            color: AppTheme.infoBlue,
            label: 'Fastest Route',
            dashed: false,
            hasData: truckState.routePoints.isNotEmpty,
          ),
          // Todo: Uncomment mo lang to kapag Gusto mo my static na line sa Firestation to Fire Destination
          // SizedBox(height: AppTheme.spacing4),
          // _legendItem(
          //   context,
          //   color: AppTheme.secondaryOrange,
          //   label: 'Station → Fire',
          //   dashed: true,
          //   hasData: truckState.stationRoutePoints.isNotEmpty,
          // ),
        ],
      ),
    );
  }

  Widget _legendItem(
    BuildContext context, {
    required Color color,
    required String label,
    required bool dashed,
    required bool hasData,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: context.responsiveIconSize(
            small: AppTheme.iconSize20,
            medium: AppTheme.iconSize24,
            large: AppTheme.iconSize24,
            extraLarge: AppTheme.iconSize24,
          ),
          child: CustomPaint(
            painter: LinePainter(color: color, dashed: dashed),
            size: Size(
              context.responsiveIconSize(
                small: AppTheme.iconSize20,
                medium: AppTheme.iconSize24,
                large: AppTheme.iconSize24,
                extraLarge: AppTheme.iconSize24,
              ),
              3,
            ),
          ),
        ),
        SizedBox(
          width: context.responsiveValue(
            small: AppTheme.spacing4,
            medium: AppTheme.spacing6,
            large: AppTheme.spacing8,
            extraLarge: AppTheme.spacing10,
          ),
        ),
        Text(
          label,
          style: AppTheme.overline.copyWith(
            color: hasData
                ? AppTheme.textWhite
                : AppTheme.textWhite.withValues(alpha: 0.7),
            fontSize: context.responsiveValue(
              small: AppTheme.fontSize10,
              medium: AppTheme.fontSize11,
              large: AppTheme.fontSize12,
              extraLarge: AppTheme.fontSize13,
            ),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
