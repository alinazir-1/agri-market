import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();

  final _mode = ThemeMode.system.obs;
  ThemeMode get mode => _mode.value;

  Future<ThemeService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('theme_mode') ?? 'system';
    _mode.value = _parse(saved);
    return this;
  }

  void setMode(ThemeMode m) async {
    _mode.value = m;
    Get.changeThemeMode(m);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme_mode', _serialize(m));
  }

  ThemeMode _parse(String s) {
    if (s == 'light') return ThemeMode.light;
    if (s == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  String _serialize(ThemeMode m) {
    if (m == ThemeMode.light) return 'light';
    if (m == ThemeMode.dark) return 'dark';
    return 'system';
  }
}
