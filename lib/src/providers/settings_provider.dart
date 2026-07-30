import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  SettingsProvider(this._prefs) {
    _loadSettings();
  }

  ThemeMode _themeMode = ThemeMode.system;
  String _currencySymbol = '€';

  ThemeMode get themeMode => _themeMode;
  String get currencySymbol => _currencySymbol;

  void _loadSettings() {
    final themeIndex = _prefs.getInt('themeMode') ?? ThemeMode.system.index;
    _themeMode = ThemeMode.values[themeIndex];
    _currencySymbol = _prefs.getString('currencySymbol') ?? '€';
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode newMode) async {
    if (newMode == _themeMode) return;
    _themeMode = newMode;
    await _prefs.setInt('themeMode', newMode.index);
    notifyListeners();
  }

  Future<void> updateCurrencySymbol(String symbol) async {
    if (symbol == _currencySymbol) return;
    _currencySymbol = symbol;
    await _prefs.setString('currencySymbol', symbol);
    notifyListeners();
  }
}
