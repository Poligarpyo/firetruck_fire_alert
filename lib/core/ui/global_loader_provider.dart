import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final globalLoaderProvider =
    StateNotifierProvider<GlobalLoaderController, bool>(
      (ref) => GlobalLoaderController(),
    );

class GlobalLoaderController extends StateNotifier<bool> {
  GlobalLoaderController() : super(false);

  OverlayEntry? _entry;

  void show(BuildContext context) {
    if (_entry != null) return;

    _entry = OverlayEntry(
      builder: (_) => PopScope(
        canPop: false,
        child: AbsorbPointer(
          absorbing: true,
          child: Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
    state = true;
  }

  void hide() {
    _entry?.remove();
    _entry = null;
    state = false;
  }
}