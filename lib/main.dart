import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Core/Routes/app_pages.dart';
import 'Core/Routes/app_routes.dart';
import 'Core/Theme/app_theme.dart';
import 'Core/Theme/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => ThemeService().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriMarket',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeService.to.mode,
      initialRoute: AppRoutes.login,
      getPages: AppPages.pages,
    );
  }
}
