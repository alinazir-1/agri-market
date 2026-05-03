// lib/features/seller/sidebar/widgets/side_bar_components.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/routes/app_routes.dart';
import 'package:agri_market/core/constants/images.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/features/seller/sidebar/side_bar_con.dart';
import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_text.dart';

// ─── SIDEBAR ──────────────────────────────────────────────────────────────────
class SideBar extends StatelessWidget {
  const SideBar({super.key, required this.c});
  final SellerSideBarCon c;

  @override
  Widget build(BuildContext context) {
    final isCollapsed =
        MediaQuery.of(context).size.width < AppSize.breakpointDesktop;
    final sidebarWidth = isCollapsed
        ? AppSize.sideBarWidthCollapsed
        : AppSize.sideBarWidthExpanded;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: context.cardBg,
        border: Border(
          right: BorderSide(
              color: context.borderClr, width: AppSize.borderWidth1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? AppSize.space12 : AppSize.space16,
              vertical: AppSize.space16,
            ),
            child: isCollapsed
                ? Image.asset(AppImages.logo,
                    height: AppSize.icon32,
                    width: AppSize.icon32,
                    fit: BoxFit.contain)
                : Image.asset(AppImages.logo, height: AppSize.space40),
          ),
          Divider(
              height: AppSize.borderWidth1,
              thickness: AppSize.borderWidth05,
              color: context.borderClr),
          const SizedBox(height: AppSize.space8),
          Expanded(
            child: Obx(() {
              final selected = c.selectedIndex.value;
              return ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: isCollapsed ? AppSize.space8 : AppSize.space8,
                  vertical: AppSize.space4,
                ),
                itemCount: SellerSideBarCon.sideBarEntries.length,
                itemBuilder: (context, index) {
                  final entry = SellerSideBarCon.sideBarEntries[index];
                  if (entry is SideBarHeading) {
                    return isCollapsed
                        ? const SizedBox(height: AppSize.space12)
                        : _SectionHeading(title: entry.title);
                  }
                  final nav = entry as NavItem;
                  return NavItemWidget(
                    item: nav,
                    c: c,
                    isCollapsed: isCollapsed,
                    isSelected: selected == nav.screenIndex,
                  );
                },
              );
            }),
          ),
          Divider(
              height: AppSize.borderWidth1,
              thickness: AppSize.borderWidth05,
              color: context.borderClr),
          LogoutButton(isCollapsed: isCollapsed),
        ],
      ),
    );
  }
}

// ─── SECTION HEADING ──────────────────────────────────────────────────────────
class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSize.space12,
        top: AppSize.space12,
        bottom: AppSize.space4,
      ),
      child: AppText(
        text: title,
        fontSize: AppSize.font10,
        fontWeight: FontWeight.w700,
        color: context.txtSecondary,
        letterSpacing: 1.2,
      ),
    );
  }
}

// ─── NAV ITEM ─────────────────────────────────────────────────────────────────
class NavItemWidget extends StatelessWidget {
  const NavItemWidget({
    super.key,
    required this.item,
    required this.c,
    required this.isCollapsed,
    required this.isSelected,
  });

  final NavItem item;
  final SellerSideBarCon c;
  final bool isCollapsed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSize.radius8);

    return Tooltip(
      message: isCollapsed ? item.title : '',
      preferBelow: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSize.space4),
        child: Material(
          color: AppColors.backGroundTransparent,
          child: InkWell(
            onTap: () => c.changeScreen(item.screenIndex),
            borderRadius: radius,
            hoverColor: context.hoverBg,
            splashColor: context.borderClr.withValues(alpha: 0.35),
            child: Ink(
              height: 44,
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? AppSize.space8 : AppSize.space12,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.freshGreen.withValues(alpha: 0.15)
                    : null,
                borderRadius: radius,
                border: isSelected
                    ? Border.all(
                        color:
                            AppColors.borderEmeraldGreen.withValues(alpha: 0.3),
                        width: AppSize.borderWidth1,
                      )
                    : null,
              ),
              child: Row(
                mainAxisAlignment: isCollapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Icon(
                    item.icon,
                    size: AppSize.icon20,
                    color: isSelected
                        ? AppColors.iconEmeraldGreen
                        : context.txtSecondary,
                  ),
                  if (!isCollapsed) ...[
                    const SizedBox(width: AppSize.space8),
                    Expanded(
                      child: AppText(
                        text: item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        fontSize: AppSize.font12,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.textEmeraldGreen
                            : context.txtPrimary,
                      ),
                    ),
                    if (isSelected)
                      const AppContainer(
                        width: AppSize.space4,
                        height: AppSize.space4,
                        shape: BoxShape.circle,
                        backgroundColor: AppColors.emeraldGreen,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── LOGOUT BUTTON ────────────────────────────────────────────────────────────
class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, required this.isCollapsed});
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isCollapsed ? 'Log Out' : '',
      child: GestureDetector(
        onTap: () async {
          if (kDebugMode) debugPrint('Log Out tapped');
          Get.offAllNamed(AppRoutes.login);
        },
        child: AppContainer(
          height: 48,
          margin: EdgeInsets.symmetric(
            horizontal: isCollapsed ? AppSize.space8 : AppSize.space8,
            vertical: AppSize.space8,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? AppSize.space8 : AppSize.space12,
          ),
          backgroundColor: AppColors.badgeErrorBg,
          borderRadius: BorderRadius.circular(AppSize.radius8),
          child: Row(
            mainAxisAlignment: isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              const Icon(Icons.logout_rounded,
                  size: AppSize.icon20, color: AppColors.iconError),
              if (!isCollapsed) ...[
                const SizedBox(width: AppSize.space8),
                const AppText(
                  text: 'Log Out',
                  fontSize: AppSize.font12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textError,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── PLACEHOLDER SCREEN ───────────────────────────────────────────────────────
class PlaceholderScr extends StatelessWidget {
  final String title;
  const PlaceholderScr({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      backgroundColor: context.appBg,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction_outlined,
                size: AppSize.icon40, color: context.txtSecondary),
            const SizedBox(height: AppSize.space12),
            AppText(
                text: title,
                fontSize: AppSize.font20,
                fontWeight: FontWeight.w700,
                color: context.txtPrimary),
            const SizedBox(height: AppSize.space8),
            AppText(
                text: 'This screen is under construction',
                fontSize: AppSize.font12,
                color: context.txtSecondary),
          ],
        ),
      ),
    );
  }
}
