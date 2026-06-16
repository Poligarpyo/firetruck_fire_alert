import '../../../../data/models/account_model.dart';
import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
 
import '../sources/account_remote_source.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteSource remoteDataSource;

  AccountRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Account> getAccount() async {
    final model = await remoteDataSource.fetchAccount();
    return model.toEntity();
  }
  
 

 
}
