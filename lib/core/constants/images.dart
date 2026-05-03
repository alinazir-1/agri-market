// Asset path constants for all images: logos, banners, category icons, product placeholders.
class AppImages {
  AppImages._();

  ///* =============== Logo =============== *///
  static const String logo = "assets/logo/Agri Krop.png";

  ///* =============== Social Media Images =============== *///
  static const String facebook = "assets/social icon/facebook.png";
  static const String google = "assets/social icon/google.png";

  ///Banners
  static const String homeBanner1 = 'assets/banner images/1.png';
  static const String homeBanner2 = 'assets/banner images/2.png';
  static const String homeBanner3 = 'assets/banner images/3.png';
  static const String homeBanner4 = 'assets/banner images/banner4.png';
  static const String homeBanner5 = 'assets/banner images/banner5.png';
  static const String landingPage = 'assets/banner images/LandingPage.png';
  static const String brandingBanner =
      'assets/banner images/branding banner.png';
  static const String frame3384401 = 'assets/banner images/Frame 3384401.png';

  ///Category Icons
  static const String grainsAndCereals = 'assets/category images/grains.png';
  static const String freshProduce = 'assets/category images/fresh-produce.png';
  static const String legumes = 'assets/category images/Legumes.png';
  static const String animalFeeds = 'assets/category images/animalfeed.png';
  static const String byProducts = 'assets/category images/byproducts.png';
  static const String fodderForage = 'assets/category images/fodder.png';
  static const String livestock = 'assets/category images/livestock.png';
  static const String oilSeeds = 'assets/category images/Oil Seeds.png';

  /// B2B catalog category tiles: `assets/category/<name>.jpg` must match
  /// [ProductCatalogData] top-level keys exactly (same filename as category).
  static String categoryCatalogJpeg(String productCatalogTopLevelName) =>
      'assets/category/$productCatalogTopLevelName.jpg';

  /// Buyer home — Trade by mode cards (`Marketplace`, `Advance Booking`, `Live Auctions`).
  static String tradeModeHeroJpeg(String modeTitle) =>
      'assets/Mode Images/$modeTitle.jpg';

  /// Buyer home — logistics promo strip below Top Ranked.
  static const String modeLogisticBanner = 'assets/Mode Images/logistic.jpg';

  ///Products Images
  static const String p1 = 'assets/images/rice.png';
  static const String p2 = 'assets/images/buyermarket2.png';
  static const String p3 = 'assets/images/buyermarket3.png';
  static const String p4 = 'assets/images/buyermarket4.png';
  static const String p5 = 'assets/images/buyermarket5.png';
  static const String p6 = 'assets/images/buyermarket6.png';
}
