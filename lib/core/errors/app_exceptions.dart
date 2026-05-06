// lib/core/errors/app_exceptions.dart

/// Exceção base do aplicativo
class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

/// Falha na comunicação com a API
class ApiException extends AppException {
  final int? statusCode;
  const ApiException(super.message, {this.statusCode});
}

/// Sem conexão com a internet
class NetworkException extends AppException {
  const NetworkException()
      : super('Sem conexão com a internet. Verifique sua rede e tente novamente.');
}

/// Timeout na requisição
class TimeoutException extends AppException {
  const TimeoutException()
      : super('A requisição demorou muito. Tente novamente.');
}

/// Erro ao acessar o banco de dados local
class DatabaseAppException extends AppException {
  const DatabaseAppException(super.message);
}