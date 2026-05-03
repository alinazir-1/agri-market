import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/utils/product_image_storage.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/data/models/stock_batch_model.dart';
import 'package:agri_market/data/models/product_type_enums.dart';
import 'package:agri_market/features/seller/inventory/inventory_con.dart';
import 'package:agri_market/shared/widgets/seller/screen_filter_chip.dart';
import 'package:agri_market/shared/widgets/seller/screen_stat_card.dart';

import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_elevated_button.dart';
import '../../../../shared/widgets/common/app_outlined_button.dart';
import '../../../../shared/widgets/common/app_text.dart';
import '../../../../shared/widgets/common/app_text_field.dart';

// ── Aliases for Shared Widgets ──
typedef InvFilterChip = ScreenFilterChip;
typedef InvStatCard = ScreenStatCard;

// ── 1. InvActivityItem ────────────────────────────────────────────────────────
class InvActivityItem extends StatelessWidget {
  final ActivityEntry entry;
  const InvActivityItem({super.key, required this.entry});

  Color get _dotColor {
    switch (entry.type) {
      case ActivityType.restock:
        return AppColors.emeraldGreen;
      case ActivityType.outOfStock:
        return AppColors.borderError;
      case ActivityType.lowStock:
        return AppColors.textWarning;
      case ActivityType.booking:
        return AppColors.textInfo;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(vertical: AppSize.space8),
      border: const Border(
          bottom: BorderSide(
              color: AppColors.backgroundDivider,
              width: AppSize.borderWidth05)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppContainer(
            margin: const EdgeInsets.only(top: 3),
            width: AppSize.font8,
            height: AppSize.font8,
            backgroundColor: _dotColor,
            shape: BoxShape.circle,
          ),
          const SizedBox(width: AppSize.space8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                    text: entry.message,
                    fontSize: AppSize.font10,
                    color: AppColors.textPrimary,
                    height: 1.4),
                const SizedBox(height: AppSize.space2),
                AppText(
                    text: entry.timeAgo,
                    fontSize: AppSize.font10,
                    color: AppColors.textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── 2. InvAlertCard ───────────────────────────────────────────────────────────
class InvAlertCard extends StatelessWidget {
  final String name, detail, stockText;
  final bool isOut;

  const InvAlertCard(
      {super.key,
      required this.name,
      required this.detail,
      required this.stockText,
      required this.isOut});

  @override
  Widget build(BuildContext context) {
    final Color border = isOut ? AppColors.borderError : AppColors.textWarning;
    final Color bg = isOut ? AppColors.badgeErrorBg : AppColors.badgeWarningBg;
    final Color textClr =
        isOut ? AppColors.badgeErrorText : AppColors.textWarning;

    return AppContainer(
      margin: const EdgeInsets.only(bottom: AppSize.space8),
      padding: const EdgeInsets.all(AppSize.space12),
      backgroundColor: bg,
      borderRadius: BorderRadius.circular(AppSize.radius12),
      border: Border.all(color: border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
              text: name,
              fontSize: AppSize.font12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary),
          const SizedBox(height: AppSize.space2),
          AppText(
              text: detail,
              fontSize: AppSize.font10,
              color: AppColors.textSecondary),
          const SizedBox(height: AppSize.space4),
          AppText(
              text: stockText,
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w700,
              color: textClr),
        ],
      ),
    );
  }
}

// ── 3. InvStockBar ────────────────────────────────────────────────────────────
class InvStockBar extends StatelessWidget {
  final int current, total;
  final String unit;
  final bool isLow, isOut;

  const InvStockBar(
      {super.key,
      required this.current,
      required this.total,
      required this.unit,
      required this.isLow,
      required this.isOut});

  Color get _barColor => isOut
      ? AppColors.borderError
      : isLow
          ? AppColors.textWarning
          : AppColors.emeraldGreen;
  Color get _textColor => isOut
      ? AppColors.textError
      : isLow
          ? AppColors.textWarning
          : AppColors.textPrimary;
  double get _progress => total == 0 ? 0 : (current / total).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
            text: '$current $unit remaining',
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w600,
            color: _textColor),
        const SizedBox(height: AppSize.space2),
        AppText(
            text:
                'Total $total · Sold ${(total - current).clamp(0, total)} · Rem $current $unit',
            fontSize: AppSize.font10,
            color: AppColors.textSecondary,
            height: 1.4),
        const SizedBox(height: AppSize.space4),
        SizedBox(
          width: 80.0, // Replaced dirty AppSize
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.radius24),
            child: LinearProgressIndicator(
                value: _progress,
                minHeight: AppSize.space4,
                backgroundColor: AppColors.borderLight,
                valueColor: AlwaysStoppedAnimation<Color>(_barColor)),
          ),
        ),
        const SizedBox(height: AppSize.space2),
        AppText(
            text: 'of $total max',
            fontSize: AppSize.font10,
            color: AppColors.textSecondary),
      ],
    );
  }
}

// ── 4. InvTypeBadge ───────────────────────────────────────────────────────────
class InvTypeBadge extends StatelessWidget {
  final ProductType type;
  const InvTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final Map<ProductType, _BadgeStyle> styles = {
      ProductType.marketplace: const _BadgeStyle(
          AppColors.badgeInfoBg, AppColors.textInfo, 'Marketplace'),
      ProductType.liveAuction: const _BadgeStyle(
          AppColors.badgeWarningBg, AppColors.textWarning, 'Live Auction'),
      ProductType.advanceBooking: const _BadgeStyle(
          AppColors.badgeSuccessBg, AppColors.textEmeraldGreen, 'Adv. Booking'),
    };
    final style = styles[type] ??
        const _BadgeStyle(
            AppColors.backgroundPage, AppColors.textSecondary, 'Unknown');

    return AppContainer(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSize.space4, vertical: 2),
      backgroundColor: style.bg,
      borderRadius: BorderRadius.circular(AppSize.radius4),
      child: AppText(
          text: style.label,
          fontSize: AppSize.font8,
          fontWeight: FontWeight.w700,
          color: style.text),
    );
  }
}

class _BadgeStyle {
  final Color bg, text;
  final String label;
  const _BadgeStyle(this.bg, this.text, this.label);
}

// ── 5. InvRestockButton ───────────────────────────────────────────────────────
class InvRestockButton extends StatelessWidget {
  final bool isOut, isLow;
  final VoidCallback onTap;

  const InvRestockButton(
      {super.key,
      required this.isOut,
      required this.isLow,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color bg = isOut
        ? AppColors.borderError
        : isLow
            ? AppColors.textWarning
            : AppColors.emeraldGreen;
    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space4, vertical: AppSize.space4),
        backgroundColor: bg,
        borderRadius: BorderRadius.circular(AppSize.radius4),
        child: const AppText(
            text: '+ Restock',
            fontSize: AppSize.font10,
            fontWeight: FontWeight.w700,
            color: AppColors.textWhite),
      ),
    );
  }
}

// ── 6. InvRestockDialog ───────────────────────────────────────────────────────
class InvRestockDialog extends StatelessWidget {
  final String productName, unit;
  final TextEditingController controller;
  final VoidCallback onConfirm;

  const InvRestockDialog(
      {super.key,
      required this.productName,
      required this.unit,
      required this.controller,
      required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.radius20)),
      child: AppContainer(
        padding: const EdgeInsets.all(AppSize.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
                text: 'Restock Product',
                fontSize: AppSize.font16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary),
            const SizedBox(height: AppSize.space4),
            AppText(
                text: productName,
                fontSize: AppSize.font14,
                color: AppColors.textSecondary),
            const SizedBox(height: AppSize.space16),
            AppTextField(
              controller: controller,
              keyboardType: TextInputType.number,
              hintText: 'Quantity to add ($unit)',
              fillColor: AppColors.backgroundHover,
              filled: true,
              suffixWidget: Padding(
                  padding: const EdgeInsets.all(AppSize.space12),
                  child: AppText(
                      text: unit,
                      fontSize: AppSize.font14,
                      color: AppColors.textSecondary)),
            ),
            const SizedBox(height: AppSize.space16),
            Row(
              children: [
                Expanded(
                    child: AppOutlinedButton(
                        onPressed: () => Get.back(),
                        text: 'Cancel',
                        fontSize: AppSize.font14,
                        textColor: AppColors.textSecondary,
                        border: const BorderSide(color: AppColors.borderLight),
                        borderRadius: AppSize.radius12,
                        height: 48.0)), // Removed dirty AppSize height
                const SizedBox(width: AppSize.space12),
                Expanded(
                    child: AppElevatedButton(
                        onPressed: () {
                          onConfirm();
                          Get.back();
                        },
                        text: 'Confirm',
                        fontSize: AppSize.font14,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.textWhite,
                        backgroundColor: AppColors.emeraldGreen,
                        borderRadius: AppSize.radius12,
                        height: 48.0)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── 7. InvSellDialog ──────────────────────────────────────────────────────────
class InvSellDialogCon extends GetxController {
  final StockBatch batch;
  final InventoryItem item;

  InvSellDialogCon({required this.batch, required this.item});

  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final selectedChannel = MovementType.saleMarketplace.obs;
  final fullBatch = false.obs;

  @override
  void onInit() {
    super.onInit();
    priceController.text =
        batch.sellingPrice > 0 ? batch.sellingPrice.toStringAsFixed(0) : '';
  }

  void toggleFullBatch(bool val) {
    fullBatch.value = val;
    if (val) {
      quantityController.text = batch.currentQty.toStringAsFixed(0);
    } else {
      quantityController.clear();
    }
  }

  Future<void> submit() async {
    final qty = double.tryParse(quantityController.text.trim());
    if (qty == null || qty <= 0) {
      Get.snackbar('Invalid Quantity', 'Please enter a valid quantity.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.badgeErrorBg);
      return;
    }
    if (qty > batch.currentQty) {
      Get.snackbar('Exceeds Stock',
          'Cannot sell more than available stock (${batch.currentQty.toStringAsFixed(0)} ${batch.unit}).',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.badgeErrorBg);
      return;
    }
    final price = double.tryParse(priceController.text.trim()) ?? 0;

    final ok = await Get.find<InventoryCon>().sellFromBatch(
      itemId: item.id,
      batchId: batch.id,
      qty: qty,
      movementType: selectedChannel.value,
      pricePerUnit: price,
    );
    if (!ok) return;

    Get.back();
    Get.snackbar('Sale Recorded',
        '${qty.toStringAsFixed(0)} ${batch.unit} sold from ${batch.batchNumber}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.badgeSuccessBg,
        colorText: AppColors.emeraldGreen);
  }

  @override
  void onClose() {
    quantityController.dispose();
    priceController.dispose();
    super.onClose();
  }
}

class InvSellDialog extends StatelessWidget {
  final StockBatch batch;
  final InventoryItem item;

  const InvSellDialog({super.key, required this.batch, required this.item});

  static const _channels = [
    (type: MovementType.saleMarketplace, label: 'Marketplace'),
    (type: MovementType.saleAuction, label: 'Live Auction'),
    (type: MovementType.saleBooking, label: 'Adv. Booking'),
  ];

  @override
  Widget build(BuildContext context) {
    final ctrlInvSellDialog =
        Get.put(InvSellDialogCon(batch: batch, item: item));
    final avail = batch.currentQty;

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.radius20)),
      backgroundColor: context.cardBg,
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: 480.0), // Replaced dirty fixed width
        child: AppContainer(
          padding: const EdgeInsets.all(AppSize.space24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                AppContainer(
                    padding: const EdgeInsets.all(AppSize.space8),
                    backgroundColor: AppColors.badgeSuccessBg,
                    borderRadius: BorderRadius.circular(AppSize.radius12),
                    child: const Icon(Icons.sell_outlined,
                        size: AppSize.icon20,
                        color: AppColors.iconEmeraldGreen)),
                const SizedBox(width: AppSize.space12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      AppText(
                          text: 'Sell Stock',
                          fontSize: AppSize.font16,
                          fontWeight: FontWeight.w800,
                          color: context.txtPrimary),
                      AppText(
                          text: batch.batchNumber,
                          fontSize: AppSize.font14,
                          color: context.txtSecondary)
                    ])),
                IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close_rounded,
                        size: AppSize.icon20, color: context.txtSecondary)),
              ]),
              const SizedBox(height: AppSize.space16),
              AppContainer(
                padding: const EdgeInsets.all(AppSize.space12),
                backgroundColor: context.cardBg2,
                borderRadius: BorderRadius.circular(AppSize.radius12),
                border: Border.all(color: context.borderClr),
                child: Row(children: [
                  Expanded(
                      child: _infoChip(context,
                          label: 'Product', value: item.name)),
                  Expanded(
                      child: _infoChip(context,
                          label: 'Available',
                          value: '${avail.toStringAsFixed(0)} ${batch.unit}',
                          valueColor: avail > 0
                              ? AppColors.textEmeraldGreen
                              : AppColors.textError)),
                  Expanded(
                      child: _infoChip(context,
                          label: 'Grade', value: batch.grade)),
                ]),
              ),
              const SizedBox(height: AppSize.space16),
              AppText(
                  text: 'Selling Channel',
                  fontSize: AppSize.font14,
                  fontWeight: FontWeight.w600,
                  color: context.txtSecondary),
              const SizedBox(height: AppSize.space8),
              Obx(() => Row(
                    children: _channels.map((ch) {
                      final active =
                          ctrlInvSellDialog.selectedChannel.value == ch.type;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: AppSize.space8),
                          child: InkWell(
                            onTap: () => ctrlInvSellDialog
                                .selectedChannel.value = ch.type,
                            borderRadius:
                                BorderRadius.circular(AppSize.radius12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppSize.space12),
                              decoration: BoxDecoration(
                                  color: active
                                      ? AppColors.emeraldGreen
                                      : context.inputFill,
                                  borderRadius:
                                      BorderRadius.circular(AppSize.radius12),
                                  border: Border.all(
                                      color: active
                                          ? AppColors.emeraldGreen
                                          : context.borderClr)),
                              child: AppText(
                                  text: ch.label,
                                  textAlign: TextAlign.center,
                                  fontSize: AppSize.font12,
                                  fontWeight: FontWeight.w600,
                                  color: active
                                      ? AppColors.textWhite
                                      : context.txtSecondary),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )),
              const SizedBox(height: AppSize.space16),
              Row(children: [
                Obx(() => Switch(
                    value: ctrlInvSellDialog.fullBatch.value,
                    onChanged: ctrlInvSellDialog.toggleFullBatch,
                    activeColor: AppColors.emeraldGreen)),
                const SizedBox(width: AppSize.space8),
                AppText(
                    text: 'Sell entire batch',
                    fontSize: AppSize.font14,
                    color: context.txtPrimary),
              ]),
              const SizedBox(height: AppSize.space12),
              AppText(
                  text: 'Quantity to Sell *',
                  fontSize: AppSize.font14,
                  fontWeight: FontWeight.w600,
                  color: context.txtSecondary),
              const SizedBox(height: AppSize.space4),
              Obx(() => AppTextField(
                    controller: ctrlInvSellDialog.quantityController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    readOnly: ctrlInvSellDialog.fullBatch.value,
                    hintText: 'Max: ${avail.toStringAsFixed(0)} ${batch.unit}',
                    fillColor: ctrlInvSellDialog.fullBatch.value
                        ? context.cardBg2
                        : context.inputFill,
                    filled: true,
                    suffixWidget: Padding(
                        padding: const EdgeInsets.all(AppSize.space12),
                        child: AppText(
                            text: batch.unit,
                            fontSize: AppSize.font14,
                            color: context.txtSecondary)),
                  )),
              const SizedBox(height: AppSize.space12),
              AppText(
                  text: 'Selling Price / Unit',
                  fontSize: AppSize.font14,
                  fontWeight: FontWeight.w600,
                  color: context.txtSecondary),
              const SizedBox(height: AppSize.space4),
              AppTextField(
                controller: ctrlInvSellDialog.priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                hintText: '0.00',
                fillColor: context.inputFill,
                filled: true,
                prefixWidget: Padding(
                    padding: const EdgeInsets.all(AppSize.space12),
                    child: AppText(
                        text: '\$  ',
                        fontSize: AppSize.font14,
                        color: context.txtSecondary)),
              ),
              const SizedBox(height: AppSize.space20),
              Row(children: [
                Expanded(
                    child: AppOutlinedButton(
                        onPressed: () => Get.back(),
                        text: 'Cancel',
                        fontSize: AppSize.font14,
                        textColor: context.txtSecondary,
                        border: BorderSide(color: context.borderClr),
                        borderRadius: AppSize.radius12,
                        height: 48.0)),
                const SizedBox(width: AppSize.space12),
                Expanded(
                    child: AppElevatedButton(
                        onPressed: () async => ctrlInvSellDialog.submit(),
                        text: 'Record Sale',
                        fontSize: AppSize.font14,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.textWhite,
                        backgroundColor: AppColors.emeraldGreen,
                        borderRadius: AppSize.radius12,
                        height: 48.0)),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(BuildContext context,
      {required String label, required String value, Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
            text: label, fontSize: AppSize.font10, color: context.txtSecondary),
        AppText(
            text: value,
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w700,
            color: valueColor ?? context.txtPrimary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

// ── 8. InvBatchCard ───────────────────────────────────────────────────────────
class InvBatchCard extends StatelessWidget {
  final StockBatch batch;
  final InventoryItem item;
  final ProductType? listingType;

  const InvBatchCard(
      {super.key,
      required this.batch,
      required this.item,
      this.listingType});

  ({Color border, Color bg}) _typeAccent(ProductType? t, BuildContext context) {
    switch (t) {
      case ProductType.marketplace:
        return (
          border: AppColors.emeraldGreen,
          bg: AppColors.badgeSuccessBg.withValues(alpha: 0.55)
        );
      case ProductType.advanceBooking:
      case ProductType.booking:
        return (
          border: AppColors.textInfo,
          bg: AppColors.badgeInfoBg.withValues(alpha: 0.55)
        );
      case ProductType.liveAuction:
      case ProductType.auction:
        return (
          border: AppColors.textPurple,
          bg: AppColors.badgePurpleBg.withValues(alpha: 0.65)
        );
      case null:
        return (border: context.borderClr, bg: context.cardBg2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = batch.status;
    final statusColor = _statusColor(status);
    final statusBg = _statusBg(status);
    final statusLabel = _statusLabel(status);
    final accent = _typeAccent(listingType, context);
    final soldPortion =
        (batch.initialQty - batch.currentQty).clamp(0.0, batch.initialQty);

    return AppContainer(
      margin: const EdgeInsets.only(bottom: AppSize.space8),
      backgroundColor: Color.alphaBlend(
        accent.bg,
        context.cardBg2,
      ),
      borderRadius: BorderRadius.circular(AppSize.radius12),
      border: Border.all(color: accent.border, width: AppSize.borderWidth1),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSize.space12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.inventory_2_outlined,
                            size: AppSize.icon12,
                            color: AppColors.iconEmeraldGreen),
                        const SizedBox(width: AppSize.space4),
                        AppText(
                            text: batch.batchNumber,
                            fontSize: AppSize.font12,
                            fontWeight: FontWeight.w700,
                            color: context.txtPrimary),
                      ]),
                      const SizedBox(height: AppSize.space2),
                      AppText(
                          text: batch.sourceLabel,
                          fontSize: AppSize.font10,
                          color: context.txtSecondary),
                      const SizedBox(height: AppSize.space4),
                      AppText(
                          text:
                              'Qty ${batch.initialQty.toStringAsFixed(0)} · Sold ${soldPortion.toStringAsFixed(0)} · Rem ${batch.currentQty.toStringAsFixed(0)} ${batch.unit}',
                          fontSize: AppSize.font10,
                          fontWeight: FontWeight.w600,
                          color: context.txtPrimary,
                          height: 1.4),
                    ],
                  ),
                ),
                AppContainer(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.space8, vertical: 2),
                  backgroundColor: statusBg,
                  borderRadius: BorderRadius.circular(AppSize.radius20),
                  child: AppText(
                      text: statusLabel,
                      fontSize: AppSize.font10,
                      fontWeight: FontWeight.w700,
                      color: statusColor),
                ),
                if (batch.isNearExpiry) ...[
                  const SizedBox(width: AppSize.space8),
                  AppContainer(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.space8, vertical: 2),
                    backgroundColor: AppColors.badgeWarningBg,
                    borderRadius: BorderRadius.circular(AppSize.radius20),
                    child: AppText(
                        text: '${batch.daysUntilExpiry}d left',
                        fontSize: AppSize.font10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textWarning),
                  ),
                ],
                const SizedBox(width: AppSize.space8),
                if (status == BatchStatus.active)
                  _actionBtn(context,
                      icon: Icons.sell_outlined,
                      label: 'Sell',
                      color: AppColors.iconEmeraldGreen,
                      bg: AppColors.badgeSuccessBg,
                      onTap: () => Get.dialog(
                          InvSellDialog(batch: batch, item: item),
                          barrierDismissible: true)),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderClr),
          Padding(
            padding: const EdgeInsets.all(AppSize.space12),
            child: Column(
              children: [
                Row(children: [
                  _infoCell(context,
                      icon: Icons.straighten_rounded,
                      label: 'Stock',
                      value:
                          '${batch.currentQty.toStringAsFixed(0)} / ${batch.initialQty.toStringAsFixed(0)} ${batch.unit}'),
                  _infoCell(context,
                      icon: Icons.grade_outlined,
                      label: 'Grade',
                      value: batch.grade),
                  _infoCell(context,
                      icon: Icons.attach_money_rounded,
                      label: 'Cost / Unit',
                      value: batch.costPerUnit > 0
                          ? '\$${batch.costPerUnit.toStringAsFixed(0)}'
                          : '—'),
                  _infoCell(context,
                      icon: Icons.sell_rounded,
                      label: 'Sell / Unit',
                      value: batch.sellingPrice > 0
                          ? '\$${batch.sellingPrice.toStringAsFixed(0)}'
                          : '—'),
                ]),
                const SizedBox(height: AppSize.space8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSize.radius4),
                  child: LinearProgressIndicator(
                    value: batch.initialQty == 0
                        ? 0
                        : (batch.currentQty / batch.initialQty).clamp(0.0, 1.0),
                    backgroundColor: context.borderClr,
                    color: status == BatchStatus.depleted
                        ? AppColors.borderError
                        : status == BatchStatus.expired
                            ? AppColors.textWarning
                            : AppColors.emeraldGreen,
                    minHeight: AppSize.space4,
                  ),
                ),
                const SizedBox(height: AppSize.space12),
                Row(children: [
                  const Icon(Icons.store_outlined,
                      size: AppSize.icon12, color: AppColors.textSecondary),
                  const SizedBox(width: AppSize.space4),
                  Expanded(
                      child: AppText(
                          text:
                              '${batch.supplierName}${batch.supplierLocation.isNotEmpty ? ' · ${batch.supplierLocation}' : ''}',
                          fontSize: AppSize.font10,
                          color: context.txtSecondary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis)),
                  if (batch.supplierContact.isNotEmpty) ...[
                    const Icon(Icons.phone_outlined,
                        size: AppSize.icon12, color: AppColors.textSecondary),
                    const SizedBox(width: AppSize.space2),
                    AppText(
                        text: batch.supplierContact,
                        fontSize: AppSize.font10,
                        color: context.txtSecondary),
                  ],
                ]),
                const SizedBox(height: AppSize.space8),
                Row(children: [
                  if (batch.productionDate != null) ...[
                    const Icon(Icons.agriculture_outlined,
                        size: AppSize.icon12, color: AppColors.textSecondary),
                    const SizedBox(width: AppSize.space4),
                    AppText(
                        text:
                            'Prod: ${DateFormat('dd MMM yyyy').format(batch.productionDate!)}',
                        fontSize: AppSize.font10,
                        color: context.txtSecondary),
                    const SizedBox(width: AppSize.space12),
                  ],
                  if (batch.expiryDate != null) ...[
                    Icon(Icons.timer_outlined,
                        size: AppSize.icon12,
                        color: batch.isNearExpiry
                            ? AppColors.textWarning
                            : context.txtSecondary),
                    const SizedBox(width: AppSize.space4),
                    AppText(
                        text:
                            'Exp: ${DateFormat('dd MMM yyyy').format(batch.expiryDate!)}',
                        fontSize: AppSize.font10,
                        color: batch.isNearExpiry
                            ? AppColors.textWarning
                            : context.txtSecondary,
                        fontWeight: batch.isNearExpiry
                            ? FontWeight.w600
                            : FontWeight.normal),
                    const SizedBox(width: AppSize.space12),
                  ],
                  const Icon(Icons.calendar_today_outlined,
                      size: AppSize.icon12, color: AppColors.textSecondary),
                  const SizedBox(width: AppSize.space4),
                  AppText(
                      text:
                          'Added: ${DateFormat('dd MMM yyyy').format(batch.addedDate)}',
                      fontSize: AppSize.font10,
                      color: context.txtSecondary),
                ]),
                if (batch.qualityParams.isNotEmpty) ...[
                  const SizedBox(height: AppSize.space8),
                  Wrap(
                    spacing: AppSize.space8,
                    runSpacing: AppSize.space4,
                    children: batch.qualityParams.entries.map((e) {
                      return AppContainer(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.space8, vertical: 2),
                          backgroundColor: context.inputFill,
                          borderRadius: BorderRadius.circular(AppSize.radius4),
                          border: Border.all(color: context.borderClr),
                          child: AppText(
                              text: '${e.key}: ${e.value}',
                              fontSize: AppSize.font10,
                              color: context.txtSecondary));
                    }).toList(),
                  ),
                ],
                if (batch.storageCondition.isNotEmpty ||
                    batch.certifications.isNotEmpty) ...[
                  const SizedBox(height: AppSize.space8),
                  Row(children: [
                    if (batch.storageCondition.isNotEmpty) ...[
                      const Icon(Icons.warehouse_outlined,
                          size: AppSize.icon12, color: AppColors.textSecondary),
                      const SizedBox(width: AppSize.space4),
                      AppText(
                          text: batch.storageCondition,
                          fontSize: AppSize.font10,
                          color: context.txtSecondary),
                      if (batch.storageLocation.isNotEmpty) ...[
                        const SizedBox(width: AppSize.space4),
                        AppText(
                            text: '· ${batch.storageLocation}',
                            fontSize: AppSize.font10,
                            color: context.txtSecondary),
                      ],
                    ],
                    const Spacer(),
                    ...batch.certifications.take(3).map((cert) {
                      final bytes =
                          ProductImageStorage.decodeHiveStringToBytes(cert);
                      if (bytes != null) {
                        return AppContainer(
                          margin: const EdgeInsets.only(left: AppSize.space4),
                          width: 28,
                          height: 28,
                          clipBehavior: Clip.antiAlias,
                          borderRadius:
                              BorderRadius.circular(AppSize.radius8),
                          border: Border.all(color: AppColors.borderLight),
                          child: Image.memory(bytes, fit: BoxFit.cover),
                        );
                      }
                      return AppContainer(
                          margin: const EdgeInsets.only(left: AppSize.space4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.space8, vertical: 2),
                          backgroundColor: AppColors.badgeSuccessBg,
                          borderRadius: BorderRadius.circular(AppSize.radius20),
                          child: AppText(
                              text: cert,
                              fontSize: AppSize.font10,
                              color: AppColors.textEmeraldGreen,
                              fontWeight: FontWeight.w600));
                    }),
                  ]),
                ],
                if (batch.notes.isNotEmpty) ...[
                  const SizedBox(height: AppSize.space8),
                  AppContainer(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSize.space8),
                      backgroundColor: context.inputFill,
                      borderRadius: BorderRadius.circular(AppSize.radius4),
                      border: Border.all(color: context.borderClr),
                      child: AppText(
                          text: batch.notes,
                          fontSize: AppSize.font10,
                          color: context.txtSecondary)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCell(BuildContext context,
      {required IconData icon, required String label, required String value}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: AppSize.icon12, color: context.txtSecondary),
            const SizedBox(width: AppSize.space4),
            AppText(
                text: label,
                fontSize: AppSize.font10,
                color: context.txtSecondary)
          ]),
          const SizedBox(height: AppSize.space4),
          AppText(
              text: value,
              fontSize: AppSize.font12,
              fontWeight: FontWeight.w700,
              color: context.txtPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _actionBtn(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required Color bg,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.radius4),
      child: AppContainer(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space4),
          backgroundColor: bg,
          borderRadius: BorderRadius.circular(AppSize.radius4),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: AppSize.icon12, color: color),
            const SizedBox(width: AppSize.space4),
            AppText(
                text: label,
                fontSize: AppSize.font12,
                fontWeight: FontWeight.w600,
                color: color)
          ])),
    );
  }

  Color _statusColor(BatchStatus status) {
    switch (status) {
      case BatchStatus.active:
        return AppColors.textEmeraldGreen;
      case BatchStatus.depleted:
        return AppColors.textSecondary;
      case BatchStatus.expired:
        return AppColors.textError;
    }
  }

  Color _statusBg(BatchStatus status) {
    switch (status) {
      case BatchStatus.active:
        return AppColors.badgeSuccessBg;
      case BatchStatus.depleted:
        return AppColors.backgroundHover;
      case BatchStatus.expired:
        return AppColors.badgeErrorBg;
    }
  }

  String _statusLabel(BatchStatus status) {
    switch (status) {
      case BatchStatus.active:
        return 'Active';
      case BatchStatus.depleted:
        return 'Depleted';
      case BatchStatus.expired:
        return 'Expired';
    }
  }
}
