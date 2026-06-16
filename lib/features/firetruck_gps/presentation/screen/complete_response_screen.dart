import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/ui/global_loader_provider.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../domain/entities/incident_photo_kind.dart';
import '../providers/dispatch_feed_provider.dart';
import '../providers/firetruck_location_providers.dart';
import '../providers/incident_photo_providers.dart';
import '../widgets/incident_photo_capture_card.dart';

class CompleteResponseScreen extends ConsumerStatefulWidget {
  const CompleteResponseScreen({super.key, required this.dispatch});

  final DispatchInfo dispatch;

  @override
  ConsumerState<CompleteResponseScreen> createState() =>
      _CompleteResponseScreenState();
}

class _CompleteResponseScreenState
    extends ConsumerState<CompleteResponseScreen> {
  DateTime? resolvedAt;

  @override
  void initState() {
    super.initState();
    resolvedAt = DateTime.now();
  }

  Future<DateTime?> _pickDateTime(
    BuildContext context,
    DateTime initialValue,
  ) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialValue,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return null;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialValue),
    );
    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  Widget _buildTimeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required DateTime time,
    required VoidCallback? onTap,
    bool editable = true,
    String? helperText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceGrey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(
          color: AppTheme.textSecondary.withValues(alpha: 0.2),
        ),
      ),
      child: Material(
        color: AppTheme.backgroundWhite.withValues(alpha: 0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radius12),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacing16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppTheme.spacing12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radius8),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryRed,
                    size: AppTheme.iconSize20,
                  ),
                ),
                SizedBox(width: AppTheme.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppTheme.spacing4),
                      Text(
                        DateFormat('MMM d, y • h:mm a').format(time),
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (helperText != null) ...[
                        SizedBox(height: AppTheme.spacing4),
                        Text(
                          helperText,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  editable ? Icons.edit_calendar : Icons.gps_fixed,
                  color: editable
                      ? AppTheme.textSecondary
                      : AppTheme.primaryRed,
                  size: AppTheme.iconSize20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _completeResponse() async {
    final arrivedAt =
        widget.dispatch.arrivedAt ??
        widget.dispatch.createdAt ??
        DateTime.now();
    final currentResolvedAt = resolvedAt ?? DateTime.now();

    if (currentResolvedAt.isBefore(arrivedAt)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.errorRed,
          content: Row(
            children: [
              Icon(Icons.error_outline, color: AppTheme.textWhite),
              SizedBox(width: AppTheme.spacing8),
              Expanded(
                child: Text(
                  'Resolved time must be after arrived time.',
                  style: AppTheme.bodySmall.copyWith(color: AppTheme.textWhite),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    final photoStatus = await ref.read(
      incidentPhotoStatusProvider(
        IncidentPhotoRequest(
          incidentId: widget.dispatch.incidentId,
          incidentData: widget.dispatch.incidentData,
        ),
      ).future,
    );
    if (!photoStatus.hasAfter) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.errorRed,
          content: Text(
            'Take an after-response photo before completing.',
            style: AppTheme.bodySmall.copyWith(color: AppTheme.textWhite),
          ),
        ),
      );
      return;
    }
    if (!photoStatus.hasBefore) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.errorRed,
          content: Text(
            'Take a before-scene photo before completing.',
            style: AppTheme.bodySmall.copyWith(color: AppTheme.textWhite),
          ),
        ),
      );
      return;
    }

    final loader = ref.read(globalLoaderProvider.notifier);
    final dispatch$ = ref.read(dispatchProvider.notifier);

    loader.show(context);

    try {
      await ref
          .read(incidentPhotoServiceProvider)
          .syncPendingPhotos(incidentId: widget.dispatch.incidentId);

      await dispatch$.completeDispatch(
        incidentId: widget.dispatch.incidentId,
        resolvedAt: currentResolvedAt,
      );

      // Invalidate dispatch feed to refresh the list and remove completed dispatch
      ref.invalidate(assignedDispatchFeedProvider);

      if (mounted) {
        // Pop twice to close both the screen and the modal
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }

      await Future<void>.delayed(const Duration(seconds: 5));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.errorRed,
          content: Row(
            children: [
              Icon(Icons.error_outline, color: AppTheme.textWhite),
              SizedBox(width: AppTheme.spacing8),
              Expanded(
                child: Text(
                  'Failed to complete response. Please check your connection and try again.',
                  style: AppTheme.bodySmall.copyWith(color: AppTheme.textWhite),
                ),
              ),
            ],
          ),
        ),
      );
    } finally {
      await Future<void>.delayed(const Duration(seconds: 5));
      loader.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final arrivedAt =
        widget.dispatch.arrivedAt ??
        widget.dispatch.createdAt ??
        DateTime.now();
    final currentResolvedAt = resolvedAt ?? DateTime.now();

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: AppTheme.textWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppTheme.textWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Complete Response',
          style: AppTheme.h6.copyWith(
            color: AppTheme.textWhite,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppTheme.spacing20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status message
                    Container(
                      padding: EdgeInsets.all(AppTheme.spacing16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radius12),
                        border: Border.all(
                          color: AppTheme.primaryRed.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.primaryRed,
                            size: AppTheme.iconSize20,
                          ),
                          SizedBox(width: AppTheme.spacing12),
                          Expanded(
                            child: Text(
                              'Have you completed the incident response?',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppTheme.spacing16),
                    Text(
                      'This will record the completion time and update the incident status.',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppTheme.spacing24),

                    // Automatically captured arrival time (geofence based)
                    _buildTimeCard(
                      context,
                      icon: Icons.flag,
                      title: 'Arrived Time',
                      time: arrivedAt,
                      editable: false,
                      helperText:
                          'Captured automatically when truck reaches incident radius.',
                      onTap: null,
                    ),
                    SizedBox(height: AppTheme.spacing16),
                    _buildTimeCard(
                      context,
                      icon: Icons.task_alt,
                      title: 'Resolved Time',
                      time: currentResolvedAt,
                      onTap: () async {
                        final picked = await _pickDateTime(
                          context,
                          currentResolvedAt,
                        );
                        if (picked != null) {
                          setState(() => resolvedAt = picked);
                        }
                      },
                    ),
                    SizedBox(height: AppTheme.spacing24),
                    IncidentPhotoCaptureCard(
                      incidentId: widget.dispatch.incidentId,
                      kind: IncidentPhotoKind.after,
                      incidentData: widget.dispatch.incidentData,
                      compact: false,
                    ),
                  ],
                ),
              ),
            ),

            // ── Actions ───────────────────────────────────────────────────
            Container(
              padding: EdgeInsets.all(AppTheme.spacing20),
              decoration: BoxDecoration(
                color: AppTheme.backgroundWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Consumer(
                builder: (context, ref, child) {
                  final photoStatusAsync = ref.watch(
                    incidentPhotoStatusProvider(
                      IncidentPhotoRequest(
                        incidentId: widget.dispatch.incidentId,
                        incidentData: widget.dispatch.incidentData,
                      ),
                    ),
                  );

                  return photoStatusAsync.when(
                    loading: () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.textSecondary.withValues(
                            alpha: 0.3,
                          ),
                          foregroundColor: AppTheme.textWhite,
                          padding: EdgeInsets.symmetric(
                            vertical: AppTheme.spacing16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radius12,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: AppTheme.iconSize20,
                              height: AppTheme.iconSize20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.textWhite,
                                ),
                              ),
                            ),
                            SizedBox(width: AppTheme.spacing8),
                            Text(
                              'Complete',
                              style: AppTheme.buttonMedium.copyWith(
                                color: AppTheme.textWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    error: (_, __) => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.textSecondary.withValues(
                            alpha: 0.3,
                          ),
                          foregroundColor: AppTheme.textWhite,
                          padding: EdgeInsets.symmetric(
                            vertical: AppTheme.spacing16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radius12,
                            ),
                          ),
                        ),
                        child: Text(
                          'Complete',
                          style: AppTheme.buttonMedium.copyWith(
                            color: AppTheme.textWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    data: (status) {
                      final canComplete = status.hasAfter;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: canComplete ? _completeResponse : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: canComplete
                                ? AppTheme.primaryRed
                                : AppTheme.textSecondary.withValues(alpha: 0.3),
                            foregroundColor: AppTheme.textWhite,
                            padding: EdgeInsets.symmetric(
                              vertical: AppTheme.spacing16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppTheme.radius12,
                              ),
                            ),
                          ),
                          child: Text(
                            canComplete ? 'Complete' : 'Take After Photo First',
                            style: AppTheme.buttonMedium.copyWith(
                              color: AppTheme.textWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
