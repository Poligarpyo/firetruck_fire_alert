// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String get address; double get balance; String get city; String get country; int get currency; int get currentTradesCount; double get currentTradesVolume; double get equity; double get freeMargin; bool get isAnyOpenTrades; bool get isSwapFree; int get leverage; String get name; String get phone; int get totalTradesCount; double get totalTradesVolume; int get type; int get verificationLevel; String get zipCode;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.address, address) || other.address == address)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.currentTradesCount, currentTradesCount) || other.currentTradesCount == currentTradesCount)&&(identical(other.currentTradesVolume, currentTradesVolume) || other.currentTradesVolume == currentTradesVolume)&&(identical(other.equity, equity) || other.equity == equity)&&(identical(other.freeMargin, freeMargin) || other.freeMargin == freeMargin)&&(identical(other.isAnyOpenTrades, isAnyOpenTrades) || other.isAnyOpenTrades == isAnyOpenTrades)&&(identical(other.isSwapFree, isSwapFree) || other.isSwapFree == isSwapFree)&&(identical(other.leverage, leverage) || other.leverage == leverage)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.totalTradesCount, totalTradesCount) || other.totalTradesCount == totalTradesCount)&&(identical(other.totalTradesVolume, totalTradesVolume) || other.totalTradesVolume == totalTradesVolume)&&(identical(other.type, type) || other.type == type)&&(identical(other.verificationLevel, verificationLevel) || other.verificationLevel == verificationLevel)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,address,balance,city,country,currency,currentTradesCount,currentTradesVolume,equity,freeMargin,isAnyOpenTrades,isSwapFree,leverage,name,phone,totalTradesCount,totalTradesVolume,type,verificationLevel,zipCode]);

@override
String toString() {
  return 'UserModel(address: $address, balance: $balance, city: $city, country: $country, currency: $currency, currentTradesCount: $currentTradesCount, currentTradesVolume: $currentTradesVolume, equity: $equity, freeMargin: $freeMargin, isAnyOpenTrades: $isAnyOpenTrades, isSwapFree: $isSwapFree, leverage: $leverage, name: $name, phone: $phone, totalTradesCount: $totalTradesCount, totalTradesVolume: $totalTradesVolume, type: $type, verificationLevel: $verificationLevel, zipCode: $zipCode)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String address, double balance, String city, String country, int currency, int currentTradesCount, double currentTradesVolume, double equity, double freeMargin, bool isAnyOpenTrades, bool isSwapFree, int leverage, String name, String phone, int totalTradesCount, double totalTradesVolume, int type, int verificationLevel, String zipCode
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? address = null,Object? balance = null,Object? city = null,Object? country = null,Object? currency = null,Object? currentTradesCount = null,Object? currentTradesVolume = null,Object? equity = null,Object? freeMargin = null,Object? isAnyOpenTrades = null,Object? isSwapFree = null,Object? leverage = null,Object? name = null,Object? phone = null,Object? totalTradesCount = null,Object? totalTradesVolume = null,Object? type = null,Object? verificationLevel = null,Object? zipCode = null,}) {
  return _then(_self.copyWith(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as int,currentTradesCount: null == currentTradesCount ? _self.currentTradesCount : currentTradesCount // ignore: cast_nullable_to_non_nullable
as int,currentTradesVolume: null == currentTradesVolume ? _self.currentTradesVolume : currentTradesVolume // ignore: cast_nullable_to_non_nullable
as double,equity: null == equity ? _self.equity : equity // ignore: cast_nullable_to_non_nullable
as double,freeMargin: null == freeMargin ? _self.freeMargin : freeMargin // ignore: cast_nullable_to_non_nullable
as double,isAnyOpenTrades: null == isAnyOpenTrades ? _self.isAnyOpenTrades : isAnyOpenTrades // ignore: cast_nullable_to_non_nullable
as bool,isSwapFree: null == isSwapFree ? _self.isSwapFree : isSwapFree // ignore: cast_nullable_to_non_nullable
as bool,leverage: null == leverage ? _self.leverage : leverage // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,totalTradesCount: null == totalTradesCount ? _self.totalTradesCount : totalTradesCount // ignore: cast_nullable_to_non_nullable
as int,totalTradesVolume: null == totalTradesVolume ? _self.totalTradesVolume : totalTradesVolume // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,verificationLevel: null == verificationLevel ? _self.verificationLevel : verificationLevel // ignore: cast_nullable_to_non_nullable
as int,zipCode: null == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String address,  double balance,  String city,  String country,  int currency,  int currentTradesCount,  double currentTradesVolume,  double equity,  double freeMargin,  bool isAnyOpenTrades,  bool isSwapFree,  int leverage,  String name,  String phone,  int totalTradesCount,  double totalTradesVolume,  int type,  int verificationLevel,  String zipCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.address,_that.balance,_that.city,_that.country,_that.currency,_that.currentTradesCount,_that.currentTradesVolume,_that.equity,_that.freeMargin,_that.isAnyOpenTrades,_that.isSwapFree,_that.leverage,_that.name,_that.phone,_that.totalTradesCount,_that.totalTradesVolume,_that.type,_that.verificationLevel,_that.zipCode);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String address,  double balance,  String city,  String country,  int currency,  int currentTradesCount,  double currentTradesVolume,  double equity,  double freeMargin,  bool isAnyOpenTrades,  bool isSwapFree,  int leverage,  String name,  String phone,  int totalTradesCount,  double totalTradesVolume,  int type,  int verificationLevel,  String zipCode)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.address,_that.balance,_that.city,_that.country,_that.currency,_that.currentTradesCount,_that.currentTradesVolume,_that.equity,_that.freeMargin,_that.isAnyOpenTrades,_that.isSwapFree,_that.leverage,_that.name,_that.phone,_that.totalTradesCount,_that.totalTradesVolume,_that.type,_that.verificationLevel,_that.zipCode);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String address,  double balance,  String city,  String country,  int currency,  int currentTradesCount,  double currentTradesVolume,  double equity,  double freeMargin,  bool isAnyOpenTrades,  bool isSwapFree,  int leverage,  String name,  String phone,  int totalTradesCount,  double totalTradesVolume,  int type,  int verificationLevel,  String zipCode)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.address,_that.balance,_that.city,_that.country,_that.currency,_that.currentTradesCount,_that.currentTradesVolume,_that.equity,_that.freeMargin,_that.isAnyOpenTrades,_that.isSwapFree,_that.leverage,_that.name,_that.phone,_that.totalTradesCount,_that.totalTradesVolume,_that.type,_that.verificationLevel,_that.zipCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({required this.address, required this.balance, required this.city, required this.country, required this.currency, required this.currentTradesCount, required this.currentTradesVolume, required this.equity, required this.freeMargin, required this.isAnyOpenTrades, required this.isSwapFree, required this.leverage, required this.name, required this.phone, required this.totalTradesCount, required this.totalTradesVolume, required this.type, required this.verificationLevel, required this.zipCode});
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String address;
@override final  double balance;
@override final  String city;
@override final  String country;
@override final  int currency;
@override final  int currentTradesCount;
@override final  double currentTradesVolume;
@override final  double equity;
@override final  double freeMargin;
@override final  bool isAnyOpenTrades;
@override final  bool isSwapFree;
@override final  int leverage;
@override final  String name;
@override final  String phone;
@override final  int totalTradesCount;
@override final  double totalTradesVolume;
@override final  int type;
@override final  int verificationLevel;
@override final  String zipCode;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.address, address) || other.address == address)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.currentTradesCount, currentTradesCount) || other.currentTradesCount == currentTradesCount)&&(identical(other.currentTradesVolume, currentTradesVolume) || other.currentTradesVolume == currentTradesVolume)&&(identical(other.equity, equity) || other.equity == equity)&&(identical(other.freeMargin, freeMargin) || other.freeMargin == freeMargin)&&(identical(other.isAnyOpenTrades, isAnyOpenTrades) || other.isAnyOpenTrades == isAnyOpenTrades)&&(identical(other.isSwapFree, isSwapFree) || other.isSwapFree == isSwapFree)&&(identical(other.leverage, leverage) || other.leverage == leverage)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.totalTradesCount, totalTradesCount) || other.totalTradesCount == totalTradesCount)&&(identical(other.totalTradesVolume, totalTradesVolume) || other.totalTradesVolume == totalTradesVolume)&&(identical(other.type, type) || other.type == type)&&(identical(other.verificationLevel, verificationLevel) || other.verificationLevel == verificationLevel)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,address,balance,city,country,currency,currentTradesCount,currentTradesVolume,equity,freeMargin,isAnyOpenTrades,isSwapFree,leverage,name,phone,totalTradesCount,totalTradesVolume,type,verificationLevel,zipCode]);

@override
String toString() {
  return 'UserModel(address: $address, balance: $balance, city: $city, country: $country, currency: $currency, currentTradesCount: $currentTradesCount, currentTradesVolume: $currentTradesVolume, equity: $equity, freeMargin: $freeMargin, isAnyOpenTrades: $isAnyOpenTrades, isSwapFree: $isSwapFree, leverage: $leverage, name: $name, phone: $phone, totalTradesCount: $totalTradesCount, totalTradesVolume: $totalTradesVolume, type: $type, verificationLevel: $verificationLevel, zipCode: $zipCode)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String address, double balance, String city, String country, int currency, int currentTradesCount, double currentTradesVolume, double equity, double freeMargin, bool isAnyOpenTrades, bool isSwapFree, int leverage, String name, String phone, int totalTradesCount, double totalTradesVolume, int type, int verificationLevel, String zipCode
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? address = null,Object? balance = null,Object? city = null,Object? country = null,Object? currency = null,Object? currentTradesCount = null,Object? currentTradesVolume = null,Object? equity = null,Object? freeMargin = null,Object? isAnyOpenTrades = null,Object? isSwapFree = null,Object? leverage = null,Object? name = null,Object? phone = null,Object? totalTradesCount = null,Object? totalTradesVolume = null,Object? type = null,Object? verificationLevel = null,Object? zipCode = null,}) {
  return _then(_UserModel(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as int,currentTradesCount: null == currentTradesCount ? _self.currentTradesCount : currentTradesCount // ignore: cast_nullable_to_non_nullable
as int,currentTradesVolume: null == currentTradesVolume ? _self.currentTradesVolume : currentTradesVolume // ignore: cast_nullable_to_non_nullable
as double,equity: null == equity ? _self.equity : equity // ignore: cast_nullable_to_non_nullable
as double,freeMargin: null == freeMargin ? _self.freeMargin : freeMargin // ignore: cast_nullable_to_non_nullable
as double,isAnyOpenTrades: null == isAnyOpenTrades ? _self.isAnyOpenTrades : isAnyOpenTrades // ignore: cast_nullable_to_non_nullable
as bool,isSwapFree: null == isSwapFree ? _self.isSwapFree : isSwapFree // ignore: cast_nullable_to_non_nullable
as bool,leverage: null == leverage ? _self.leverage : leverage // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,totalTradesCount: null == totalTradesCount ? _self.totalTradesCount : totalTradesCount // ignore: cast_nullable_to_non_nullable
as int,totalTradesVolume: null == totalTradesVolume ? _self.totalTradesVolume : totalTradesVolume // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,verificationLevel: null == verificationLevel ? _self.verificationLevel : verificationLevel // ignore: cast_nullable_to_non_nullable
as int,zipCode: null == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
