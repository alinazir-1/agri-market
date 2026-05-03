import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/cart/buyer_cart_bin.dart';
import 'package:agri_market/features/buyer/cart/buyer_cart_con.dart';
import 'package:agri_market/features/buyer/cart/buyer_cart_scr.dart';
import 'package:agri_market/features/buyer/common/widgets/buyer_home_orders_con.dart';
import 'package:agri_market/features/buyer/common/widgets/buyer_orders_dock.dart';
import 'package:agri_market/features/buyer/home/home_bin.dart';
import 'package:agri_market/features/buyer/home/home_con.dart';
import 'package:agri_market/features/buyer/verified_seller/verified_seller_bin.dart';
import 'package:agri_market/features/buyer/verified_seller/verified_seller_scr.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_elevated_button.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';
import 'package:agri_market/shared/widgets/common/app_text_field.dart';

class BuyerTopBar extends StatelessWidget {
  const BuyerTopBar({super.key, this.categoriesMenuAnchorKey});

  /// When null (home), uses [HomeCon.buyerSecondaryNavBarKey]. On pushed routes (e.g. product
  /// detail), pass a **unique** [GlobalKey] so the all-categories overlay does not duplicate keys.
  final GlobalKey? categoriesMenuAnchorKey;

  /// Vertical padding 8+8 + logo 40 — finite height for web layout (avoids infinite [MouseRegion]).
  static const double _barHeight =
      AppSize.space8 + AppSize.space40 + AppSize.space8;

  static const double _topActionIconSize = AppSize.icon20;
  static const double _topActionGap = AppSize.space12;

  /// Narrow pill between nav cluster and location icons.
  static const double _compactSearchMaxWidth = 280;

  @override
  Widget build(BuildContext context) {
    HomeBinding.ensureHomeCon();
    HomeBinding.ensureMessagingControllers();
    HomeBinding.ensureBuyerOrdersCon();
    HomeBinding.ensureBuyerCartCon();
    final con = Get.find<HomeCon>();
    final GlobalKey categoriesAnchor =
        categoriesMenuAnchorKey ?? con.buyerSecondaryNavBarKey;
    // Search lives on [HomeHeroSourcingBanner] (`BuyerShellSearchCon.searchCtrl` via [HomeCon]). To restore
    // the top-bar pill, copy from `home_hero_sourcing_banner.dart` `_HeroSearchRow`.
    return SizedBox(
      width: double.infinity,
      height: _barHeight,
      child: AppContainer(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space32,
          vertical: AppSize.space8,
        ),
        backgroundColor: AppColors.backGroundWhite,
        border: Border(
          bottom: BorderSide(
            color: AppColors.emeraldGreen.withValues(alpha: 0.28),
            width: AppSize.borderWidth1,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Image.asset(AppImages.logo, height: AppSize.space40),
          const SizedBox(width: AppSize.space16),
          _BuyerTopBarAllCategories(anchorKey: categoriesAnchor),
          const SizedBox(width: AppSize.space16),
          const _BuyerTopBarOrdersLink(),
          const SizedBox(width: AppSize.space20),
          _BuyerTopBarTextLink(
            text: 'Supplier',
            onTap: () => Get.to<void>(
              () => const VerifiedSellerScr(),
              binding: VerifiedSellerBinding(),
            ),
          ),
          const SizedBox(width: AppSize.space20),
          const _BuyerTopBarTextLink(text: 'App & extension'),
          Obx(() {
            // Always read an Rx — required for valid Obx use.
            final showCompact = con.showCompactTopBarSearch.value;
            final isDetailRoute = categoriesMenuAnchorKey != null;
            // Product detail (and other pushed routes with [categoriesMenuAnchorKey]): always show
            // compact search — same [maxWidth] / field as home. Home: only when hero hides search.
            final show = isDetailRoute || showCompact;
            if (!show) return const Spacer();
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: AppSize.space12),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: BuyerTopBar._compactSearchMaxWidth,
                    ),
                    child: _BuyerTopBarCompactSearch(
                      controller: con.searchCtrl,
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(width: AppSize.space16),
          const _TopBarIconButton(
            icon: Icons.location_on_outlined,
            iconSize: _topActionIconSize,
            title: 'Enter your location',
            lines: ['Shipping costs and options vary based on location'],
            extraInfoLine:
                'Ali Nazir Star beauty saloon, House 4 street 07, Sahiwal District, Punjab, 57000, Pakistan',
            actionLabel: 'Add address',
            panelWidth: 380,
            titleFontSize: AppSize.font18,
            descriptionMaxLines: 1,
            openAddressDialogOnTap: true,
            useMessageDropdownVisuals: true,
          ),
          const SizedBox(width: _topActionGap),
          const _TopBarIconButton(
            icon: Icons.language_outlined,
            iconSize: _topActionIconSize,
            title: 'Choose language and currency',
            lines: [
              'Select your preferred language and currency. You can update the settings at any time.'
            ],
            showLanguageCurrencyFields: true,
            actionLabel: 'Save',
            panelWidth: 340,
            titleFontSize: AppSize.font18,
            descriptionMaxLines: 2,
            useMessageDropdownVisuals: true,
          ),
          const SizedBox(width: _topActionGap),
          const _BuyerTopBarCartIcon(),
          const SizedBox(width: _topActionGap),
          const _TopBarIconButton(
            icon: Icons.person_outline_rounded,
            iconSize: _topActionIconSize,
            title: '',
            lines: [''],
            panelWidth: 320,
            showSignInFields: true,
            useMessageDropdownVisuals: true,
          ),
          ],
        ),
      ),
    );
  }
}

/// Image-style pill: white field, light border, [Icons.search] prefix (hero uses same [searchCtrl]).
class _BuyerTopBarCompactSearch extends StatelessWidget {
  const _BuyerTopBarCompactSearch({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: 'Search',
      prefixIcon: Icons.search,
      prefixIconColor: AppColors.iconSecondary,
      iconSize: AppSize.icon20,
      filled: true,
      fillColor: AppColors.backGroundWhite,
      height: 36,
      isDense: true,
      borderRadius: AppSize.radius8,
      customBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.radius8),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      customFocusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.radius8),
        borderSide: BorderSide(
          color: AppColors.emeraldGreen.withValues(alpha: 0.45),
          width: AppSize.borderWidth1,
        ),
      ),
      hintStyle: const TextStyle(
        fontSize: AppSize.font14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.3,
      ),
      inputTextStyle: const TextStyle(
        fontSize: AppSize.font14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.3,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSize.space8,
        vertical: AppSize.space8,
      ),
      textInputAction: TextInputAction.search,
    );
  }
}

const String _facebookSocialIconAsset = 'assets/social icon/facebook.png';
const String _googleSocialIconAsset = 'assets/social icon/google.png';
const String _appleSocialIconAsset = 'assets/social icon/Apple Logo.png';

class _BuyerTopBarCartIcon extends StatelessWidget {
  const _BuyerTopBarCartIcon();

  @override
  Widget build(BuildContext context) {
    HomeBinding.ensureBuyerCartCon();
    final cart = Get.find<BuyerCartCon>();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Get.to<void>(
          () => const BuyerCartScr(),
          binding: BuyerCartBinding(),
          transition: Transition.rightToLeft,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AppContainer(
              width: 32,
              height: 32,
              backgroundColor: AppColors.backGroundWhite,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderLight),
              child: Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.iconEmeraldGreen,
                size: BuyerTopBar._topActionIconSize,
              ),
            ),
            Positioned(
              right: -4,
              top: -4,
              child: Obx(() {
                final n = cart.lineCount;
                if (n <= 0) return const SizedBox.shrink();
                return AppContainer(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  backgroundColor: AppColors.emeraldGreen,
                  borderRadius: BorderRadius.circular(10),
                  child: AppText(
                    text: n > 9 ? '9+' : '$n',
                    fontSize: AppSize.font8,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWhite,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuyerTopBarAllCategories extends StatelessWidget {
  const _BuyerTopBarAllCategories({required this.anchorKey});

  final GlobalKey anchorKey;

  @override
  Widget build(BuildContext context) {
    final con = Get.find<HomeCon>();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => con.onAllCategoriesMenuEnter(anchorKey),
      onExit: (_) => con.onAllCategoriesMenuExit(),
      child: AppContainer(
        key: anchorKey,
        height: AppSize.space40,
        padding: const EdgeInsets.symmetric(horizontal: AppSize.space12),
        backgroundColor: AppColors.backGroundWhite,
        borderRadius: BorderRadius.circular(AppSize.radius8),
        border: Border.all(color: AppColors.borderLight),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.grid_view_rounded,
              size: AppSize.icon20,
              color: AppColors.textPrimary,
            ),
            SizedBox(width: AppSize.space8),
            AppText(
              text: 'All Categories',
              fontSize: AppSize.font14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _BuyerTopBarOrdersLink extends StatelessWidget {
  const _BuyerTopBarOrdersLink();

  @override
  Widget build(BuildContext context) {
    HomeBinding.ensureBuyerOrdersCon();
    final orders = Get.find<BuyerHomeOrdersCon>();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => BuyerOrdersDock.open(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppText(
              text: 'Orders',
              fontSize: AppSize.font14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Obx(() {
              final n = orders.activeAttentionCount;
              if (n <= 0) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(left: AppSize.space4),
                child: AppContainer(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  backgroundColor: AppColors.emeraldGreen,
                  borderRadius: BorderRadius.circular(10),
                  child: AppText(
                    text: n > 9 ? '9+' : '$n',
                    fontSize: AppSize.font8,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWhite,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _BuyerTopBarTextLink extends StatelessWidget {
  const _BuyerTopBarTextLink({
    required this.text,
    this.onTap,
  });

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AppText(
          text: text,
          fontSize: AppSize.font14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _TopBarIconButton extends StatefulWidget {
  const _TopBarIconButton({
    required this.icon,
    required this.iconSize,
    required this.title,
    required this.lines,
    this.actionLabel,
    this.showLanguageCurrencyFields = false,
    this.panelWidth = 250,
    this.titleFontSize = AppSize.font20,
    this.descriptionMaxLines = 2,
    this.compactActionButton = false,
    this.extraInfoLine,
    this.openAddressDialogOnTap = false,
    this.useMessageDropdownVisuals = false,
    this.showSignInFields = false,
  });

  final IconData icon;
  final double iconSize;
  final String title;
  final List<String> lines;
  final String? actionLabel;
  final bool showLanguageCurrencyFields;
  final double panelWidth;
  final double titleFontSize;
  final int descriptionMaxLines;
  final bool compactActionButton;
  final String? extraInfoLine;
  final bool openAddressDialogOnTap;

  /// When true (location / language), panel matches [TopBarMessageDropdown] rhythm.
  final bool useMessageDropdownVisuals;
  final bool showSignInFields;

  @override
  State<_TopBarIconButton> createState() => _TopBarIconButtonState();
}

class _TopBarIconButtonState extends State<_TopBarIconButton> {
  final GlobalKey _iconKey = GlobalKey();
  final TextEditingController _signInEmailCtrl = TextEditingController();
  final TextEditingController _signInPasswordCtrl = TextEditingController();
  static const EdgeInsets _signInFloatingContentPadding = EdgeInsets.symmetric(
    horizontal: AppSize.space12,
    vertical: AppSize.space12,
  );
  static const TextStyle _signInInputStyle = TextStyle(
    fontSize: AppSize.font12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static const TextStyle _signInHintStyle = TextStyle(
    fontSize: AppSize.font12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  OverlayEntry? _entry;
  bool _insideIcon = false;
  bool _insidePopup = false;

  void _show() {
    if (_entry != null || !mounted) return;
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;
    final iconCtx = _iconKey.currentContext;
    if (iconCtx == null) return;
    final box = iconCtx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !box.attached) return;
    final topLeft = box.localToGlobal(Offset.zero);
    final iconSize = box.size;
    final panelWidth = widget.panelWidth;
    const horizontalMargin = 12.0;
    final screenW = MediaQuery.sizeOf(context).width;
    final left = (topLeft.dx + iconSize.width - panelWidth).clamp(
      horizontalMargin,
      screenW - panelWidth - horizontalMargin,
    );
    _entry = OverlayEntry(
      builder: (_) => _buildOverlay(
        left: left.toDouble(),
        top: topLeft.dy + iconSize.height + AppSize.space8,
      ),
    );
    overlay.insert(_entry!);
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
  }

  void _openAddressDialog() {
    _hide();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _BuyerAddAddressDialog(),
    );
  }

  void _scheduleHide() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (!_insideIcon && !_insidePopup) {
        _hide();
      }
    });
  }

  OutlineInputBorder _signInEnabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.radius12),
      borderSide: BorderSide(
        color: AppColors.borderGray.withValues(alpha: 0.55),
        width: AppSize.borderWidth1,
      ),
    );
  }

  OutlineInputBorder _signInFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.radius12),
      borderSide: const BorderSide(
        color: AppColors.emeraldGreen,
        width: AppSize.borderWidth1,
      ),
    );
  }

  Widget _buildSignInFloatingField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AppTextField(
          controller: controller,
          hintText: hintText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          isDense: true,
          inputTextStyle: _signInInputStyle,
          hintStyle: _signInHintStyle,
          borderRadius: AppSize.radius12,
          filled: false,
          contentPadding: _signInFloatingContentPadding,
          customBorder: _signInEnabledBorder(),
          customFocusedBorder: _signInFocusedBorder(),
        ),
        Positioned(
          top: -AppSize.space8,
          left: AppSize.space8 + AppSize.space2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.space4),
            color: AppColors.backGroundWhite,
            child: AppText(
              text: label,
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSignInPanelContent() {
    return [
      _buildSignInFloatingField(
        controller: _signInEmailCtrl,
        label: 'Email',
        hintText: 'Enter your email',
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      ),
      const SizedBox(height: AppSize.space8),
      _buildSignInFloatingField(
        controller: _signInPasswordCtrl,
        label: 'Password',
        hintText: 'Enter your password',
        obscureText: true,
        textInputAction: TextInputAction.done,
      ),
      const SizedBox(height: AppSize.space12),
      AppElevatedButton(
        text: 'Sign in',
        width: double.infinity,
        height: 40,
        backgroundColor: AppColors.emeraldGreen,
        textColor: AppColors.textWhite,
        fontSize: AppSize.font14,
        fontWeight: FontWeight.w600,
        borderRadius: AppSize.radius12,
        onPressed: () {},
      ),
      const SizedBox(height: AppSize.space12),
      const Row(
        children: [
          Expanded(child: Divider(color: AppColors.borderLight)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.space8),
            child: AppText(
              text: 'Or continue with',
              fontSize: AppSize.font12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(child: Divider(color: AppColors.borderLight)),
        ],
      ),
      const SizedBox(height: AppSize.space12),
      const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TopBarSocialCircle(asset: _facebookSocialIconAsset, fallback: 'F'),
          SizedBox(width: AppSize.space12),
          _TopBarSocialCircle(asset: _googleSocialIconAsset, fallback: 'G'),
          SizedBox(width: AppSize.space12),
          _TopBarSocialCircle(asset: _appleSocialIconAsset, fallback: 'A'),
        ],
      ),
      const SizedBox(height: AppSize.space12),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppText(
            text: "Don't have account",
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: AppSize.space4),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {},
              child: const AppText(
                text: 'Create account',
                fontSize: AppSize.font12,
                fontWeight: FontWeight.w600,
                color: AppColors.emeraldGreen,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildOverlay({required double left, required double top}) {
    return Positioned(
      left: left,
      top: top,
      width: widget.panelWidth,
      child: Material(
        color: AppColors.backGroundTransparent,
        child: MouseRegion(
          onEnter: (_) => _insidePopup = true,
          onExit: (_) {
            _insidePopup = false;
            _scheduleHide();
          },
          child: AppContainer(
            padding: widget.useMessageDropdownVisuals
                ? const EdgeInsets.symmetric(
                    horizontal: AppSize.space12,
                    vertical: AppSize.space12,
                  )
                : const EdgeInsets.fromLTRB(12, 12, 12, 10),
            backgroundColor: AppColors.backGroundWhite,
            borderRadius: BorderRadius.circular(AppSize.radius12),
            border: Border.all(color: AppColors.borderLight),
            boxShadows: [
              BoxShadow(
                color: AppColors.shadowBase.withValues(
                  alpha: widget.useMessageDropdownVisuals ? 0.10 : 0.14,
                ),
                blurRadius:
                    widget.useMessageDropdownVisuals ? AppSize.space24 : 20,
                offset: const Offset(0, AppSize.space8),
              ),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: widget.showSignInFields
                  ? _buildSignInPanelContent()
                  : [
                      AppText(
                        text: widget.title,
                        fontSize: widget.useMessageDropdownVisuals
                            ? AppSize.font12
                            : widget.titleFontSize,
                        fontWeight: widget.useMessageDropdownVisuals
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(height: AppSize.space4),
                      AppText(
                        text: widget.lines.first,
                        fontSize: widget.useMessageDropdownVisuals
                            ? AppSize.font10
                            : AppSize.font14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: widget.useMessageDropdownVisuals ? 1.3 : null,
                        maxLines: widget.descriptionMaxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.extraInfoLine != null) ...[
                        const SizedBox(height: AppSize.space8),
                        AppContainer(
                          width: double.infinity,
                          padding: EdgeInsets.all(
                            widget.useMessageDropdownVisuals
                                ? AppSize.space12
                                : AppSize.space8,
                          ),
                          borderRadius: BorderRadius.circular(AppSize.radius8),
                          border: Border.all(color: AppColors.borderLight),
                          child: AppText(
                            text: widget.extraInfoLine!,
                            fontSize: widget.useMessageDropdownVisuals
                                ? AppSize.font10
                                : AppSize.font14,
                            fontWeight: widget.useMessageDropdownVisuals
                                ? FontWeight.w500
                                : FontWeight.w500,
                            color: widget.useMessageDropdownVisuals
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                            height:
                                widget.useMessageDropdownVisuals ? 1.3 : null,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      if (widget.showLanguageCurrencyFields) ...[
                        const SizedBox(height: AppSize.space8),
                        _TopBarFieldLabel(
                          text: 'Language',
                          compact: widget.useMessageDropdownVisuals,
                        ),
                        const SizedBox(height: AppSize.space4),
                        _TopBarSelectRow(
                          text: 'English',
                          compact: widget.useMessageDropdownVisuals,
                        ),
                        const SizedBox(height: AppSize.space8),
                        _TopBarFieldLabel(
                          text: 'Currency',
                          compact: widget.useMessageDropdownVisuals,
                        ),
                        const SizedBox(height: AppSize.space4),
                        _TopBarSelectRow(
                          text: 'USD - US Dollar',
                          compact: widget.useMessageDropdownVisuals,
                        ),
                      ],
                      if (widget.actionLabel != null) ...[
                        const SizedBox(height: AppSize.space8),
                        Align(
                          alignment: Alignment.center,
                          child: AppContainer(
                            height: widget.useMessageDropdownVisuals ? 32 : 34,
                            width: widget.compactActionButton
                                ? 180
                                : double.infinity,
                            alignment: Alignment.center,
                            borderRadius:
                                BorderRadius.circular(AppSize.radiusCircular),
                            backgroundColor: AppColors.emeraldGreen,
                            child: GestureDetector(
                              onTap: widget.openAddressDialogOnTap
                                  ? _openAddressDialog
                                  : null,
                              child: AppContainer(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.center,
                                backgroundColor:
                                    AppColors.backGroundTransparent,
                                child: AppText(
                                  text: widget.actionLabel!,
                                  fontSize: widget.useMessageDropdownVisuals
                                      ? AppSize.font12
                                      : AppSize.font16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textWhite,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _signInEmailCtrl.dispose();
    _signInPasswordCtrl.dispose();
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        _insideIcon = true;
        _show();
      },
      onExit: (_) {
        _insideIcon = false;
        _scheduleHide();
      },
      child: GestureDetector(
        key: _iconKey,
        onTap: widget.openAddressDialogOnTap ? _openAddressDialog : _show,
        child: AppContainer(
          width: 32,
          height: 32,
          backgroundColor: AppColors.backGroundWhite,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderLight),
          child: Icon(
            widget.icon,
            color: AppColors.iconEmeraldGreen,
            size: widget.iconSize,
          ),
        ),
      ),
    );
  }
}

class _TopBarSocialCircle extends StatelessWidget {
  const _TopBarSocialCircle({
    required this.asset,
    required this.fallback,
  });

  final String asset;
  final String fallback;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: AppContainer(
          width: 40,
          height: 40,
          shape: BoxShape.circle,
          backgroundColor: AppColors.backGroundWhite,
          border: Border.all(color: AppColors.borderLight),
          alignment: Alignment.center,
          child: Image.asset(
            asset,
            width: 22,
            height: 22,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => AppText(
              text: fallback,
              fontSize: AppSize.font14,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}

class _BuyerAddAddressDialog extends StatelessWidget {
  const _BuyerAddAddressDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSize.space32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.radius12),
      ),
      child: AppContainer(
        width: 760,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        backgroundColor: AppColors.backGroundWhite,
        borderRadius: BorderRadius.circular(AppSize.radius12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppText(
                    text: 'Add address',
                    fontSize: AppSize.font24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  const Spacer(),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.close_rounded,
                        size: AppSize.icon24,
                        color: AppColors.iconSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.space12),
              const _TopBarFieldLabel(text: 'Country / region *'),
              const SizedBox(height: AppSize.space4),
              const _TopBarSelectRow(text: 'Pakistan'),
              const SizedBox(height: AppSize.space12),
              const Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      hintText: 'First name and Last name *',
                      isDense: true,
                      height: 42,
                      filled: true,
                      fillColor: AppColors.backGroundWhite,
                      borderRadius: AppSize.radius8,
                    ),
                  ),
                  SizedBox(width: AppSize.space12),
                  Expanded(
                    child: AppTextField(
                      hintText: 'Phone number *',
                      isDense: true,
                      height: 42,
                      filled: true,
                      fillColor: AppColors.backGroundWhite,
                      borderRadius: AppSize.radius8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.space12),
              const AppTextField(
                hintText: 'Street address or P.O. box *',
                isDense: true,
                height: 42,
                filled: true,
                fillColor: AppColors.backGroundWhite,
                borderRadius: AppSize.radius8,
              ),
              const SizedBox(height: AppSize.space12),
              const AppTextField(
                hintText: 'Apartment, suite, unit, building, floor (optional)',
                isDense: true,
                height: 42,
                filled: true,
                fillColor: AppColors.backGroundWhite,
                borderRadius: AppSize.radius8,
              ),
              const SizedBox(height: AppSize.space12),
              const Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      hintText: 'State / province *',
                      isDense: true,
                      height: 42,
                      filled: true,
                      fillColor: AppColors.backGroundWhite,
                      borderRadius: AppSize.radius8,
                    ),
                  ),
                  SizedBox(width: AppSize.space12),
                  Expanded(
                    child: AppTextField(
                      hintText: 'City *',
                      isDense: true,
                      height: 42,
                      filled: true,
                      fillColor: AppColors.backGroundWhite,
                      borderRadius: AppSize.radius8,
                    ),
                  ),
                  SizedBox(width: AppSize.space12),
                  Expanded(
                    child: AppTextField(
                      hintText: 'Postal code *',
                      isDense: true,
                      height: 42,
                      filled: true,
                      fillColor: AppColors.backGroundWhite,
                      borderRadius: AppSize.radius8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.space16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppContainer(
                    width: 120,
                    height: 38,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(AppSize.radiusCircular),
                    border: Border.all(color: AppColors.borderGray),
                    child: const AppText(
                      text: 'Cancel',
                      fontSize: AppSize.font14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: AppSize.space12),
                  AppContainer(
                    width: 140,
                    height: 38,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(AppSize.radiusCircular),
                    backgroundColor: AppColors.emeraldGreen,
                    child: const AppText(
                      text: 'Submit',
                      fontSize: AppSize.font14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBarFieldLabel extends StatelessWidget {
  const _TopBarFieldLabel({required this.text, this.compact = false});

  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: text,
      fontSize: compact ? AppSize.font10 : AppSize.font16,
      fontWeight: compact ? FontWeight.w700 : FontWeight.w500,
      color: AppColors.textPrimary,
    );
  }
}

class _TopBarSelectRow extends StatelessWidget {
  const _TopBarSelectRow({required this.text, this.compact = false});

  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final rowH = compact ? 32.0 : 38.0;
    final iconSz = compact ? AppSize.icon16 : AppSize.icon20;
    return AppContainer(
      height: rowH,
      padding: const EdgeInsets.symmetric(horizontal: AppSize.space12),
      borderRadius: BorderRadius.circular(AppSize.radius4),
      border: Border.all(color: AppColors.borderGray),
      child: Row(
        children: [
          Expanded(
            child: AppText(
              text: text,
              fontSize: compact ? AppSize.font10 : AppSize.font16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppContainer(
            width: AppSize.borderWidth1,
            height: compact ? 14.0 : 18.0,
            backgroundColor: AppColors.borderGray,
          ),
          SizedBox(width: compact ? AppSize.space4 : AppSize.space8),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: iconSz,
            color: AppColors.iconSecondary,
          ),
        ],
      ),
    );
  }
}
