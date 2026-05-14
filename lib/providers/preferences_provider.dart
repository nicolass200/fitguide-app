import 'package:flutter/foundation.dart';
import '../services/preferences_service.dart';

class PreferencesProvider extends ChangeNotifier {
  final PreferencesService _service;

  PreferencesProvider(this._service);

  bool _compactMode = false;

  bool get compactMode => _compactMode;

  Future<void> loadPreferences() async {
    _compactMode = await _service.getCompactMode();
    notifyListeners();
  }

  Future<void> toggleCompactMode(bool value) async {
    _compactMode = value;
    await _service.setCompactMode(value);
    notifyListeners();
  }
}
