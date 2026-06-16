import 'package:freezed_annotation/freezed_annotation.dart';

import '../../features/account_information/domain/entities/account.dart';

 

part 'account_model.freezed.dart';
part 'account_model.g.dart';

@freezed
abstract class AccountModel with _$AccountModel {
  const factory AccountModel({
    required String created_at,
    required String display_name,
    required String email,
    required String phone,
    required String role,
    required String station, 
  }) = _AccountModel;

  factory AccountModel.fromJson(Map<String, dynamic> json) => _$AccountModelFromJson(json);
}

extension AccountModelX on AccountModel {
  Account toEntity() => Account(
        createdAt: created_at,
        displayName: display_name,
        email: email,
        phone: phone,
        role: role,
        station: station, 
      );
}
