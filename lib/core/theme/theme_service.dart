import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();

  final Rx<ThemeMode> _mode = ThemeMode.system.obs;
  ThemeMode get mode => _mode.value;

  static const String _themeKey = 'theme_mode';
  SharedPreferences? _prefs;

  Future<ThemeService> init() async {
    _prefs = await SharedPreferences.getInstance();
    final savedTheme = _prefs?.getString(_themeKey) ?? 'system';
    _mode.value = _parseTheme(savedTheme);
    return this;
  }

  Future<void> setMode(ThemeMode newMode) async {
    _mode.value = newMode;
    Get.changeThemeMode(newMode);
    await _prefs?.setString(_themeKey, _serializeTheme(newMode));
  }

  ThemeMode _parseTheme(String themeString) {
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _serializeTheme(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
}
