class AppConstants {
  AppConstants._();

  static const String workoutXBaseUrl = 'https://api.workoutxapp.com/v1';

  // Chave da API WorkoutX
  // Rode o app com:
  // flutter run --dart-define=WORKOUTX_API_KEY=SUA_CHAVE_AQUI
  static const String workoutXApiKey = String.fromEnvironment(
    'WORKOUTX_API_KEY',
  );

  static const String prefCompactMode = 'compact_mode';

  static const int minSeries = 1;
  static const int maxSeries = 6;

  static const int defaultRestTimeSeconds = 60;

  static const String databaseName = 'fitguide.db';
  static const int databaseVersion = 1;
}