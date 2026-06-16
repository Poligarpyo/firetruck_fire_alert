// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import '../../../../core/storage/auth_local_datasource_provider.dart';

// @riverpod
// class AuthState extends _$AuthState {
//   @override
//   bool build() {
//     final token = ref.read(authLocalDataSourceProvider).getToken();
//     return token != null && token.isNotEmpty;
//   }

//   void login(String token) {
//     state = true;
//   }

//   void logout() {
//     state = false;
//   }
// }

// Future<void> _handleUnauthorized() async {
//   final ref = this.ref;

//   await ref.read(authLocalDataSourceProvider).clearToken();
//   await ref.read(authLocalDataSourceProvider).clearLogin();

//   clearToken();

//   // 🔥 THIS is what triggers redirect
//   ref.read(authStateProvider.notifier).logout();
// }
