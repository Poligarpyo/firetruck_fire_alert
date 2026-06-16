abstract class NetworkException implements Exception {
  String get message;
}

class NoInternetException extends NetworkException {
  @override
  String get message => "No Internet Connection. Please check your network.";
}

class TokenExpiredException extends NetworkException {
  @override
  String get message => "Session expired. Please login again.";
}

class ServerErrorException extends NetworkException {
  @override
  String get message => "Something went wrong. Please try again later.";
}

class UnknownNetworkException extends NetworkException {
  final String error;
  UnknownNetworkException(this.error);

  @override
  String get message => "Unexpected error: $error";
}
