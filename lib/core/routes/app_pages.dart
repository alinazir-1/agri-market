import 'package:get/get.dart';

import 'package:agri_market/core/routes/app_routes.dart';
import 'package:agri_market/features/auth/email_verification_bin.dart';
import 'package:agri_market/features/auth/email_verification_scr.dart';
import 'package:agri_market/features/auth/forgot_password_bin.dart';
import 'package:agri_market/features/auth/forgot_password_scr.dart';
import 'package:agri_market/features/auth/login_bin.dart';
import 'package:agri_market/features/auth/login_scr.dart';
import 'package:agri_market/features/auth/reset_password_bin.dart';
import 'package:agri_market/features/auth/reset_password_scr.dart';
import 'package:agri_market/features/auth/signup_bin.dart';
import 'package:agri_market/features/auth/signup_scr.dart';
import 'package:agri_market/features/buyer/cart/buyer_cart_bin.dart';
import 'package:agri_market/features/buyer/cart/buyer_cart_scr.dart';
import 'package:agri_market/features/buyer/home/home_bin.dart';
import 'package:agri_market/features/buyer/home/home_scr.dart';
import 'package:agri_market/features/buyer/verified_seller/verified_seller_bin.dart';
import 'package:agri_market/features/buyer/verified_seller/verified_seller_scr.dart';
import 'package:agri_market/features/seller/add_product/add_new_product_con.dart';
import 'package:agri_market/features/seller/add_product/product_form_screen.dart';
import 'package:agri_market/features/seller/sidebar/side_bar_bin.dart';
import 'package:agri_market/features/seller/sidebar/side_bar_scr.dart';

abstract class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
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
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgotPasswordScr(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.emailVerification,
      page: () => EmailVerificationScr(),
      binding: EmailVerificationBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => ResetPasswordScr(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.sellerDashboard,
      page: () => SellerSideBarScr(),
      binding: SellerSideBarBinding(),
    ),
    GetPage(
      name: AppRoutes.productForm,
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<AddNewProductCon>()) {
          Get.put(AddNewProductCon(), permanent: true);
        }
        Get.find<AddNewProductCon>().resetFormForCreate();
      }),
      page: () => ProductFormScreen(),
    ),
    GetPage(
      name: AppRoutes.buyerDashboard,
      page: () => const HomeScr(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.buyerCart,
      page: () => const BuyerCartScr(),
      binding: BuyerCartBinding(),
    ),
    GetPage(
      name: AppRoutes.verifiedSellers,
      page: () => const VerifiedSellerScr(),
      binding: VerifiedSellerBinding(),
    ),
  ];
}
