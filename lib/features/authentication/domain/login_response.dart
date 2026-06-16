import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/account_model.dart';
 
part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required bool result,
    required String token,
    required AccountModel account,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
