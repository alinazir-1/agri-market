// lib/features/buyer/common/widgets/buyer_orders_dock.dart
//
// **Right-side slide panel** for buyer orders (slides in from the right edge).

import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/order_model.dart';
import 'package:agri_market/features/buyer/common/widgets/buyer_home_orders_con.dart';
import 'package:agri_market/features/seller/orders/widgets/order_components.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

class BuyerOrdersDock {
  BuyerOrdersDock._();

  static const double _edgeInsetRight = 16;
  static const double _edgeInsetTop = 12;
  static const double _edgeInsetBottom = 12;
  static const double _panelGap = 8;
  static const double _detailMinWidth = 260;

  static Future<void> open(BuildContext context) {
    final con = Get.find<BuyerHomeOrdersCon>();
    con.clearSelection();

    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: AppColors.shadowBase.withValues(alpha: 0.22),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (dialogCtx, animation, secondaryAnimation) {
        final screenW = MediaQuery.sizeOf(dialogCtx).width;
        final screenH = MediaQuery.sizeOf(dialogCtx).height;
        final panelW = min(440.0, screenW * 0.42).clamp(320.0, 520.0);
        final panelH = screenH - _edgeInsetTop - _edgeInsetBottom;

        return MediaQuery.removePadding(
          context: dialogCtx,
          removeBottom: true,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(dialogCtx).pop(),
                  child: ColoredBox(
                    color: AppColors.backGroundTransparent,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: _edgeInsetRight,
                    top: _edgeInsetTop,
                    bottom: _edgeInsetBottom,
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Material(
                      elevation: 16,
                      shadowColor:
                          AppColors.shadowBase.withValues(alpha: 0.22),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppSize.radius12),
                        bottomLeft: Radius.circular(AppSize.radius12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      color: AppColors.backGroundWhite,
                      child: SizedBox(
                        width: panelW,
                        height: panelH,
                        child: Obx(() {
                          final detail = con.selectedOrder.value;
                          if (detail == null) {
                            return _OrdersMainColumn(
                              con: con,
                              dialogCtx: dialogCtx,
                            );
                          }
                          final interior =
                              panelW - _detailMinWidth - _panelGap;
                          if (interior >= 200) {
                            return Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  width: _detailMinWidth,
                                  child: _BuyerOrderDetailPanel(
                                    order: detail,
                                    onClose: con.clearSelection,
                                  ),
                                ),
                                SizedBox(width: _panelGap),
                                Expanded(
                                  child: _OrdersMainColumn(
                                    con: con,
                                    dialogCtx: dialogCtx,
                                  ),
                                ),
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: panelH * 0.4,
                                child: _BuyerOrderDetailPanel(
                                  order: detail,
                                  onClose: con.clearSelection,
                                ),
                              ),
                              SizedBox(height: _panelGap),
                              Expanded(
                                child: _OrdersMainColumn(
                                  con: con,
                                  dialogCtx: dialogCtx,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (ctx, animation, secondary, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        );
      },
    );
  }
}

class _OrdersMainColumn extends StatelessWidget {
  const _OrdersMainColumn({
    required this.con,
    required this.dialogCtx,
  });

  final BuyerHomeOrdersCon con;
  final BuildContext dialogCtx;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppContainer(
          padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
          border: const Border(
            bottom: BorderSide(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              const AppText(
                text: 'My orders',
                fontSize: AppSize.font18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              const Spacer(),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.of(dialogCtx).pop(),
                  child: AppContainer(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(AppSize.radius8),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: AppSize.icon24,
                      color: AppColors.iconSecondary,
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.of(dialogCtx).pop(),
                  child: AppContainer(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(AppSize.radius8),
                    child: const Icon(
                      Icons.close_rounded,
                      size: AppSize.icon20,
                      color: AppColors.iconSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
          child: Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _StatChip(
                    label: 'Total',
                    value: '${con.totalCount}',
                    bg: AppColors.badgeSuccessBg,
                    fg: AppColors.badgeSuccessText,
                  ),
                  const SizedBox(width: AppSize.space8),
                  _StatChip(
                    label: 'Action',
                    value: '${con.activeAttentionCount}',
                    bg: AppColors.badgeWarningBg,
                    fg: AppColors.badgeWarningText,
                  ),
                  const SizedBox(width: AppSize.space8),
                  _StatChip(
                    label: 'In progress',
                    value: '${con.inProgressCount}',
                    bg: AppColors.badgePurpleBg,
                    fg: AppColors.badgePurpleText,
                  ),
                  const SizedBox(width: AppSize.space8),
                  _StatChip(
                    label: 'Shipped',
                    value: '${con.shippedCount}',
                    bg: AppColors.badgeInfoBg,
                    fg: AppColors.badgeInfoText,
                  ),
                  const SizedBox(width: AppSize.space8),
                  _StatChip(
                    label: 'Delivered',
                    value: '${con.deliveredCount}',
                    bg: AppColors.backgroundHover,
                    fg: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            height: 36,
            child: TextField(
              controller: con.searchController,
              onChanged: con.onSearch,
              style: const TextStyle(
                fontSize: AppSize.font12,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search order ID, product, supplier…',
                hintStyle: const TextStyle(
                  fontSize: AppSize.font10,
                  color: AppColors.textSecondary,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: AppSize.icon20,
                  color: AppColors.iconEmeraldGreen,
                ),
                filled: true,
                fillColor: AppColors.backGroundLightGrey,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: AppSize.space8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.radius20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSize.space8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  BuyerHomeOrdersCon.chipLabels.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: AppSize.space8),
                    child: _FilterChip(
                      label: BuyerHomeOrdersCon.chipLabels[i],
                      active: con.chipFilter.value == i,
                      onTap: () => con.setChip(i),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSize.space4),
        Expanded(
          child: Obx(() {
            if (con.isLoading.value) {
              return const AppSkeletonListColumn();
            }
            final list = con.filteredOrders;
            if (list.isEmpty) {
              return const AppEmptyListState(
                message: 'No orders match your filters',
                icon: Icons.receipt_long_outlined,
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              itemCount: list.length,
              itemBuilder: (_, i) => _BuyerOrderRowCard(
                order: list[i],
                selected:
                    con.selectedOrder.value?.orderId == list[i].orderId,
                onTap: () => con.selectOrder(list[i]),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.bg,
    required this.fg,
  });

  final String label;
  final String value;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space12,
        vertical: AppSize.space8,
      ),
      backgroundColor: bg,
      borderRadius: BorderRadius.circular(AppSize.radius8),
      border: Border.all(color: AppColors.borderLight),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                text: label.toUpperCase(),
                fontSize: AppSize.font8,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.4,
              ),
              AppText(
                text: value,
                fontSize: AppSize.font14,
                fontWeight: FontWeight.w800,
                color: fg,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space12,
            vertical: AppSize.space8,
          ),
          decoration: BoxDecoration(
            color: active ? AppColors.emeraldGreen : AppColors.backGroundWhite,
            borderRadius: BorderRadius.circular(AppSize.radius20),
            border: Border.all(
              color: active
                  ? AppColors.borderEmeraldGreen
                  : AppColors.borderLight,
            ),
          ),
          child: AppText(
            text: label,
            fontSize: AppSize.font10,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.textWhite : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _BuyerOrderRowCard extends StatelessWidget {
  const _BuyerOrderRowCard({
    required this.order,
    required this.selected,
    required this.onTap,
  });

  final OrderModel order;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          margin: const EdgeInsets.only(bottom: AppSize.space8),
          padding: const EdgeInsets.all(AppSize.space12),
          decoration: BoxDecoration(
            color: selected ? AppColors.badgeSuccessBg : AppColors.backGroundWhite,
            borderRadius: BorderRadius.circular(AppSize.radius8),
            border: Border.all(
              color: selected
                  ? AppColors.borderEmeraldGreen
                  : AppColors.borderLight,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.radius4),
                child: Image.asset(
                  order.productImage,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => AppContainer(
                    width: 44,
                    height: 44,
                    backgroundColor: AppColors.backgroundHover,
                    borderRadius: BorderRadius.circular(AppSize.radius4),
                    child: const Icon(
                      Icons.image_outlined,
                      size: AppSize.icon20,
                      color: AppColors.textSecondary,
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
                      text: order.orderId,
                      fontSize: AppSize.font12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: AppSize.space2),
                    AppText(
                      text: order.productName,
                      fontSize: AppSize.font12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSize.space4),
                    Row(
                      children: [
                        Icon(
                          Icons.store_outlined,
                          size: AppSize.font10,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSize.space4),
                        Expanded(
                          child: AppText(
                            text: order.buyerName,
                            fontSize: AppSize.font10,
                            color: AppColors.textSecondary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSize.space8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(
                    text:
                        '${order.currency} ${order.totalAmount.toStringAsFixed(0)}',
                    fontSize: AppSize.font12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: AppSize.space4),
                  _MiniStatus(order.orderStatus),
                  const SizedBox(height: AppSize.space4),
                  _MiniPay(order.orderPaymentStatus),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStatus extends StatelessWidget {
  const _MiniStatus(this.status);
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space8,
        vertical: AppSize.space2,
      ),
      backgroundColor: status.bgColor,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      child: AppText(
        text: status.label,
        fontSize: AppSize.font8,
        fontWeight: FontWeight.w700,
        color: status.color,
      ),
    );
  }
}

class _MiniPay extends StatelessWidget {
  const _MiniPay(this.p);
  final OrderPaymentStatus p;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space8,
        vertical: AppSize.space2,
      ),
      backgroundColor: p.bgColor,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      child: AppText(
        text: p.label,
        fontSize: AppSize.font8,
        fontWeight: FontWeight.w700,
        color: p.color,
      ),
    );
  }
}

class _BuyerOrderDetailPanel extends StatelessWidget {
  const _BuyerOrderDetailPanel({
    required this.order,
    required this.onClose,
  });

  final OrderModel order;
  final VoidCallback onClose;

  String _date(DateTime d) =>
      '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      backgroundColor: AppColors.backgroundSurface,
      border: const Border(
        right: BorderSide(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space12,
              vertical: AppSize.space8,
            ),
            border: const Border(
              bottom: BorderSide(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                const AppText(
                  text: 'Order details',
                  fontSize: AppSize.font12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                const Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onClose,
                    child: const Icon(
                      Icons.close_rounded,
                      size: AppSize.icon16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSize.space12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: order.orderId,
                    fontSize: AppSize.font14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: AppSize.space8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.radius8),
                        child: Image.asset(
                          order.productImage,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => AppContainer(
                            width: 56,
                            height: 56,
                            backgroundColor: AppColors.backgroundHover,
                            borderRadius:
                                BorderRadius.circular(AppSize.radius8),
                            child: const Icon(
                              Icons.image_outlined,
                              size: AppSize.icon24,
                              color: AppColors.textSecondary,
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
                              text: order.productName,
                              fontSize: AppSize.font12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            const SizedBox(height: AppSize.space4),
                            AppContainer(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.space8,
                                vertical: AppSize.space2,
                              ),
                              backgroundColor:
                                  order.productType.bgColor,
                              borderRadius:
                                  BorderRadius.circular(AppSize.radius20),
                              child: AppText(
                                text: order.productType.shortLabel,
                                fontSize: AppSize.font8,
                                fontWeight: FontWeight.w700,
                                color: order.productType.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.space16),
                  _detailLine('Supplier', order.buyerName),
                  _detailLine('Location', order.buyerLocation),
                  _detailLine('Quantity',
                      '${order.quantity.toStringAsFixed(0)} ${order.unit}'),
                  _detailLine('Total',
                      '${order.currency} ${order.totalAmount.toStringAsFixed(0)}'),
                  _detailLine('Ordered', _date(order.orderDate)),
                  if (order.estimatedDeliveryDate != null)
                    _detailLine(
                      'Est. delivery',
                      _date(order.estimatedDeliveryDate!),
                    ),
                  _detailLine('Delivery', order.deliveryOption),
                  _detailLine('Address', order.deliveryAddress),
                  const SizedBox(height: AppSize.space12),
                  Row(
                    children: [
                      _MiniStatus(order.orderStatus),
                      const SizedBox(width: AppSize.space8),
                      _MiniPay(order.orderPaymentStatus),
                    ],
                  ),
                  const SizedBox(height: AppSize.space16),
                  AppContainer(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: AppSize.space8),
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(AppSize.radius8),
                    backgroundColor: AppColors.emeraldGreen,
                    child: const AppText(
                      text: 'Track shipment',
                      fontSize: AppSize.font12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailLine(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSize.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: k.toUpperCase(),
            fontSize: AppSize.font8,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.4,
          ),
          AppText(
            text: v,
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
