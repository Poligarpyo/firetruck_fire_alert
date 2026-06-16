import 'package:flutter/material.dart';
import '../widgets/mapButton.dart';
import '../../../../shared/theme/app_theme.dart';

class MapControls extends StatelessWidget {
  final VoidCallback zoomIn;
  final VoidCallback zoomOut;
  final VoidCallback center;
  final VoidCallback fitBounds;
  final double edgeInset;
  final double controlSpacing;

  const MapControls({
    super.key,
    required this.zoomIn,
    required this.zoomOut,
    required this.center,
    required this.fitBounds,
    required this.edgeInset,
    required this.controlSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: edgeInset,
      top: MediaQuery.paddingOf(context).top + edgeInset,
      child: Column(
        children: [
          mapButton(context, Icons.add, zoomIn, 'zoomIn'),
          SizedBox(height: controlSpacing),
          mapButton(context, Icons.remove, zoomOut, 'zoomOut'),
          SizedBox(height: controlSpacing),
          mapButton(
            context,
            Icons.my_location,
            center,
            'centerLocation',
            color: AppTheme.primaryRed,
          ),
          SizedBox(height: controlSpacing),
          mapButton(
            context,
            Icons.fit_screen,
            fitBounds,
            'fitBounds',
            color: AppTheme.secondaryOrange,
          ),
        ],
      ),
    );
  }
}
