import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/storage/auth_local_datasource_provider.dart';
import '../../../../data/models/account_model.dart'; 
import '../../data/repositories/account_repository_impl.dart';
import '../../data/sources/account_remote_source.dart';
import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/usecases/get_account_usecase.dart';
import '../notifiers/account_notifier.dart';  
part 'account_providers.g.dart'; // ← generated file

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final accountRemoteSourceProvider = Provider<AccountRemoteSource>((ref) {
  final dio = ref.read(dioProvider);
  final authLocal = ref.read(authLocalDataSourceProvider);
  return AccountRemoteSource(dio: dio, authLocalDataSource: authLocal);
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepositoryImpl(
    remoteDataSource: ref.read(accountRemoteSourceProvider),
  );
});

final getAccountUseCaseProvider = Provider<GetAccountUseCase>((ref) {
  final repository = ref.read(accountRepositoryProvider);
  return GetAccountUseCase(repository);
});

final accountProvider =
    StateNotifierProvider<AccountNotifier, AsyncValue<Account>>((ref) {
      return AccountNotifier(ref.read(getAccountUseCaseProvider));
    });

@riverpod
AccountModel? cachedAccount(Ref ref) {
  return ref.read(authLocalDataSourceProvider).getAccount();
}
