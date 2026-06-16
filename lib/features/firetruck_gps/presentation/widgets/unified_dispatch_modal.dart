import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/incident_timestamp.dart';
import '../../../../data/enums/dispatch_status.dart';
import '../providers/dispatch_feed_provider.dart';
import '../providers/firetruck_location_providers.dart';
import 'empty_dispatch_widget.dart';
import 'dispatch_modal_widget.dart';
import 'accepted_dispatch_widget.dart';
import 'shimmer_widgets.dart';
import '../../../../shared/theme/app_theme.dart';

class UnifiedDispatchModal extends ConsumerWidget {
  const UnifiedDispatchModal({
    super.key,
    required this.scrollController, // ← store it
  });

  final ScrollController scrollController; // ← store it

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DispatchStatus status = ref.watch(dispatchProvider).status;
    final dispatchFeedAsync = ref.watch(assignedDispatchFeedProvider);

    // ← No more DraggableScrollableSheet here — just the Container
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            context.responsiveValue(
              small: AppTheme.radius16,
              medium: AppTheme.radius20,
              large: AppTheme.radius20,
              extraLarge: AppTheme.radius20,
            ),
          ),
          topRight: Radius.circular(
            context.responsiveValue(
              small: AppTheme.radius16,
              medium: AppTheme.radius20,
              large: AppTheme.radius20,
              extraLarge: AppTheme.radius20,
            ),
          ),
        ),
      ),
      child: dispatchFeedAsync.when(
        data: (dispatches) => _buildContent(
          context,
          ref,
          status,
          dispatches,
          scrollController, // ← pass it down
        ),
        loading: () => _buildLoadingShimmer(context),
        error: (_, __) => const EmptyDispatchWidget(),
      ),
    );
  }

  Widget _buildLoadingShimmer(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Header ──────────────────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: context.responsivePadding(
            small: const EdgeInsets.all(AppTheme.spacing16),
            medium: const EdgeInsets.all(AppTheme.spacing20),
            large: const EdgeInsets.all(AppTheme.spacing24),
            extraLarge: const EdgeInsets.all(AppTheme.spacing28),
          ),
          decoration: const BoxDecoration(
            color: AppTheme.errorRed,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppTheme.radius20),
              topRight: Radius.circular(AppTheme.radius20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppTheme.iconSize40,
                height: 4,
                margin: EdgeInsets.only(bottom: AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: AppTheme.textWhite.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppTheme.radius4),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppTheme.spacing8),
                    decoration: BoxDecoration(
                      color: AppTheme.textWhite.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppTheme.radius8),
                    ),
                    child: Icon(
                      Icons.local_fire_department,
                      color: AppTheme.textWhite,
                      size: context.responsiveIconSize(
                        small: AppTheme.iconSize16,
                        medium: AppTheme.iconSize20,
                        large: AppTheme.iconSize24,
                        extraLarge: AppTheme.iconSize24,
                      ),
                    ),
                  ),
                  SizedBox(width: AppTheme.spacing12),
                  Text(
                    'DISPATCH REPORT',
                    style: AppTheme.h6.copyWith(
                      color: AppTheme.textWhite,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Scrollable body ──────────────────────────────────────────────────
        Expanded(
          child: Padding(
            padding: context.responsivePadding(
              small: EdgeInsets.all(AppTheme.spacing16),
              medium: EdgeInsets.all(AppTheme.spacing20),
              large: EdgeInsets.all(AppTheme.spacing24),
              extraLarge: EdgeInsets.all(AppTheme.spacing28),
            ),
            child: Column(
              children: [
                // Scrollable shimmer content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: DispatchShimmerWidgets.buildCompleteDispatchShimmer(
                      context,
                    ),
                  ),
                ),
                // Button shimmer (fixed at bottom)
                SizedBox(height: AppTheme.spacing20),
                DispatchShimmerWidgets.shimmerEffect(
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundWhite,
                      borderRadius: BorderRadius.circular(AppTheme.radius12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    DispatchStatus status,
    List<DispatchInfo> dispatches,
    ScrollController scrollController,
  ) {
    if (dispatches.isEmpty) {
      return const EmptyDispatchWidget();
    }

    final latest = dispatches.first;
    final effectiveStatus = _effectiveDispatchStatus(status, latest);

    switch (effectiveStatus) {
      case DispatchStatus.none:
      case DispatchStatus.pending:
        return DispatchModalWidget(
          dispatch: latest,
          scrollController: scrollController,
        );
      case DispatchStatus.accepted:
        return AcceptedDispatchWidget(
          dispatch: latest,
          scrollController: scrollController,
        );
      case DispatchStatus.completed:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(dispatchProvider.notifier).resetDispatch();
        });
        return const EmptyDispatchWidget();
    }
  }

  /// In-memory [dispatchProvider] resets on app restart; RTDB still shows
  /// `responding` — keep showing the accepted UI with photo capture.
  DispatchStatus _effectiveDispatchStatus(
    DispatchStatus local,
    DispatchInfo dispatch,
  ) {
    if (local == DispatchStatus.accepted || local == DispatchStatus.completed) {
      return local;
    }

    final incidentStatus =
        (dispatch.incidentData['status'] as String?)?.toLowerCase().trim();
    const activeOfficerStatuses = <String>{
      'responding',
      'enroute',
      'en_route',
      'on_scene',
      'on-scene',
      'onsite',
    };
    if (incidentStatus != null && activeOfficerStatuses.contains(incidentStatus)) {
      return DispatchStatus.accepted;
    }

    if (incidentHasArrived(dispatch.incidentData)) {
      return DispatchStatus.accepted;
    }

    return local;
  }
}
