// lib/features/seller/products/widgets/my_products_components.dart

import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/shared/widgets/seller/screen_filter_chip.dart';
import 'package:agri_market/shared/widgets/seller/grade_pill.dart';
import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_text.dart';
import '../../../../shared/widgets/common/app_url_or_asset_image.dart';

typedef MpFilterChip = ScreenFilterChip;

// ── TableEditBtn ───────────────────────────────────────────────────────────
class TableEditBtn extends StatelessWidget {
  final VoidCallback onTap;
  const TableEditBtn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AppContainer(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          backgroundColor: AppColors.badgeSuccessBg,
          borderRadius: BorderRadius.circular(AppSize.radius8),
          border: Border.all(
              color: AppColors.emerald100, width: AppSize.borderWidth1),
          child: const Icon(Icons.edit_outlined,
              size: AppSize.icon12, color: AppColors.iconEmeraldGreen),
        ),
      );
}

// ── TableDeleteBtn ─────────────────────────────────────────────────────────
class TableDeleteBtn extends StatelessWidget {
  final VoidCallback onTap;
  const TableDeleteBtn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AppContainer(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          backgroundColor: AppColors.badgeErrorBg,
          borderRadius: BorderRadius.circular(AppSize.radius8),
          border: Border.all(
              color: AppColors.borderError, width: AppSize.borderWidth1),
          child: const Icon(Icons.delete_outline_rounded,
              size: AppSize.icon12, color: AppColors.iconError),
        ),
      );
}

// ── ProductImageCell ───────────────────────────────────────────────────────
class ProductImageCell extends StatelessWidget {
  final String imagePath;
  final String name;
  final String category;
  final String grade;
  final VoidCallback? onTap;

  const ProductImageCell({
    super.key,
    required this.imagePath,
    required this.name,
    required this.category,
    required this.grade,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppContainer(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(AppSize.radius8),
            border: Border.all(
                color: context.borderClr.withValues(alpha: 0.65),
                width: AppSize.borderWidth1),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.radius8 - 1),
              child: AppUrlOrAssetImage(
                path: imagePath,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: AppSize.space8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  text: name,
                  fontSize: AppSize.font12,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                  color: context.txtPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSize.space2),
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                          text: category,
                          fontSize: AppSize.font10,
                          height: 1.2,
                          color: context.txtSecondary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: AppSize.space4),
                    GradePill(grade: grade),
                  ],
                ),
              ],
            ),
          ),
        ],
      ));
}

// ── TimerBadge ─────────────────────────────────────────────────────────────
class TimerBadge extends StatelessWidget {
  final String text;
  final bool isEnded;
  final bool isEndingSoon;

  const TimerBadge(
      {super.key,
      required this.text,
      required this.isEnded,
      required this.isEndingSoon});

  @override
  Widget build(BuildContext context) {
    final Color bg = isEnded
        ? AppColors.badgeErrorBg
        : isEndingSoon
            ? AppColors.badgeWarningBg
            : AppColors.badgeSuccessBg;
    final Color textColor = isEnded
        ? AppColors.badgeErrorText
        : isEndingSoon
            ? AppColors.badgeWarningText
            : AppColors.badgeSuccessText;

    return AppContainer(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space8, vertical: AppSize.space2),
      backgroundColor: bg,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppContainer(
              width: 5,
              height: 5,
              backgroundColor: textColor,
              shape: BoxShape.circle),
          const SizedBox(width: AppSize.space4),
          AppText(
              text: text,
              fontSize: AppSize.font8,
              fontWeight: FontWeight.w700,
              color: textColor),
        ],
      ),
    );
  }
}

// ── HarvestBadge ───────────────────────────────────────────────────────────
class HarvestBadge extends StatelessWidget {
  final String date;
  final bool isAlmostFull;

  const HarvestBadge(
      {super.key, required this.date, required this.isAlmostFull});

  @override
  Widget build(BuildContext context) {
    final Color bg =
        isAlmostFull ? AppColors.badgeWarningBg : AppColors.badgeSuccessBg;
    final Color textColor =
        isAlmostFull ? AppColors.badgeWarningText : AppColors.badgeSuccessText;

    return AppContainer(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space8, vertical: AppSize.space2),
      backgroundColor: bg,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_outlined,
              size: AppSize.font8, color: textColor),
          const SizedBox(width: AppSize.space4),
          AppText(
              text: date,
              fontSize: AppSize.font8,
              fontWeight: FontWeight.w700,
              color: textColor),
        ],
      ),
    );
  }
}
