// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class ThemeUiModelAdapter extends TypeAdapter<ThemeUiModel> {
  @override
  final typeId = 2;

  @override
  ThemeUiModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeUiModel(
      themeMode: fields[1] == null ? ThemeMode.system : fields[1] as ThemeMode,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeUiModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.themeMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeUiModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LoginCredentialsAdapter extends TypeAdapter<LoginCredentials> {
  @override
  final typeId = 3;

  @override
  LoginCredentials read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginCredentials(
      firetruckCode: fields[5] as String,
      firetruckName: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LoginCredentials obj) {
    writer
      ..writeByte(2)
      ..writeByte(5)
      ..write(obj.firetruckCode)
      ..writeByte(6)
      ..write(obj.firetruckName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginCredentialsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
