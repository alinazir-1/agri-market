// lib/features/buyer/cart/widgets/buyer_cart_widgets.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/cart/buyer_cart_con.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

final NumberFormat _pk =
    NumberFormat.currency(locale: 'en_PK', symbol: 'PKR ', decimalDigits: 0);

class BuyerCartLineCard extends StatelessWidget {
  const BuyerCartLineCard({
    super.key,
    required this.line,
    required this.onInc,
    required this.onDec,
    required this.onRemove,
  });

  final BuyerCartLine line;
  final VoidCallback onInc;
  final VoidCallback onDec;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      margin: const EdgeInsets.only(bottom: AppSize.space12),
      padding: const EdgeInsets.all(AppSize.space16),
      backgroundColor: AppColors.backGroundWhite,
      borderRadius: BorderRadius.circular(AppSize.radius8),
      border: Border.all(color: AppColors.borderLight),
      child: LayoutBuilder(
        builder: (context, c) {
          final narrow = c.maxWidth < 560;
          if (narrow) {
            return _narrowBody();
          }
          return _wideBody();
        },
      ),
    );
  }

  Widget _wideBody() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSize.radius8),
          child: Image.asset(
            line.productImage,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => AppContainer(
              width: 72,
              height: 72,
              backgroundColor: AppColors.backgroundHover,
              borderRadius: BorderRadius.circular(AppSize.radius8),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: AppColors.iconSecondary,
                size: AppSize.icon32,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSize.space16),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: line.sku,
                fontSize: AppSize.font10,
                fontWeight: FontWeight.w700,
                color: AppColors.textEmeraldGreen,
                letterSpacing: 0.3,
              ),
              const SizedBox(height: AppSize.space4),
              AppText(
                text: line.productName,
                fontSize: AppSize.font14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSize.space8),
              Row(
                children: [
                  const Icon(
                    Icons.store_outlined,
                    size: AppSize.font12,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSize.space4),
                  Expanded(
                    child: AppText(
                      text: line.supplierName,
                      fontSize: AppSize.font12,
                      color: AppColors.textSecondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.space4),
              AppText(
                text: 'Grade ${line.grade} · ${line.moqNote}',
                fontSize: AppSize.font10,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                text: '${_pk.format(line.unitPrice)} ${line.unitLabel}',
                fontSize: AppSize.font12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSize.space12),
              _QtyRow(
                qty: line.quantity,
                onInc: onInc,
                onDec: onDec,
              ),
              const SizedBox(height: AppSize.space12),
              AppText(
                text: _pk.format(line.lineTotal),
                fontSize: AppSize.font16,
                fontWeight: FontWeight.w800,
                color: AppColors.textEmeraldGreen,
              ),
              const SizedBox(height: AppSize.space8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onRemove,
                  child: AppText(
                    text: 'Remove line',
                    fontSize: AppSize.font10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.badgeErrorText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _narrowBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.radius8),
              child: Image.asset(
                line.productImage,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => AppContainer(
                  width: 56,
                  height: 56,
                  backgroundColor: AppColors.backgroundHover,
                  borderRadius: BorderRadius.circular(AppSize.radius8),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.iconSecondary,
                    size: AppSize.icon24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSize.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: line.sku,
                    fontSize: AppSize.font10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textEmeraldGreen,
                  ),
                  AppText(
                    text: line.productName,
                    fontSize: AppSize.font14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSize.space8),
        AppText(
          text: line.supplierName,
          fontSize: AppSize.font12,
          color: AppColors.textSecondary,
        ),
        AppText(
          text: line.moqNote,
          fontSize: AppSize.font10,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppSize.space12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: '${_pk.format(line.unitPrice)} ${line.unitLabel}',
              fontSize: AppSize.font12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            _QtyRow(qty: line.quantity, onInc: onInc, onDec: onDec),
          ],
        ),
        const SizedBox(height: AppSize.space8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: 'Line total',
              fontSize: AppSize.font10,
              color: AppColors.textSecondary,
            ),
            AppText(
              text: _pk.format(line.lineTotal),
              fontSize: AppSize.font16,
              fontWeight: FontWeight.w800,
              color: AppColors.textEmeraldGreen,
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onRemove,
              child: const AppText(
                text: 'Remove line',
                fontSize: AppSize.font10,
                fontWeight: FontWeight.w600,
                color: AppColors.badgeErrorText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QtyRow extends StatelessWidget {
  const _QtyRow({
    required this.qty,
    required this.onInc,
    required this.onDec,
  });

  final int qty;
  final VoidCallback onInc;
  final VoidCallback onDec;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.space4),
      borderRadius: BorderRadius.circular(AppSize.radius20),
      border: Border.all(color: AppColors.borderLight),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onDec,
              child: AppContainer(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                backgroundColor: AppColors.backGroundTransparent,
                child: const Icon(
                  Icons.remove_rounded,
                  size: AppSize.icon20,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.space12),
            child: AppText(
              text: '$qty MT',
              fontSize: AppSize.font12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onInc,
              child: AppContainer(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                backgroundColor: AppColors.backGroundTransparent,
                child: const Icon(
                  Icons.add_rounded,
                  size: AppSize.icon20,
                  color: AppColors.iconEmeraldGreen,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuyerCartSummaryPanel extends StatelessWidget {
  const BuyerCartSummaryPanel({super.key, required this.con});

  final BuyerCartCon con;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final empty = con.lines.isEmpty;
      final busy = con.checkoutBusy.value;
      return AppContainer(
        padding: const EdgeInsets.all(AppSize.space20),
        backgroundColor: AppColors.backGroundWhite,
        borderRadius: BorderRadius.circular(AppSize.radius8),
        border: Border.all(color: AppColors.borderLight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppText(
              text: 'Order summary',
              fontSize: AppSize.font18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: AppSize.space4),
            const AppText(
              text:
                  'Prices shown are indicative for procurement lots. Final invoice may include logistics, duties, and taxes.',
              fontSize: AppSize.font10,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
            const SizedBox(height: AppSize.space16),
            _sumRow('Line items', '${con.lineCount}'),
            _sumRow('Subtotal', _pk.format(con.subtotal)),
            _sumRow('Est. logistics', _pk.format(con.estimatedLogistics)),
            const Divider(height: AppSize.space24, color: AppColors.backgroundDivider),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText(
                  text: 'Estimated total',
                  fontSize: AppSize.font14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                AppText(
                  text: _pk.format(con.grandTotal),
                  fontSize: AppSize.font18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textEmeraldGreen,
                ),
              ],
            ),
            const SizedBox(height: AppSize.space20),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: empty ? null : () => con.onRequestRevisionTap(),
                child: AppContainer(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: AppSize.space12),
                  alignment: Alignment.center,
                  borderRadius: BorderRadius.circular(AppSize.radius8),
                  border: Border.all(color: AppColors.borderGray),
                  backgroundColor: AppColors.backGroundWhite,
                  child: AppText(
                    text: 'Request quote revision',
                    fontSize: AppSize.font14,
                    fontWeight: FontWeight.w600,
                    color: empty
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSize.space12),
            MouseRegion(
              cursor:
                  empty ? SystemMouseCursors.basic : SystemMouseCursors.click,
              child: GestureDetector(
                onTap: empty ? null : () => con.onCheckoutTap(),
                child: AppContainer(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSize.space12),
                  alignment: Alignment.center,
                  borderRadius: BorderRadius.circular(AppSize.radius8),
                  backgroundColor: empty
                      ? AppColors.backgroundHover
                      : AppColors.emeraldGreen,
                  child: busy
                      ? const AppInlineProgress()
                      : AppText(
                          text: 'Proceed to checkout',
                          fontSize: AppSize.font14,
                          fontWeight: FontWeight.w700,
                          color: empty
                              ? AppColors.textSecondary
                              : AppColors.textWhite,
                        ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _sumRow(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSize.space8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            text: k,
            fontSize: AppSize.font12,
            color: AppColors.textSecondary,
          ),
          AppText(
            text: v,
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}
