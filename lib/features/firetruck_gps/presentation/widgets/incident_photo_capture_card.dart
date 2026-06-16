import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_theme.dart';
import '../../domain/entities/incident_photo_kind.dart';
import '../providers/incident_photo_providers.dart';

/// Pinned above "Complete Response" when the before-scene photo is still missing.
class BeforeScenePhotoPinnedBar extends ConsumerWidget {
  const BeforeScenePhotoPinnedBar({
    super.key,
    required this.incidentId,
    required this.incidentData,
  });

  final String incidentId;
  final Map<String, dynamic> incidentData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(
      incidentPhotoStatusProvider(
        IncidentPhotoRequest(
          incidentId: incidentId,
          incidentData: incidentData,
        ),
      ),
    );

    return statusAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (status) {
        if (status.hasBefore) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: AppTheme.spacing12),
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.spacing12,
            vertical: AppTheme.spacing10,
          ),
          decoration: BoxDecoration(
            color: AppTheme.secondaryOrange.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppTheme.radius12),
            border: Border.all(
              color: AppTheme.secondaryOrange.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.camera_alt,
                color: AppTheme.secondaryOrange,
                size: AppTheme.iconSize20,
              ),
              SizedBox(width: AppTheme.spacing8),
              Expanded(
                child: Text(
                  'Before scene photo required',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              FilledButton(
                onPressed: () => _capture(context, ref),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primaryRed,
                  foregroundColor: AppTheme.textWhite,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing12,
                    vertical: AppTheme.spacing8,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Take Photo'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _capture(BuildContext context, WidgetRef ref) async {
    final service = ref.read(incidentPhotoServiceProvider);
    final path = await service.capturePhoto(
      incidentId: incidentId,
      kind: IncidentPhotoKind.before,
    );

    ref.invalidate(
      incidentPhotoStatusProvider(
        IncidentPhotoRequest(
          incidentId: incidentId,
          incidentData: incidentData,
        ),
      ),
    );

    if (!context.mounted) return;
    if (path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Photo not captured. Camera permission may be required.',
          ),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${IncidentPhotoKind.before.label} saved. '
          'It will upload when online.',
        ),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class IncidentPhotoCaptureCard extends ConsumerStatefulWidget {
  const IncidentPhotoCaptureCard({
    super.key,
    required this.incidentId,
    required this.kind,
    this.incidentData,
    this.compact = false,
  });

  final String incidentId;
  final IncidentPhotoKind kind;
  final Map<String, dynamic>? incidentData;
  final bool compact;

  @override
  ConsumerState<IncidentPhotoCaptureCard> createState() =>
      _IncidentPhotoCaptureCardState();
}

class _IncidentPhotoCaptureCardState
    extends ConsumerState<IncidentPhotoCaptureCard> {
  bool _isCapturing = false;

  @override
  Widget build(BuildContext context) {
    final statusAsync = ref.watch(
      incidentPhotoStatusProvider(
        IncidentPhotoRequest(
          incidentId: widget.incidentId,
          incidentData: widget.incidentData,
        ),
      ),
    );

    return statusAsync.when(
      loading: () => _buildShell(
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, __) => _buildShell(child: const SizedBox.shrink()),
      data: (status) {
        final hasPhoto = widget.kind == IncidentPhotoKind.before
            ? status.hasBefore
            : status.hasAfter;
        final localPath = widget.kind == IncidentPhotoKind.before
            ? status.beforeLocalPath
            : status.afterLocalPath;
        final remoteUrl = widget.kind == IncidentPhotoKind.before
            ? status.beforeRemoteUrl
            : status.afterRemoteUrl;
        final pendingSync = widget.kind == IncidentPhotoKind.before
            ? status.beforePendingSync
            : status.afterPendingSync;

        return _buildShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    hasPhoto ? Icons.check_circle : Icons.camera_alt,
                    color: hasPhoto
                        ? Colors.green.shade700
                        : AppTheme.primaryRed,
                    size: AppTheme.iconSize20,
                  ),
                  SizedBox(width: AppTheme.spacing8),
                  Expanded(
                    child: Text(
                      widget.kind.label,
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  if (hasPhoto && pendingSync)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: AppTheme.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryOrange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppTheme.radius6),
                      ),
                      child: Text(
                        'Pending sync',
                        style: AppTheme.overline.copyWith(
                          color: AppTheme.secondaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (hasPhoto && !pendingSync)
                    Icon(
                      Icons.cloud_done,
                      color: Colors.green.shade700,
                      size: AppTheme.iconSize18,
                    ),
                ],
              ),
              if (!widget.compact) ...[
                SizedBox(height: AppTheme.spacing8),
                Text(
                  widget.kind.helperText,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
              if (hasPhoto || _isCapturing) ...[
                SizedBox(height: AppTheme.spacing12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radius12),
                  child: SizedBox(
                    height: widget.compact ? 120 : 160,
                    width: double.infinity,
                    child: _isCapturing
                        ? Container(
                            color: AppTheme.surfaceGrey,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.primaryRed,
                                    ),
                                  ),
                                  SizedBox(height: AppTheme.spacing8),
                                  Text(
                                    'Capturing...',
                                    style: AppTheme.bodySmall.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : hasPhoto
                        ? Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () =>
                                  _showFullPhoto(context, localPath, remoteUrl),
                              splashColor: AppTheme.primaryRed.withValues(
                                alpha: 0.3,
                              ),
                              child: Stack(
                                children: [
                                  _PhotoPreview(
                                    localPath: localPath,
                                    remoteUrl: remoteUrl,
                                    height: widget.compact ? 120 : 160,
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        AppTheme.spacing8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppTheme.radius8,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.fullscreen,
                                        color: Colors.white,
                                        size: AppTheme.iconSize20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : _PhotoPreview(
                            localPath: localPath,
                            remoteUrl: remoteUrl,
                            height: widget.compact ? 120 : 160,
                          ),
                  ),
                ),
              ],
              SizedBox(height: AppTheme.spacing12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isCapturing ? null : () => _capture(context, ref),
                  icon: Icon(
                    hasPhoto ? Icons.refresh : Icons.camera_alt,
                    size: AppTheme.iconSize18,
                  ),
                  label: Text(
                    hasPhoto
                        ? 'Retake Photo'
                        : widget.kind == IncidentPhotoKind.before
                        ? 'Upload Before Scene Photo'
                        : 'Take Photo',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryRed,
                    side: BorderSide(color: AppTheme.primaryRed),
                    padding: EdgeInsets.symmetric(vertical: AppTheme.spacing12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radius12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShell({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        widget.compact ? AppTheme.spacing12 : AppTheme.spacing16,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceGrey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(
          color: AppTheme.textSecondary.withValues(alpha: 0.2),
        ),
      ),
      child: child,
    );
  }

  Future<void> _capture(BuildContext context, WidgetRef ref) async {
    setState(() => _isCapturing = true);

    final service = ref.read(incidentPhotoServiceProvider);
    final path = await service.capturePhoto(
      incidentId: widget.incidentId,
      kind: widget.kind,
    );

    ref.invalidate(
      incidentPhotoStatusProvider(
        IncidentPhotoRequest(
          incidentId: widget.incidentId,
          incidentData: widget.incidentData,
        ),
      ),
    );

    if (!mounted) return;
    setState(() => _isCapturing = false);

    if (path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Photo not captured. Camera permission may be required.',
          ),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }
  }

  void _showFullPhoto(
    BuildContext context,
    String? localPath,
    String? remoteUrl,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            _FullPhotoView(localPath: localPath, remoteUrl: remoteUrl),
      ),
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  const _PhotoPreview({
    required this.localPath,
    required this.remoteUrl,
    required this.height,
  });

  final String? localPath;
  final String? remoteUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (localPath != null && File(localPath!).existsSync()) {
      return Image.file(
        File(localPath!),
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    if (remoteUrl != null && remoteUrl!.isNotEmpty) {
      return Image.network(
        remoteUrl!,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: double.infinity,
      color: AppTheme.surfaceGrey,
      alignment: Alignment.center,
      child: Icon(Icons.image_not_supported, color: AppTheme.textSecondary),
    );
  }
}

class _FullPhotoView extends StatelessWidget {
  const _FullPhotoView({required this.localPath, required this.remoteUrl});

  final String? localPath;
  final String? remoteUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: _buildPhoto(),
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    if (localPath != null && File(localPath!).existsSync()) {
      return Image.file(File(localPath!), fit: BoxFit.contain);
    }
    if (remoteUrl != null && remoteUrl!.isNotEmpty) {
      return Image.network(
        remoteUrl!,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return const Center(
      child: Icon(Icons.image_not_supported, color: Colors.white54, size: 64),
    );
  }
}
