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
}
