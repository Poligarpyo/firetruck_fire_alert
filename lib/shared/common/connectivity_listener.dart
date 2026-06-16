import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityListener extends ConsumerStatefulWidget {
  final Widget child;
  const ConnectivityListener({super.key, required this.child});

  @override
  ConsumerState<ConnectivityListener> createState() =>
      _ConnectivityListenerState();
}

class _ConnectivityListenerState extends ConsumerState<ConnectivityListener> {
  @override
  void initState() {
    super.initState();
    // Connectivity checking disabled to prevent dialog on app startup
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
