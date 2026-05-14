class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class ApiException extends AppException {
  final int? statusCode;
  const ApiException(super.message, {this.statusCode});
}

class NetworkException extends AppException {
  const NetworkException()
      : super('Sem conexão com a internet. Verifique sua rede e tente novamente.');
}

class TimeoutException extends AppException {
  const TimeoutException()
      : super('A requisição demorou muito. Tente novamente.');
}

class DatabaseAppException extends AppException {
  const DatabaseAppException(super.message);
}