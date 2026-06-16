import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'global_loader_provider.dart';

class LoadingOverlay extends ConsumerWidget {
  const LoadingOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading = ref.watch<bool>(globalLoaderProvider) == true;

    return PopScope(
      canPop: isLoading == false, // disables Android back button while loading
      child: Stack(
        children: [
          child,
          if (isLoading)
            AbsorbPointer( // ← blocks all taps
              absorbing: true,
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}