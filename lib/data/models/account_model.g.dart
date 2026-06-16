// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountModel _$AccountModelFromJson(Map<String, dynamic> json) =>
    _AccountModel(
      created_at: json['created_at'] as String,
      display_name: json['display_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      station: json['station'] as String,
    );

Map<String, dynamic> _$AccountModelToJson(_AccountModel instance) =>
    <String, dynamic>{
      'created_at': instance.created_at,
      'display_name': instance.display_name,
      'email': instance.email,
      'phone': instance.phone,
      'role': instance.role,
      'station': instance.station,
    };
