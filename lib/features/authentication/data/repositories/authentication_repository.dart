import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/storage/auth_local_datasource_provider.dart';
import '../../../../data/models/account_model.dart';
import '../../domain/login_response.dart';

part 'authentication_repository.g.dart';

abstract class AuthenticationRepository {
  Future<LoginResponse> login(String username, String password);
}

class HttpAuthRepository implements AuthenticationRepository {
  HttpAuthRepository(this.ref);
  final Ref ref;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  String _hashPassword(String rawPassword) {
    final digest = sha256.convert(utf8.encode(rawPassword));
    return base64Encode(digest.bytes);
  }

  String _hashPasswordHex(String rawPassword) {
    final digest = sha256.convert(utf8.encode(rawPassword));
    return digest.toString();
  }

  bool _verifyPassword(String rawPassword, String storedHash) {
    if (storedHash.startsWith(r'$2a$') ||
        storedHash.startsWith(r'$2b$') ||
        storedHash.startsWith(r'$2y$')) {
      return BCrypt.checkpw(rawPassword, storedHash);
    }

    // Legacy fallback in case older accounts were stored as SHA-256.
    return storedHash == _hashPassword(rawPassword) ||
        storedHash == _hashPasswordHex(rawPassword);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> _findAgentDoc(
    String username,
  ) async {
    final agents = firestore.collection('agents');

    final direct = await agents.doc(username).get();
    if (direct.exists) return direct;

    final lower = username.toLowerCase();
    if (lower != username) {
      final lowerDoc = await agents.doc(lower).get();
      if (lowerDoc.exists) return lowerDoc;
    }

    final usernameFieldSnapshot = await agents
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    if (usernameFieldSnapshot.docs.isNotEmpty) {
      return usernameFieldSnapshot.docs.first;
    }

    if (lower != username) {
      final usernameLowerSnapshot = await agents
          .where('username', isEqualTo: lower)
          .limit(1)
          .get();
      if (usernameLowerSnapshot.docs.isNotEmpty) {
        return usernameLowerSnapshot.docs.first;
      }
    }

    return null;
  }

  @override
  Future<LoginResponse> login(String username, String password) async {
    final agentDoc = await _findAgentDoc(username.trim());

    if (agentDoc == null || !agentDoc.exists)
      throw Exception('Username not found.');

    final data = agentDoc.data()!;
    final storedHash = (data['password_hash'] as String?) ?? '';

    if (storedHash.isEmpty || !_verifyPassword(password, storedHash)) {
      throw Exception('Invalid password.');
    }

    // Build account model here — data is available
    final account = AccountModel(
      created_at: (data['created_at'] as String?) ?? '',
      display_name: (data['display_name'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      phone: (data['phone'] as String?) ?? '',
      role: (data['role'] as String?) ?? '',
      station: (data['station'] as String?) ?? '',
    );

    final token = base64UrlEncode(
      utf8.encode('${agentDoc.id}:${DateTime.now().millisecondsSinceEpoch}'),
    );

    // ✅ Save ONCE here — single source of truth
    final localDs = ref.read(authLocalDataSourceProvider);
    await Future.wait([
      localDs.saveToken(token),
      localDs.saveCode(agentDoc.id),
      localDs.saveAccount(account), // ✅ persist user details
    ]);

    return LoginResponse(token: token, result: true, account: account);
  }
}

@Riverpod(keepAlive: true)
AuthenticationRepository authenticationRepository(Ref ref) {
  return HttpAuthRepository(ref);
}
