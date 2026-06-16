import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String address,
    required double balance,
    required String city,
    required String country,
    required int currency,
    required int currentTradesCount,
    required double currentTradesVolume,
    required double equity,
    required double freeMargin,
    required bool isAnyOpenTrades,
    required bool isSwapFree,
    required int leverage,
    required String name,
    required String phone,
    required int totalTradesCount,
    required double totalTradesVolume,
    required int type,
    required int verificationLevel,
    required String zipCode,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
