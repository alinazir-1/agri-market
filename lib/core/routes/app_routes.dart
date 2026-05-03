abstract class AppRoutes {
  AppRoutes._();

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const String login = '/login';
  static const String signUp = '/sign-up';

  static const String forgotPassword = '/forgot-password';
  static const String emailVerification = '/email-verification';
  static const String resetPassword = '/reset-password';

  // ── Seller ────────────────────────────────────────────────────────────────
  static const String sellerDashboard = '/seller-dashboard';

  /// Full-screen add / edit product form (pushed from seller area).
  static const String productForm = '/seller-product-form';

  // ── Buyer ─────────────────────────────────────────────────────────────────
  static const String buyerDashboard = '/buyer-dashboard';

  /// Full-screen procurement shopping cart.
  static const String buyerCart = '/buyer-cart';
  static const String verifiedSellers = '/buyer-verified-sellers';
}
