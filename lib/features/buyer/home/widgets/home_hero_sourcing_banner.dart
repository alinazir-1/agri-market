// lib/features/buyer/home/widgets/home_hero_sourcing_banner.dart
//
// B2B hero: brand panel, sourcing headline, three market modes, search.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/home/home_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';
import 'package:agri_market/shared/widgets/common/app_text_field.dart';

/// Fixed hero height (design).
const double _kHeroHeight = 250;

/// Rounded rects for hero controls (not stadium / full pill).
const double _kHeroControlRadius = AppSize.radius12;

void _openTradeModeSection(int sectionIndex) {
  if (Get.isRegistered<HomeCon>()) {
    Get.find<HomeCon>().dismissBuyerHomeOverlaysNow();
  }
  FocusManager.instance.primaryFocus?.unfocus();
  if (Get.isRegistered<HomeCon>() &&
      sectionIndex >= 0 &&
      sectionIndex <= 2) {
    Get.find<HomeCon>().revealHomeTradeSectionAndScroll(sectionIndex);
  }
}

class HomeHeroSourcingBanner extends StatelessWidget {
  const HomeHeroSourcingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final con = Get.find<HomeCon>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSize.space16,
        AppSize.space8,
        AppSize.space16,
        AppSize.space8,
      ),
      child: AppContainer(
        height: _kHeroHeight,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(AppSize.radius16),
        backgroundColor: AppColors.emeraldGreen,
        boxShadows: [
          BoxShadow(
            color: AppColors.shadowBase.withValues(alpha: 0.1),
            blurRadius: AppSize.space16,
            offset: const Offset(0, AppSize.space8),
          ),
        ],
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: _HeroGridPainter()),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space16,
                vertical: AppSize.space8,
              ),
              child: LayoutBuilder(
                builder: (context, c) {
                  final narrow = c.maxWidth < 520;
                  final titleSize = narrow ? AppSize.font24 : AppSize.font30;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textWhite,
                            height: 1.25,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Global B2B platform that streamlines ',
                            ),
                            TextSpan(
                              text: 'Sourcing',
                              style: TextStyle(
                                fontSize: titleSize,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textWhite.withValues(alpha: 0.78),
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSize.space12),
                      AppContainer(
                        padding: const EdgeInsets.all(AppSize.space4),
                        borderRadius:
                            BorderRadius.circular(_kHeroControlRadius),
                        border: Border.all(
                          color: AppColors.textWhite.withValues(alpha: 0.35),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Obx(() {
                            final sel =
                                Get.find<HomeCon>().homeRevealedTradeSection.value;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _HeroModeChip(
                                  label: 'Marketplace',
                                  icon: Icons.storefront_outlined,
                                  selected: sel == 0,
                                  onTap: () => _openTradeModeSection(0),
                                ),
                                const SizedBox(width: AppSize.space8),
                                _HeroModeChip(
                                  label: 'Advance Booking',
                                  icon: Icons.event_available_outlined,
                                  selected: sel == 1,
                                  onTap: () => _openTradeModeSection(1),
                                ),
                                const SizedBox(width: AppSize.space8),
                                _HeroModeChip(
                                  label: 'Live Auctions',
                                  icon: Icons.gavel_outlined,
                                  selected: sel == 2,
                                  onTap: () => _openTradeModeSection(2),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: AppSize.space12),
                      KeyedSubtree(
                        key: con.heroBannerSearchKey,
                        child: _HeroSearchRow(con: con),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSearchRow extends StatelessWidget {
  const _HeroSearchRow({required this.con});

  final HomeCon con;

  static OutlineInputBorder _plainBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_kHeroControlRadius),
      borderSide: BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = (c.maxWidth).clamp(260.0, 688.0);
        return Center(
          child: SizedBox(
            width: w,
            height: 48,
            child: AppContainer(
              height: 48,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(_kHeroControlRadius),
              backgroundColor: AppColors.backGroundWhite,
              border: Border.all(
                color: AppColors.borderLight,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: AppSize.space4,
                        right: AppSize.space4,
                      ),
                      child: SizedBox(
                        height: 40,
                        child: AppTextField(
                          controller: con.searchCtrl,
                          hintText: 'What are you looking for?',
                          prefixIcon: Icons.search_outlined,
                          prefixIconColor: AppColors.iconSecondary,
                          iconSize: AppSize.icon20,
                          filled: true,
                          fillColor: AppColors.backGroundWhite,
                          isDense: true,
                          height: 40,
                          borderRadius: _kHeroControlRadius,
                          customBorder: _plainBorder(),
                          customFocusedBorder: _plainBorder(),
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
                            horizontal: AppSize.space2,
                            vertical: AppSize.space8,
                          ),
                          textInputAction: TextInputAction.search,
                        ),
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: AppContainer(
                        height: 40,
                        margin: const EdgeInsets.only(
                          top: AppSize.space4,
                          right: AppSize.space4,
                          bottom: AppSize.space4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.space16,
                        ),
                        alignment: Alignment.center,
                        borderRadius:
                            BorderRadius.circular(_kHeroControlRadius),
                        backgroundColor: AppColors.emeraldGreen,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_rounded,
                              color: AppColors.textWhite,
                              size: AppSize.icon16,
                            ),
                            SizedBox(width: AppSize.space4),
                            AppText(
                              text: 'Search',
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: AppSize.font14,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeroModeChip extends StatelessWidget {
  const _HeroModeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg =
        selected ? AppColors.emeraldGreen : AppColors.textWhite;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AppContainer(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space16,
            vertical: AppSize.space12,
          ),
          borderRadius: BorderRadius.circular(_kHeroControlRadius),
          backgroundColor:
              selected ? AppColors.textWhite : AppColors.backGroundTransparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppSize.icon20,
                color: fg,
              ),
              const SizedBox(width: AppSize.space8),
              AppText(
                text: label,
                fontSize: AppSize.font14,
                fontWeight: FontWeight.w600,
                color: fg,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.backGroundWhite.withValues(alpha: 0.07)
      ..strokeWidth = AppSize.borderWidth1;
    const step = 28.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
