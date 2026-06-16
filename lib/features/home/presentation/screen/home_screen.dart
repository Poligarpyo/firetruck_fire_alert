import 'package:flutter/material.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
 
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final int _selectedIndex = 0; 
  late final List<Widget> _screens; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 🏠 DASHBOARD BODY
      body: IndexedStack(index: _selectedIndex, children: _screens),
    );
  }
}
