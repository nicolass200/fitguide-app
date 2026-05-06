// lib/core/constants/app_constants.dart

class AppConstants {
  // Construtor privado — classe utilitária, não deve ser instanciada
  AppConstants._();

  // WGER API
  static const String wgerBaseUrl = 'https://wger.de/api/v2';
  static const String wgerLanguagePt = '7'; // Português
  static const String wgerLanguageEn = '2'; // Inglês (fallback)

  // Chave do SharedPreferences
  static const String prefCompactMode = 'compact_mode';

  // Limites do slider de séries
  static const int minSeries = 1;
  static const int maxSeries = 6;

  // Tempo padrão do timer de descanso (segundos)
  static const int defaultRestTimeSeconds = 60;

  // Nome do banco de dados local
  static const String databaseName = 'fitguide.db';
  static const int databaseVersion = 1;
}
