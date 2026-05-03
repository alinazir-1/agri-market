import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/routes/app_pages.dart';
import 'package:agri_market/core/routes/app_routes.dart';
import 'package:agri_market/core/theme/app_theme.dart';

// ═══ Launch — all routes stay in [AppPages.pages]; only [initialRoute] changes here ═══
/// `true` — cold start opens [AppRoutes.buyerDashboard] (skip login screen).
/// `false` — cold start at [AppRoutes.login]; buyer/seller/auth routes all navigable as usual.
const bool kLaunchOpenBuyerHome = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AgriMarketApp());
}

class AgriMarketApp extends StatelessWidget {
  const AgriMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Agri Market',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      initialRoute: kLaunchOpenBuyerHome
          ? AppRoutes.buyerDashboard
          : AppRoutes.login,
      getPages: AppPages.pages,
    );
  }
}
