import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../login/controller/login_controller.dart';

void handleLogin(
  BuildContext context,
  WidgetRef ref,
  TextEditingController usernameController,
  TextEditingController passwordController,
) {
  FocusScope.of(context).unfocus();
  ref.read(loginControllerProvider.notifier).login(
    username: usernameController.text.trim(),
    password: passwordController.text,
  );
}