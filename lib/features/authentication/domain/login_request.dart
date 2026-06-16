import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

@freezed
abstract class LoginCredentials with _$LoginCredentials {
  const factory LoginCredentials({
    required String firetruckCode,
    required String firetruckName,
  }) = _LoginCredentials;

  factory LoginCredentials.fromJson(Map<String, dynamic> json) => _$LoginCredentialsFromJson(json);
}
