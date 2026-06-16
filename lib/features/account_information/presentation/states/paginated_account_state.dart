import '../../domain/entities/account.dart';

class PaginatedAccountState {
  final Account? account;
  final bool isLoading;
  final String? error;

  PaginatedAccountState({
    this.account,
    this.isLoading = false,
    this.error,
  });

  PaginatedAccountState copyWith({
    Account? account,
    bool? isLoading,
    String? error,
  }) {
    return PaginatedAccountState(
      account: account ?? this.account,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
