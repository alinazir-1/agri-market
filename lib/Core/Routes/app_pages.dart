import 'package:get/get.dart';

import '../../Seller Section/Seller Screens/Side Bar/side_bar_bin.dart';
import '../../Seller Section/Seller Screens/Side Bar/side_bar_scr.dart';
import '../../Shared/Auth/login_bin.dart';
import '../../Shared/Auth/login_scr.dart';
import '../../Shared/Auth/signup_bin.dart';
import '../../Shared/Auth/signup_scr.dart';
import 'app_routes.dart';

abstract class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    // ── Auth ──────────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScr(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => SignUpScr(),
      binding: SignUpBinding(),
    ),

    // ── Seller ────────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.sellerDashboard,
      page: () => SellerSideBarScr(),
      binding: SellerSideBarBinding(),
    ),
  ];
}
