import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/account.dart';
import '../../domain/usecases/get_account_usecase.dart';

class AccountNotifier extends StateNotifier<AsyncValue<Account>> {
  final GetAccountUseCase _getAccountUseCase;

  AccountNotifier(this._getAccountUseCase) : super(const AsyncValue.loading()) {
    fetchAccount();
  }

  Future<void> fetchAccount() async {
    try {
      state = const AsyncValue.loading();
      final account = await _getAccountUseCase();
      state = AsyncValue.data(account);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await fetchAccount();
  }
}
