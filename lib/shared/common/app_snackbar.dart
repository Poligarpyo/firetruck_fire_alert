import 'package:flutter/material.dart'; 
 
  

class AppSnackbar {
  static void showMessage(BuildContext context, String message, {required Duration duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
