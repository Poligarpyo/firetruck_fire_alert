class AppFailure {
  final String message;
  final int? statusCode;

  const AppFailure({
    required this.message,
    this.statusCode,
  });
}