import 'package:flutter/material.dart';

class AccountLoading extends StatelessWidget {
  const AccountLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}