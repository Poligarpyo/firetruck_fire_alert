import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
 
import 'auth_local_datasource.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final box = Hive.box(authBoxName);
  return AuthLocalDataSource(box);
});
