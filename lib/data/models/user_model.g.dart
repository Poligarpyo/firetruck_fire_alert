// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  address: json['address'] as String,
  balance: (json['balance'] as num).toDouble(),
  city: json['city'] as String,
  country: json['country'] as String,
  currency: (json['currency'] as num).toInt(),
  currentTradesCount: (json['currentTradesCount'] as num).toInt(),
  currentTradesVolume: (json['currentTradesVolume'] as num).toDouble(),
  equity: (json['equity'] as num).toDouble(),
  freeMargin: (json['freeMargin'] as num).toDouble(),
  isAnyOpenTrades: json['isAnyOpenTrades'] as bool,
  isSwapFree: json['isSwapFree'] as bool,
  leverage: (json['leverage'] as num).toInt(),
  name: json['name'] as String,
  phone: json['phone'] as String,
  totalTradesCount: (json['totalTradesCount'] as num).toInt(),
  totalTradesVolume: (json['totalTradesVolume'] as num).toDouble(),
  type: (json['type'] as num).toInt(),
  verificationLevel: (json['verificationLevel'] as num).toInt(),
  zipCode: json['zipCode'] as String,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'address': instance.address,
      'balance': instance.balance,
      'city': instance.city,
      'country': instance.country,
      'currency': instance.currency,
      'currentTradesCount': instance.currentTradesCount,
      'currentTradesVolume': instance.currentTradesVolume,
      'equity': instance.equity,
      'freeMargin': instance.freeMargin,
      'isAnyOpenTrades': instance.isAnyOpenTrades,
      'isSwapFree': instance.isSwapFree,
      'leverage': instance.leverage,
      'name': instance.name,
      'phone': instance.phone,
      'totalTradesCount': instance.totalTradesCount,
      'totalTradesVolume': instance.totalTradesVolume,
      'type': instance.type,
      'verificationLevel': instance.verificationLevel,
      'zipCode': instance.zipCode,
    };
