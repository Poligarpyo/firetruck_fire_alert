import 'dart:convert';

import 'package:hive_ce/hive.dart';

import '../../data/models/account_model.dart';

 
const String authBoxName = 'authBox';
const String tokenKey = 'token';
const String loginKey = 'login';
const String splashShownKey = 'splashShown';
const String accountKey = 'account'; // ✅ add constant

class AuthLocalDataSource {
  AuthLocalDataSource(this.box);
  // ignore: always_specify_types, strict_raw_type
  final Box box;

  // ─── Account ────────────────────────────────────────────────

  Future<void> saveAccount(AccountModel account) async {
    await box.put(accountKey, jsonEncode(account.toJson()));
  }

  AccountModel? getAccount() {
    final raw = box.get(accountKey) as String?;
    if (raw == null) return null;
    return AccountModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> clearAccount() async {
    await box.delete(accountKey);
  }

  // ─── Token ──────────────────────────────────────────────────

  Future<void> saveToken(String token) async {
    await box.put(tokenKey, token);
  }

  String? getToken() {
    return box.get(tokenKey) as String?;
  }

  Future<void> clearToken() async {
    await box.delete(tokenKey);
  }

  // ─── Login (agent code/username) ────────────────────────────

  Future<void> saveCode(String login) async {
    await box.put(loginKey, login);
  }

  String? getLogin() {
    return box.get(loginKey) as String?;
  }

  Future<void> clearLogin() async {
    await box.delete(loginKey);
  }

  // ─── Splash ─────────────────────────────────────────────────

  Future<void> setSplashShown() async {
    await box.put(splashShownKey, true);
  }

  bool isSplashShown() {
    return (box.get(splashShownKey) as bool?) ?? false;
  }

  Future<void> clearSplashShown() async {
    await box.delete(splashShownKey);
  }

  // ─── Full clear (logout) ─────────────────────────────────────

  Future<void> clearAll() async {
    await Future.wait([clearToken(), clearLogin(), clearAccount()]);
  }
}
