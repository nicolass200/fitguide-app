// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  // WorkoutX API
  static const String workoutXBaseUrl = 'https://api.workoutxapp.com/v1';

  // Chave da API WorkoutX
  // Rode o app com:
  // flutter run --dart-define=WORKOUTX_API_KEY=SUA_CHAVE_AQUI
  static const String workoutXApiKey = String.fromEnvironment(
    'WORKOUTX_API_KEY',
  );

  // Chave do SharedPreferences
  static const String prefCompactMode = 'compact_mode';

  // Limites do slider de séries
  static const int minSeries = 1;
  static const int maxSeries = 6;

  // Tempo padrão do timer de descanso em segundos
  static const int defaultRestTimeSeconds = 60;

  // Nome do banco de dados local
  static const String databaseName = 'fitguide.db';
  static const int databaseVersion = 1;
}