// home_product_boxes.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/home/home_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

// ── Trade by mode (horizontal cards) ──────────────────────────────────────────
class _TradeModeCardData {
  final int sectionIndex;
  final String badgeText;
  final String title;
  final String description;
  final String ctaText;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color pillBg;
  final Color pillText;
  final Color ctaColor;

  const _TradeModeCardData({
    required this.sectionIndex,
    required this.badgeText,
    required this.title,
    required this.description,
    required this.ctaText,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.pillBg,
    required this.pillText,
    required this.ctaColor,
  });
}

class HomeProductBoxes extends StatelessWidget {
  const HomeProductBoxes({super.key});

  static const List<_TradeModeCardData> _cards = [
    _TradeModeCardData(
      sectionIndex: 0,
      badgeText: '2,400+ Listings',
      title: 'Marketplace',
      description:
          'Instant procurement of ready stocks with transparent pricing and logistics support.',
      ctaText: 'Browse Store',
      icon: Icons.storefront_outlined,
      iconBg: AppColors.emerald100,
      iconColor: AppColors.emeraldGreen,
      pillBg: AppColors.badgeSuccessBg,
      pillText: AppColors.badgeSuccessText,
      ctaColor: AppColors.emeraldGreen,
    ),
    _TradeModeCardData(
      sectionIndex: 1,
      badgeText: 'Next Harvest',
      title: 'Advance Booking',
      description:
          'Lock in prices for upcoming harvests. Secure your supply chain ahead of market volatility.',
      ctaText: 'View Schedule',
      icon: Icons.calendar_month_outlined,
      iconBg: AppColors.backgroundDivider,
      iconColor: AppColors.textSecondary,
      pillBg: AppColors.backgroundSurface,
      pillText: AppColors.textSecondary,
      ctaColor: AppColors.emeraldGreen,
    ),
    _TradeModeCardData(
      sectionIndex: 2,
      badgeText: '12 Live Now',
      title: 'Live Auctions',
      description:
          'Competitive bidding for premium lots. High-frequency trade environment for volume buyers.',
      ctaText: 'Join Auction',
      icon: Icons.gavel_rounded,
      iconBg: AppColors.badgeWarningBg,
      iconColor: AppColors.badgeWarningText,
      pillBg: AppColors.badgeWarningBg,
      pillText: AppColors.badgeWarningText,
      ctaColor: AppColors.badgeWarningText,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      backgroundColor: AppColors.backgroundPage,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space32,
        vertical: AppSize.space16,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _cards.asMap().entries.map((e) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: e.key < _cards.length - 1 ? AppSize.space16 : 0,
                ),
                child: _TradeModeCard(data: e.value),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TradeModeCard extends StatelessWidget {
  const _TradeModeCard({required this.data});

  final _TradeModeCardData data;

  void _openSection() {
    if (!Get.isRegistered<HomeCon>()) return;
    Get.find<HomeCon>().revealHomeTradeSectionAndScroll(data.sectionIndex);
  }

  @override
  Widget build(BuildContext context) {
    final bgPath = AppImages.tradeModeHeroJpeg(data.title);

    return Material(
      color: AppColors.backGroundTransparent,
      borderRadius: BorderRadius.circular(AppSize.radius12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSize.radius12),
        onTap: _openSection,
        child: AppContainer(
          borderRadius: BorderRadius.circular(AppSize.radius12),
          border: Border.all(color: AppColors.borderLight),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.asset(
                  bgPath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => ColoredBox(
                    color: AppColors.backGroundWhite,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSize.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppContainer(
                          width: 40,
                          height: 40,
                          borderRadius: BorderRadius.circular(AppSize.radius8),
                          backgroundColor: data.iconBg,
                          alignment: Alignment.center,
                          child: Icon(
                            data.icon,
                            color: data.iconColor,
                            size: AppSize.icon20,
                          ),
                        ),
                        const Spacer(),
                        AppContainer(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.space8,
                            vertical: AppSize.space4,
                          ),
                          borderRadius:
                              BorderRadius.circular(AppSize.radiusCircular),
                          backgroundColor: data.pillBg,
                          child: AppText(
                            text: data.badgeText,
                            fontSize: AppSize.font12,
                            fontWeight: FontWeight.w600,
                            color: data.pillText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSize.space12),
                    AppText(
                      text: data.title,
                      fontSize: AppSize.font18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                    const SizedBox(height: AppSize.space8),
                    Expanded(
                      child: AppText(
                        text: data.description,
                        fontSize: AppSize.font14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textWhite,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: AppSize.space12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          text: data.ctaText,
                          fontSize: AppSize.font14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textWhite,
                        ),
                        const SizedBox(width: AppSize.space4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: AppSize.icon16,
                          color: AppColors.iconWhite,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── HomeProductsBottomBanner ──────────────────────────────────────────────────
// Place this widget AFTER HomeProductBoxes in HomeScr
class HomeProductsBottomBanner extends StatelessWidget {
  const HomeProductsBottomBanner({super.key});

  static const List<_BottomBannerData> _banners = [
    _BottomBannerData(
      gradient: LinearGradient(
        colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
        begin: Alignment.topLeft, end: Alignment.bottomRight),
      icon: Icons.local_offer_outlined,
      tag: 'BULK DISCOUNT',
      tagBg: Color(0xFFD1FAE5), tagColor: Color(0xFF059669),
      title: 'Order 50+ Bags & Save Up to 15%',
      sub: 'Exclusive bulk pricing on grains, oil seeds, and legumes',
    ),
    _BottomBannerData(
      gradient: LinearGradient(
        colors: [Color(0xFF1E40AF), Color(0xFF1D4ED8)],
        begin: Alignment.topLeft, end: Alignment.bottomRight),
      icon: Icons.event_available_outlined,
      tag: 'BOOK EARLY',
      tagBg: Color(0xFFDBEAFE), tagColor: Color(0xFF1D4ED8),
      title: 'Advance Booking — Wheat Season Opening Soon',
      sub: 'Reserve at today\'s rates before market fluctuations hit',
    ),
    _BottomBannerData(
      gradient: LinearGradient(
        colors: [Color(0xFFC2410C), Color(0xFFDC2626)],
        begin: Alignment.topLeft, end: Alignment.bottomRight),
      icon: Icons.gavel_rounded,
      tag: 'LIVE AUCTIONS',
      tagBg: Color(0xFFFEE2E2), tagColor: Color(0xFFDC2626),
      title: 'Premium Lots Going Live — Bid & Win',
      sub: 'Transparent real-time bidding every day on top-quality produce',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F4EF),
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 16),
      child: Row(
        children: _banners.asMap().entries.map((e) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: e.key < _banners.length - 1 ? 14 : 0),
              child: _BottomBannerCard(data: e.value),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BottomBannerData {
  final LinearGradient gradient;
  final IconData       icon;
  final String         tag, title, sub;
  final Color          tagBg, tagColor;
  const _BottomBannerData({
    required this.gradient,  required this.icon,
    required this.tag,       required this.title,    required this.sub,
    required this.tagBg,     required this.tagColor,
  });
}

class _BottomBannerCard extends StatefulWidget {
  final _BottomBannerData data;
  const _BottomBannerCard({required this.data});
  @override
  State<_BottomBannerCard> createState() => _BottomBannerCardState();
}

class _BottomBannerCardState extends State<_BottomBannerCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 72,
        transform: _hovered
            ? Matrix4.translationValues(0, -2, 0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          gradient: widget.data.gradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: _hovered
              ? [BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10, offset: const Offset(0, 4))]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Row(children: [
                Icon(widget.data.icon, color: Colors.white, size: 26),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                        decoration: BoxDecoration(
                          color: widget.data.tagBg,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(widget.data.tag,
                          style: TextStyle(
                            fontSize: 7.5, fontWeight: FontWeight.w800,
                            color: widget.data.tagColor, letterSpacing: 0.6)),
                      ),
                      const SizedBox(height: 2),
                      Text(widget.data.title,
                        style: const TextStyle(
                          color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w800),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(widget.data.sub,
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward_rounded, color: Colors.white70, size: 17),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
