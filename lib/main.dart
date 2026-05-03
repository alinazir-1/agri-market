import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/routes/app_pages.dart';
import 'package:agri_market/core/routes/app_routes.dart';
import 'package:agri_market/core/theme/app_theme.dart';

// ═══ Launch (only flags here; all routes stay in [AppPages.pages] — not removed) ═══
/// `true` — cold start opens buyer home directly.
/// `false` — start at [AppRoutes.login] (auth first).
const bool kLaunchOpenBuyerHome = true;

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
