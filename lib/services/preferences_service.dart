// lib/services/preferences_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class PreferencesService {
  /// Salva a preferência de modo compacto
  Future<void> setCompactMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefCompactMode, value);
  }

  /// Lê a preferência de modo compacto (padrão: false)
  Future<bool> getCompactMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.prefCompactMode) ?? false;
  }
}
