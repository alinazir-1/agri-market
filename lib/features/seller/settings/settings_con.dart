import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/theme/theme_service.dart';

class SettingsCon extends GetxController {
  // ── Theme ──────────────────────────────────────────────────────────────────
  /// Reactive copy of [ThemeService] mode so Obx can observe theme (getter alone is not .obs).
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  /// Web hover highlight for theme tiles (no StatefulWidget).
  final hoveredThemeOptionId = Rxn<String>();
  /// Web hover highlight for settings nav rows.
  final hoveredNavId = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<ThemeService>()) {
      themeMode.value = ThemeService.to.mode;
    }
  }

  void setTheme(ThemeMode m) {
    themeMode.value = m;
    ThemeService.to.setMode(m);
  }

  // ── Notifications ──────────────────────────────────────────────────────────
  final orderNotifs = true.obs;
  final paymentNotifs = true.obs;
  final messageNotifs = true.obs;
  final stockAlerts = true.obs;
  final reviewNotifs = true.obs;
  final marketingEmails = false.obs;
  final smsAlerts = false.obs;

  // ── Security ───────────────────────────────────────────────────────────────
  final twoFactorEnabled = false.obs;
  final loginAlerts = true.obs;

  // ── Privacy ────────────────────────────────────────────────────────────────
  final showOnlineStatus = true.obs;
  final publicProfile = true.obs;
  final showSalesStats = false.obs;

  // ── Language ───────────────────────────────────────────────────────────────
  final selectedLanguage = 'English'.obs;
  final languages = const ['English', 'Urdu', 'Hindi', 'Punjabi', 'Arabic'];

  void setLanguage(String lang) => selectedLanguage.value = lang;

  // ── App info ───────────────────────────────────────────────────────────────
  final appVersion = 'v1.0.0 (Build 42)';
}
