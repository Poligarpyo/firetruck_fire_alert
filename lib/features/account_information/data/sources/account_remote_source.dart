import 'package:dio/dio.dart'; 
import '../../../../data/models/account_model.dart';
import '../../../../shared/constants/endpoints.dart';
import '../../../../shared/constants/dio_helper.dart';
import '../../../../core/storage/auth_local_datasource.dart'; 
 
class AccountRemoteSource {
  final Dio dio;
  final AuthLocalDataSource authLocalDataSource;
  AccountRemoteSource({
    required this.dio,
    required this.authLocalDataSource,
  });

  Future<AccountModel> fetchAccount() async {
    try {
      final login = authLocalDataSource.getLogin();
      final token = authLocalDataSource.getToken();

      if (login == null || token == null) {
        throw Exception('❌ No login or token found in local storage');
      }

      final Response response = await DioHelper.post(
        '${Endpoints.peanutUrl}${Endpoints.exampleAccount}',
        data: {
          "login": login,
          "token": token,
        }, 
      );

      return AccountModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(
        '❌ Errors [${e.response?.statusCode}] => ${e.message}',
      );
    }
  }

 
}
