// lib/features/seller/orders/widgets/order_widgets.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/order_model.dart';
import 'package:agri_market/data/models/product_type_enums.dart';
import 'package:agri_market/features/seller/orders/orders_con.dart';
import 'package:agri_market/shared/widgets/seller/status_pill.dart';
import 'package:agri_market/shared/widgets/seller/grade_pill.dart';
import 'package:agri_market/shared/widgets/seller/seller_metric_stat_row.dart';
import 'package:agri_market/shared/widgets/seller/screen_filter_chip.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

// ─── EXTENSIONS ──────────────────────────────────────────────────────────────
extension OrderStatusX on OrderStatus {
  String get label => switch (this) {
        OrderStatus.pending => 'Pending',
        OrderStatus.confirmed => 'Confirmed',
        OrderStatus.processing => 'Processing',
        OrderStatus.shipped => 'Shipped',
        OrderStatus.delivered => 'Delivered',
        OrderStatus.cancelled => 'Cancelled',
      };

  Color get color => switch (this) {
        OrderStatus.pending => AppColors.badgeWarningText,
        OrderStatus.confirmed => AppColors.badgeInfoText,
        OrderStatus.processing => AppColors.badgePurpleText,
        OrderStatus.shipped => AppColors.textInfo,
        OrderStatus.delivered => AppColors.badgeSuccessText,
        OrderStatus.cancelled => AppColors.badgeErrorText,
      };

  Color get bgColor => switch (this) {
        OrderStatus.pending => AppColors.badgeWarningBg,
        OrderStatus.confirmed => AppColors.badgeInfoBg,
        OrderStatus.processing => AppColors.badgePurpleBg,
        OrderStatus.shipped => AppColors.badgeInfoBg,
        OrderStatus.delivered => AppColors.badgeSuccessBg,
        OrderStatus.cancelled => AppColors.badgeErrorBg,
      };

  IconData get icon => switch (this) {
        OrderStatus.pending => Icons.hourglass_empty_rounded,
        OrderStatus.confirmed => Icons.check_circle_outline_rounded,
        OrderStatus.processing => Icons.sync_rounded,
        OrderStatus.shipped => Icons.local_shipping_outlined,
        OrderStatus.delivered => Icons.done_all_rounded,
        OrderStatus.cancelled => Icons.cancel_outlined,
      };
}

extension PaymentStatusX on OrderPaymentStatus {
  String get label => switch (this) {
        OrderPaymentStatus.paid => 'Paid',
        OrderPaymentStatus.pending => 'Unpaid',
        OrderPaymentStatus.partial => 'Partial',
        OrderPaymentStatus.failed => 'Failed',
      };

  Color get color => switch (this) {
        OrderPaymentStatus.paid => AppColors.badgeSuccessText,
        OrderPaymentStatus.pending => AppColors.badgeWarningText,
        OrderPaymentStatus.partial => AppColors.badgeInfoText,
        OrderPaymentStatus.failed => AppColors.badgeErrorText,
      };

  Color get bgColor => switch (this) {
        OrderPaymentStatus.paid => AppColors.badgeSuccessBg,
        OrderPaymentStatus.pending => AppColors.badgeWarningBg,
        OrderPaymentStatus.partial => AppColors.badgeInfoBg,
        OrderPaymentStatus.failed => AppColors.badgeErrorBg,
      };
}

extension SampleStatusX on SampleStatus {
  String get label => switch (this) {
        SampleStatus.newRequest => 'New Request',
        SampleStatus.accepted => 'Accepted',
        SampleStatus.dispatched => 'Dispatched',
        SampleStatus.delivered => 'Delivered',
        SampleStatus.rejected => 'Rejected',
        SampleStatus.cancelled => 'Cancelled',
      };

  Color get color => switch (this) {
        SampleStatus.newRequest => AppColors.badgePurpleText,
        SampleStatus.accepted => AppColors.badgeInfoText,
        SampleStatus.dispatched => AppColors.textInfo,
        SampleStatus.delivered => AppColors.badgeSuccessText,
        SampleStatus.rejected => AppColors.badgeErrorText,
        SampleStatus.cancelled => AppColors.textSecondary,
      };

  Color get bgColor => switch (this) {
        SampleStatus.newRequest => AppColors.badgePurpleBg,
        SampleStatus.accepted => AppColors.badgeInfoBg,
        SampleStatus.dispatched => AppColors.badgeInfoBg,
        SampleStatus.delivered => AppColors.badgeSuccessBg,
        SampleStatus.rejected => AppColors.badgeErrorBg,
        SampleStatus.cancelled => AppColors.backgroundDivider,
      };
}

extension ProductTypeLabelX on ProductType {
  String get shortLabel => switch (this) {
        ProductType.marketplace => 'Marketplace',
        ProductType.liveAuction => 'Live Auction',
        ProductType.advanceBooking => 'Adv. Booking',
        ProductType.booking => 'Booking',
        ProductType.auction => 'Auction',
      };

  Color get color => switch (this) {
        ProductType.marketplace => AppColors.emeraldGreen,
        ProductType.liveAuction => AppColors.badgePurpleText,
        ProductType.advanceBooking => AppColors.badgeWarningText,
        ProductType.booking => AppColors.badgeWarningText,
        ProductType.auction => AppColors.badgePurpleText,
      };

  Color get bgColor => switch (this) {
        ProductType.marketplace => AppColors.badgeSuccessBg,
        ProductType.liveAuction => AppColors.badgePurpleBg,
        ProductType.advanceBooking => AppColors.badgeWarningBg,
        ProductType.booking => AppColors.badgeWarningBg,
        ProductType.auction => AppColors.badgePurpleBg,
      };
}

// ─── OrdStatRow ──────────────────────────────────────────────────────────────
class OrdStatRow extends StatelessWidget {
  final OrdersCon c;
  const OrdStatRow({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(
        () => SellerMetricStatRow(
          items: [
            SellerMetricStatItem(
              label: 'TOTAL ORDERS',
              value: '${c.totalOrders}',
              badge: 'All time',
              icon: Icons.receipt_long_outlined,
              iconBg: AppColors.badgeSuccessBg,
              iconColor: AppColors.badgeSuccessText,
            ),
            SellerMetricStatItem(
              label: 'PENDING',
              value: '${c.pendingOrders}',
              badge: 'Needs action',
              icon: Icons.hourglass_empty_rounded,
              iconBg: AppColors.badgeWarningBg,
              iconColor: AppColors.badgeWarningText,
            ),
            SellerMetricStatItem(
              label: 'PROCESSING',
              value: '${c.processingOrders}',
              badge: 'In progress',
              icon: Icons.sync_rounded,
              iconBg: AppColors.badgePurpleBg,
              iconColor: AppColors.badgePurpleText,
            ),
            SellerMetricStatItem(
              label: 'REVENUE',
              value: '\$${c.monthRevenue.toStringAsFixed(0)}',
              badge: 'Paid orders',
              icon: Icons.payments_outlined,
              iconBg: AppColors.badgeInfoBg,
              iconColor: AppColors.badgeInfoText,
              valueColor: AppColors.badgeInfoText,
            ),
          ],
        ),
      );
}

// ─── OrdMainTabs ─────────────────────────────────────────────────────────────
class OrdMainTabs extends StatelessWidget {
  final OrdersCon c;
  const OrdMainTabs({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(
        () => AppContainer(
          backgroundColor: AppColors.backGroundWhite,
          border: const Border(
            bottom: BorderSide(color: AppColors.borderLight),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSize.space20),
          child: Row(
            children: [
              _tab(0, 'Orders', Icons.receipt_long_outlined, c.totalOrders),
              _tab(1, 'Sample Requests', Icons.science_outlined,
                  c.sampleRequests.length),
            ],
          ),
        ),
      );

  Widget _tab(int idx, String label, IconData icon, int count) {
    final active = c.mainTabIndex.value == idx;
    return GestureDetector(
      onTap: () => c.setMainTab(idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space4,
          vertical: AppSize.space12,
        ),
        margin: const EdgeInsets.only(right: AppSize.space24),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active
                  ? AppColors.borderEmeraldGreen
                  : AppColors.backGroundTransparent,
              width: AppSize.borderWidth2,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppSize.icon12,
              color:
                  active ? AppColors.iconEmeraldGreen : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSize.space4),
            AppText(
              text: label,
              fontSize: AppSize.font12,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color:
                  active ? AppColors.textEmeraldGreen : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSize.space4),
            AppContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space4,
                vertical: AppSize.space2,
              ),
              backgroundColor:
                  active ? AppColors.emeraldGreen : AppColors.backgroundHover,
              borderRadius: BorderRadius.circular(AppSize.radiusCircular),
              child: AppText(
                text: '$count',
                fontSize: AppSize.font8,
                fontWeight: FontWeight.w700,
                color: active ? AppColors.textWhite : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── OrdStatusTabs ───────────────────────────────────────────────────────────
/// Order status filters — same pill style as My Products (`ScreenFilterChip`).
class OrdStatusTabs extends StatelessWidget {
  final OrdersCon c;
  const OrdStatusTabs({super.key, required this.c});

  static const _statuses = <OrderStatus?>[
    null,
    OrderStatus.pending,
    OrderStatus.confirmed,
    OrderStatus.processing,
    OrderStatus.shipped,
    OrderStatus.delivered,
    OrderStatus.cancelled,
  ];

  @override
  Widget build(BuildContext context) => Obx(
        () => AppContainer(
          backgroundColor: context.cardBg2,
          border: Border(bottom: BorderSide(color: context.borderClr)),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space20,
            vertical: AppSize.space8,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(
                text: 'Status:',
                fontSize: AppSize.font12,
                fontWeight: FontWeight.w700,
                color: context.txtPrimary,
              ),
              const SizedBox(width: AppSize.space8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_statuses.length, (i) {
                      final status = _statuses[i];
                      final count = status == null
                          ? c.totalOrders
                          : c.countByStatus(status);
                      final name = status == null ? 'All' : status.label;
                      final label = '$name ($count)';
                      final active = c.selectedTab.value == i;

                      return Padding(
                        padding: EdgeInsets.only(
                          right: i < _statuses.length - 1
                              ? AppSize.space4
                              : 0,
                        ),
                        child: status == null
                            ? ScreenFilterChip(
                                label: label,
                                isActive: active,
                                onTap: () => c.selectTab(i),
                              )
                            : ScreenFilterChip(
                                label: label,
                                isActive: active,
                                onTap: () => c.selectTab(i),
                                activeColor: status.color,
                                activeBorder: status.color,
                              ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

// ─── OrdFilterBar ────────────────────────────────────────────────────────────
class OrdFilterBar extends StatelessWidget {
  final OrdersCon c;
  const OrdFilterBar({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(
        () => AppContainer(
          backgroundColor: AppColors.backGroundWhite,
          border: const Border(
            bottom: BorderSide(color: AppColors.borderLight),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space20,
            vertical: AppSize.space8,
          ),
          child: Row(
            children: [
              _dropdown(
                value: c.selectedTypeFilter.value,
                items: [
                  'All Types',
                  'Marketplace',
                  'Live Auction',
                  'Advance Booking',
                ],
                onChanged: c.selectTypeFilter,
                icon: Icons.filter_list_rounded,
              ),
              const SizedBox(width: AppSize.space12),
              _dropdown(
                value: c.sortBy.value,
                items: ['Latest', 'Oldest', 'Amount High'],
                onChanged: c.selectSort,
                icon: Icons.sort_rounded,
              ),
              const Spacer(),
              AppContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space12,
                  vertical: AppSize.space4,
                ),
                backgroundColor: AppColors.backgroundHover,
                borderRadius: BorderRadius.circular(AppSize.radius20),
                child: AppText(
                  text:
                      'Showing ${c.filteredOrders.length} order${c.filteredOrders.length == 1 ? '' : 's'}',
                  fontSize: AppSize.font10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _dropdown({
    required String value,
    required List<String> items,
    required void Function(String) onChanged,
    required IconData icon,
  }) =>
      AppContainer(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: AppSize.space8),
        backgroundColor: AppColors.backGroundWhite,
        borderRadius: BorderRadius.circular(AppSize.radius20),
        border: Border.all(color: AppColors.borderLight),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSize.icon12, color: AppColors.textSecondary),
            const SizedBox(width: AppSize.space4),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isDense: true,
                style: const TextStyle(
                  fontSize: AppSize.font10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: AppSize.icon16,
                  color: AppColors.textSecondary,
                ),
                items: items
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) onChanged(v);
                },
              ),
            ),
          ],
        ),
      );
}

// ─── OrdList ─────────────────────────────────────────────────────────────────
class OrdList extends StatelessWidget {
  final OrdersCon c;
  const OrdList({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(() {
        if (c.isLoading.value) {
          return const AppSkeletonListColumn();
        }
        final list = c.filteredOrders;
        if (list.isEmpty) {
          return const AppEmptyListState(
            message: 'No orders found',
            icon: Icons.receipt_long_outlined,
          );
        }
        return Column(
          children: [
            _header(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppSize.space20,
                  AppSize.space8,
                  AppSize.space20,
                  AppSize.space20,
                ),
                itemCount: list.length,
                itemBuilder: (_, i) => _OrderCard(
                  order: list[i],
                  c: c,
                  isSelected: c.selectedOrder.value?.orderId == list[i].orderId,
                ),
              ),
            ),
          ],
        );
      });

  Widget _header() => AppContainer(
        backgroundColor: AppColors.backgroundHover,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space20,
          vertical: AppSize.space8,
        ),
        child: const Row(
          children: [
            Expanded(flex: 3, child: _H('ORDER')),
            Expanded(flex: 4, child: _H('PRODUCT')),
            Expanded(flex: 3, child: _H('BUYER')),
            SizedBox(width: 90, child: _H('AMOUNT')),
            SizedBox(width: 90, child: _H('STATUS')),
            SizedBox(width: 52, child: _H('ACTION')),
          ],
        ),
      );
}

class _H extends StatelessWidget {
  final String text;
  const _H(this.text);

  @override
  Widget build(BuildContext context) => AppText(
        text: text,
        fontSize: AppSize.font8,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      );
}

// ─── _OrderCard ──────────────────────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final OrdersCon c;
  final bool isSelected;

  const _OrderCard({
    required this.order,
    required this.c,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => c.selectOrder(order),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: AppSize.space8),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space12,
            vertical: AppSize.space12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.badgeSuccessBg
                : AppColors.backGroundWhite,
            borderRadius: BorderRadius.circular(AppSize.radius8),
            border: Border.all(
              color: isSelected
                  ? AppColors.borderEmeraldGreen
                  : AppColors.borderLight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
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
                    _TypeBadge(order.productType),
                    const SizedBox(height: AppSize.space2),
                    AppText(
                      text: _formatDate(order.orderDate),
                      fontSize: AppSize.font8,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.radius4),
                      child: Image.asset(
                        order.productImage,
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => AppContainer(
                          width: 36,
                          height: 36,
                          backgroundColor: AppColors.backgroundHover,
                          borderRadius: BorderRadius.circular(AppSize.radius4),
                          child: const Icon(
                            Icons.image_outlined,
                            size: AppSize.icon16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSize.space8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: order.productName,
                            fontSize: AppSize.font12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSize.space2),
                          _GradeBadge(order.productGrade),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    AppContainer(
                      width: 28,
                      height: 28,
                      shape: BoxShape.circle,
                      backgroundColor: AppColors.emeraldGreen,
                      child: Center(
                        child: AppText(
                          text: order.buyerName.isNotEmpty
                              ? order.buyerName[0].toUpperCase()
                              : '?',
                          fontSize: AppSize.font8,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSize.space4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: order.buyerName,
                            fontSize: AppSize.font12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSize.space2),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: AppSize.font8,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: AppSize.space2),
                              Expanded(
                                child: AppText(
                                  text: order.buyerLocation,
                                  fontSize: AppSize.font8,
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
                  ],
                ),
              ),
              SizedBox(
                width: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: '\$${order.totalAmount.toStringAsFixed(0)}',
                      fontSize: AppSize.font12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: AppSize.space2),
                    AppText(
                      text:
                          '${order.quantity.toStringAsFixed(0)} ${order.unit}',
                      fontSize: AppSize.font8,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatusBadge(order.orderStatus),
                    const SizedBox(height: AppSize.space4),
                    _PayBadge(order.orderPaymentStatus),
                  ],
                ),
              ),
              SizedBox(
                width: 52,
                child: Center(
                  child: Tooltip(
                    message: 'View Details',
                    child: GestureDetector(
                      onTap: () => c.selectOrder(order),
                      child: AppContainer(
                        width: 30,
                        height: 30,
                        backgroundColor: isSelected
                            ? AppColors.emeraldGreen
                            : AppColors.backgroundHover,
                        borderRadius: BorderRadius.circular(AppSize.radius4),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: AppSize.icon16,
                          color: isSelected
                              ? AppColors.iconWhite
                              : AppColors.iconEmeraldGreen,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  String _formatDate(DateTime d) => '${d.day} ${_monthName(d.month)} ${d.year}';

  String _monthName(int m) => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][m - 1];
}

// ─── OrdDetailPanel ──────────────────────────────────────────────────────────
class OrdDetailPanel extends StatelessWidget {
  final OrdersCon c;
  const OrdDetailPanel({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(() {
        final o = c.selectedOrder.value;
        if (o == null) return const SizedBox.shrink();

        return AppContainer(
          width: 270,
          backgroundColor: AppColors.backGroundWhite,
          border: const Border(left: BorderSide(color: AppColors.borderLight)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSize.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const AppText(
                      text: 'Order Details',
                      fontSize: AppSize.font12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => c.selectedOrder.value = null,
                      child: const Icon(
                        Icons.close_rounded,
                        size: AppSize.icon16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSize.space12),
                AppContainer(
                  padding: const EdgeInsets.all(AppSize.space12),
                  backgroundColor: AppColors.backgroundHover,
                  borderRadius: BorderRadius.circular(AppSize.radius8),
                  border: Border.all(color: AppColors.borderLight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.tag_rounded,
                            size: AppSize.icon12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSize.space4),
                          AppText(
                            text: o.orderId,
                            fontSize: AppSize.font12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.space4),
                      Row(
                        children: [
                          _TypeBadge(o.productType),
                          const Spacer(),
                          AppText(
                            text: _fmtDate(o.orderDate),
                            fontSize: AppSize.font8,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSize.space12),
                const _SectionTitle('PRODUCT'),
                const SizedBox(height: AppSize.space8),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.radius4),
                      child: Image.asset(
                        o.productImage,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => AppContainer(
                          width: 44,
                          height: 44,
                          backgroundColor: AppColors.backgroundHover,
                          child: const Icon(
                            Icons.image_outlined,
                            size: AppSize.icon20,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSize.space8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: o.productName,
                            fontSize: AppSize.font12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(height: AppSize.space2),
                          Row(
                            children: [
                              _GradeBadge(o.productGrade),
                              const SizedBox(width: AppSize.space4),
                              AppText(
                                text:
                                    '${o.quantity.toStringAsFixed(0)} ${o.unit}',
                                fontSize: AppSize.font8,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSize.space12),
                const Divider(color: AppColors.borderLight, height: 1),
                const SizedBox(height: AppSize.space12),
                const _SectionTitle('BUYER'),
                const SizedBox(height: AppSize.space8),
                Row(
                  children: [
                    AppContainer(
                      width: AppSize.icon32,
                      height: AppSize.icon32,
                      shape: BoxShape.circle,
                      backgroundColor: AppColors.emeraldGreen,
                      child: Center(
                        child: AppText(
                          text: o.buyerName.isNotEmpty
                              ? o.buyerName[0].toUpperCase()
                              : '?',
                          fontSize: AppSize.font12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSize.space8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: o.buyerName,
                            fontSize: AppSize.font12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(height: AppSize.space2),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: AppSize.icon12,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: AppSize.space2),
                              Expanded(
                                child: AppText(
                                  text: o.buyerLocation,
                                  fontSize: AppSize.font8,
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
                  ],
                ),
                const SizedBox(height: AppSize.space12),
                const Divider(color: AppColors.borderLight, height: 1),
                const SizedBox(height: AppSize.space12),
                const _SectionTitle('PAYMENT'),
                const SizedBox(height: AppSize.space8),
                _AmountRow(
                  'Qty × Price',
                  '${o.quantity.toStringAsFixed(0)} × \$${o.pricePerUnit.toStringAsFixed(0)}',
                ),
                const SizedBox(height: AppSize.space4),
                _AmountRow(
                  'Total',
                  '\$${o.totalAmount.toStringAsFixed(0)} ${o.currency}',
                  bold: true,
                ),
                const SizedBox(height: AppSize.space8),
                _PayBadge(o.orderPaymentStatus),
                const SizedBox(height: AppSize.space12),
                const Divider(color: AppColors.borderLight, height: 1),
                const SizedBox(height: AppSize.space12),
                const _SectionTitle('DELIVERY'),
                const SizedBox(height: AppSize.space8),
                _InfoRow2(Icons.local_shipping_outlined, o.deliveryOption),
                const SizedBox(height: AppSize.space4),
                _InfoRow2(Icons.location_on_outlined, o.deliveryAddress),
                if (o.estimatedDeliveryDate != null) ...[
                  const SizedBox(height: AppSize.space4),
                  _InfoRow2(
                    Icons.event_available_outlined,
                    'EDD: ${_fmtDate(o.estimatedDeliveryDate!)}',
                  ),
                ],
                const SizedBox(height: AppSize.space12),
                const Divider(color: AppColors.borderLight, height: 1),
                const SizedBox(height: AppSize.space12),
                const _SectionTitle('STATUS'),
                const SizedBox(height: AppSize.space8),
                _StatusStepper(o.orderStatus),
                const SizedBox(height: AppSize.space12),
                _StatusActions(order: o, c: c),
              ],
            ),
          ),
        );
      });

  String _fmtDate(DateTime d) => '${d.day} ${const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][d.month - 1]} ${d.year}';
}

// ─── _StatusStepper ──────────────────────────────────────────────────────────
class _StatusStepper extends StatelessWidget {
  final OrderStatus current;
  const _StatusStepper(this.current);

  static const _steps = [
    OrderStatus.pending,
    OrderStatus.confirmed,
    OrderStatus.processing,
    OrderStatus.shipped,
    OrderStatus.delivered,
  ];

  @override
  Widget build(BuildContext context) {
    if (current == OrderStatus.cancelled) {
      return AppContainer(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space12,
          vertical: AppSize.space8,
        ),
        backgroundColor: AppColors.badgeErrorBg,
        borderRadius: BorderRadius.circular(AppSize.radius8),
        child: const Row(
          children: [
            Icon(
              Icons.cancel_outlined,
              size: AppSize.icon16,
              color: AppColors.badgeErrorText,
            ),
            SizedBox(width: AppSize.space4),
            AppText(
              text: 'Order Cancelled',
              fontSize: AppSize.font12,
              fontWeight: FontWeight.w700,
              color: AppColors.badgeErrorText,
            ),
          ],
        ),
      );
    }

    final currentIdx = _steps.indexOf(current);

    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final stepIdx = i ~/ 2;
          final done = stepIdx < currentIdx;
          return Expanded(
            child: AppContainer(
              height: AppSize.borderWidth2,
              backgroundColor:
                  done ? AppColors.borderEmeraldGreen : AppColors.borderLight,
            ),
          );
        }
        final stepIdx = i ~/ 2;
        final done = stepIdx <= currentIdx;
        final active = stepIdx == currentIdx;
        final step = _steps[stepIdx];

        return Column(
          children: [
            AppContainer(
              width: 22,
              height: 22,
              shape: BoxShape.circle,
              backgroundColor:
                  done ? AppColors.emeraldGreen : AppColors.backgroundHover,
              border: Border.all(
                color: done || active
                    ? AppColors.borderEmeraldGreen
                    : AppColors.borderLight,
                width: active ? AppSize.borderWidth2 : AppSize.borderWidth1,
              ),
              child: Center(
                child: Icon(
                  done ? Icons.check_rounded : step.icon,
                  size: AppSize.icon12,
                  color: done ? AppColors.iconWhite : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppSize.space2),
            AppText(
              text: step.label.length > 5
                  ? '${step.label.substring(0, 5)}.'
                  : step.label,
              fontSize: AppSize.font8,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color:
                  active ? AppColors.textEmeraldGreen : AppColors.textSecondary,
            ),
          ],
        );
      }),
    );
  }
}

// ─── _StatusActions ──────────────────────────────────────────────────────────
class _StatusActions extends StatelessWidget {
  final OrderModel order;
  final OrdersCon c;
  const _StatusActions({required this.order, required this.c});

  @override
  Widget build(BuildContext context) {
    final btns = _getButtons();
    if (btns.isEmpty) return const SizedBox.shrink();
    return Column(
      children: btns
          .map((b) => Padding(
                padding: const EdgeInsets.only(bottom: AppSize.space8),
                child: b,
              ))
          .toList(),
    );
  }

  List<Widget> _getButtons() {
    switch (order.orderStatus) {
      case OrderStatus.pending:
        return [
          _btn(
            'Confirm Order',
            Icons.check_circle_outline_rounded,
            AppColors.badgeInfoText,
            AppColors.badgeInfoBg,
            'confirm',
            () => c.updateOrderStatus(order.orderId, OrderStatus.confirmed),
          ),
          _btn(
            'Cancel Order',
            Icons.cancel_outlined,
            AppColors.badgeErrorText,
            AppColors.badgeErrorBg,
            'cancel_pending',
            () => c.updateOrderStatus(order.orderId, OrderStatus.cancelled),
          ),
        ];
      case OrderStatus.confirmed:
        return [
          _btn(
            'Start Processing',
            Icons.sync_rounded,
            AppColors.badgePurpleText,
            AppColors.badgePurpleBg,
            'process',
            () => c.updateOrderStatus(order.orderId, OrderStatus.processing),
          ),
          _btn(
            'Cancel Order',
            Icons.cancel_outlined,
            AppColors.badgeErrorText,
            AppColors.badgeErrorBg,
            'cancel_confirmed',
            () => c.updateOrderStatus(order.orderId, OrderStatus.cancelled),
          ),
        ];
      case OrderStatus.processing:
        return [
          _btn(
            'Mark as Shipped',
            Icons.local_shipping_outlined,
            AppColors.textInfo,
            AppColors.badgeInfoBg,
            'ship',
            () => c.updateOrderStatus(order.orderId, OrderStatus.shipped),
          ),
        ];
      case OrderStatus.shipped:
        return [
          _btn(
            'Mark as Delivered',
            Icons.done_all_rounded,
            AppColors.badgeSuccessText,
            AppColors.badgeSuccessBg,
            'deliver',
            () => c.updateOrderStatus(order.orderId, OrderStatus.delivered),
          ),
        ];
      default:
        return [];
    }
  }

  Widget _btn(
    String label,
    IconData icon,
    Color color,
    Color bg,
    String actionSlug,
    VoidCallback syncOp,
  ) =>
      Obx(() {
        final loading =
            c.isOrderPanelActionLoading(order.orderId, actionSlug);
        return GestureDetector(
          onTap: loading
              ? null
              : () => c.runOrderPanelAction(
                    order.orderId,
                    actionSlug,
                    syncOp,
                  ),
          child: AppContainer(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space12,
              vertical: AppSize.space8,
            ),
            backgroundColor: bg,
            borderRadius: BorderRadius.circular(AppSize.radius8),
            child: loading
                ? const Center(child: AppInlineProgress())
                : Row(
                    children: [
                      Icon(icon, size: AppSize.icon12, color: color),
                      const SizedBox(width: AppSize.space8),
                      AppText(
                        text: label,
                        fontSize: AppSize.font12,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ],
                  ),
          ),
        );
      });
}

// ─── OrdSamplesList ──────────────────────────────────────────────────────────
class OrdSamplesList extends StatelessWidget {
  final OrdersCon c;
  const OrdSamplesList({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(() {
        if (c.isLoading.value) {
          return const AppSkeletonListColumn();
        }
        final list = c.sampleRequests;
        if (list.isEmpty) {
          return const AppEmptyListState(
            message: 'No sample requests',
            icon: Icons.science_outlined,
          );
        }

        return Column(
          children: [
            _header(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppSize.space20,
                  AppSize.space8,
                  AppSize.space20,
                  AppSize.space20,
                ),
                itemCount: list.length,
                itemBuilder: (_, i) => _SampleCard(sample: list[i], c: c),
              ),
            ),
          ],
        );
      });

  Widget _header() => AppContainer(
        backgroundColor: AppColors.backgroundHover,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space20,
          vertical: AppSize.space8,
        ),
        child: const Row(
          children: [
            Expanded(flex: 3, child: _H('SAMPLE ID')),
            Expanded(flex: 4, child: _H('PRODUCT')),
            Expanded(flex: 3, child: _H('BUYER')),
            SizedBox(width: 80, child: _H('QTY & DELIVERY')),
            SizedBox(width: 70, child: _H('PRICE')),
            SizedBox(width: 90, child: _H('STATUS')),
            SizedBox(width: 100, child: _H('ACTIONS')),
          ],
        ),
      );
}

class _SampleCard extends StatelessWidget {
  final SampleRequestModel sample;
  final OrdersCon c;
  const _SampleCard({required this.sample, required this.c});

  @override
  Widget build(BuildContext context) => AppContainer(
        margin: const EdgeInsets.only(bottom: AppSize.space8),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space12,
          vertical: AppSize.space12,
        ),
        backgroundColor: AppColors.backGroundWhite,
        borderRadius: BorderRadius.circular(AppSize.radius8),
        border: Border.all(color: AppColors.borderLight),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: sample.sampleId,
                    fontSize: AppSize.font12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: AppSize.space2),
                  AppText(
                    text: _fmtDate(sample.requestDate),
                    fontSize: AppSize.font8,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.radius4),
                    child: Image.asset(
                      sample.productImage,
                      width: AppSize.icon32,
                      height: AppSize.icon32,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => AppContainer(
                        width: AppSize.icon32,
                        height: AppSize.icon32,
                        backgroundColor: AppColors.backgroundHover,
                        child: const Icon(
                          Icons.image_outlined,
                          size: AppSize.icon16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSize.space8),
                  Expanded(
                    child: AppText(
                      text: sample.productName,
                      fontSize: AppSize.font12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: sample.buyerName,
                    fontSize: AppSize.font12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSize.space2),
                  AppText(
                    text: sample.buyerLocation,
                    fontSize: AppSize.font8,
                    color: AppColors.textSecondary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text:
                        '${sample.sampleQty.toStringAsFixed(0)} ${sample.sampleUnit}',
                    fontSize: AppSize.font12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: AppSize.space2),
                  Row(
                    children: [
                      Icon(
                        sample.isDeliveryBySeller
                            ? Icons.local_shipping_outlined
                            : Icons.store_outlined,
                        size: AppSize.font8,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSize.space2),
                      AppText(
                        text:
                            sample.isDeliveryBySeller ? 'Delivered' : 'Pickup',
                        fontSize: AppSize.font8,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 70,
              child: AppText(
                text: sample.samplePrice == 0
                    ? 'FREE'
                    : '\$${sample.samplePrice.toStringAsFixed(2)}',
                fontSize: AppSize.font12,
                fontWeight: FontWeight.w800,
                color: sample.samplePrice == 0
                    ? AppColors.badgeSuccessText
                    : AppColors.textPrimary,
              ),
            ),
            SizedBox(
              width: 90,
              child: _SampleBadge(sample.status),
            ),
            SizedBox(
              width: 100,
              child: _SampleActions(sample: sample, c: c),
            ),
          ],
        ),
      );

  String _fmtDate(DateTime d) => '${d.day} ${const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][d.month - 1]}';
}

class _SampleActions extends StatelessWidget {
  final SampleRequestModel sample;
  final OrdersCon c;
  const _SampleActions({required this.sample, required this.c});

  @override
  Widget build(BuildContext context) {
    switch (sample.status) {
      case SampleStatus.newRequest:
        return Row(
          children: [
            _btn(
              Icons.check_rounded,
              AppColors.badgeSuccessText,
              AppColors.badgeSuccessBg,
              'Accept',
              'accept',
              () =>
                  c.updateSampleStatus(sample.sampleId, SampleStatus.accepted),
            ),
            const SizedBox(width: AppSize.space4),
            _btn(
              Icons.close_rounded,
              AppColors.badgeErrorText,
              AppColors.badgeErrorBg,
              'Reject',
              'reject',
              () =>
                  c.updateSampleStatus(sample.sampleId, SampleStatus.rejected),
            ),
          ],
        );
      case SampleStatus.accepted:
        return _btn(
          Icons.local_shipping_outlined,
          AppColors.textInfo,
          AppColors.badgeInfoBg,
          'Dispatch',
          'dispatch',
          () => c.updateSampleStatus(sample.sampleId, SampleStatus.dispatched),
        );
      case SampleStatus.dispatched:
        return _btn(
          Icons.done_all_rounded,
          AppColors.badgeSuccessText,
          AppColors.badgeSuccessBg,
          'Delivered',
          'deliver',
          () => c.updateSampleStatus(sample.sampleId, SampleStatus.delivered),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _btn(
    IconData icon,
    Color color,
    Color bg,
    String label,
    String actionSlug,
    VoidCallback syncOp,
  ) =>
      Obx(() {
        final loading =
            c.isSampleActionLoading(sample.sampleId, actionSlug);
        return GestureDetector(
          onTap: loading
              ? null
              : () => c.runSampleRowAction(
                    sample.sampleId,
                    actionSlug,
                    syncOp,
                  ),
          child: Tooltip(
            message: label,
            child: AppContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space8,
                vertical: AppSize.space4,
              ),
              backgroundColor: bg,
              borderRadius: BorderRadius.circular(AppSize.radius4),
              child: loading
                  ? const AppInlineProgress()
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: AppSize.icon12, color: color),
                        const SizedBox(width: AppSize.space2),
                        AppText(
                          text: label,
                          fontSize: AppSize.font8,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ],
                    ),
            ),
          ),
        );
      });
}

// ─── SMALL SHARED WIDGETS ────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) =>
      StatusPill(label: status.label, bg: status.bgColor, text: status.color);
}

class _PayBadge extends StatelessWidget {
  final OrderPaymentStatus status;
  const _PayBadge(this.status);

  @override
  Widget build(BuildContext context) =>
      StatusPill(label: status.label, bg: status.bgColor, text: status.color);
}

class _SampleBadge extends StatelessWidget {
  final SampleStatus status;
  const _SampleBadge(this.status);

  @override
  Widget build(BuildContext context) =>
      StatusPill(label: status.label, bg: status.bgColor, text: status.color);
}

class _TypeBadge extends StatelessWidget {
  final ProductType type;
  const _TypeBadge(this.type);

  @override
  Widget build(BuildContext context) =>
      StatusPill(label: type.shortLabel, bg: type.bgColor, text: type.color);
}

class _GradeBadge extends StatelessWidget {
  final String grade;
  const _GradeBadge(this.grade);

  @override
  Widget build(BuildContext context) => GradePill(grade: grade);
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => AppText(
        text: text,
        fontSize: AppSize.font8,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      );
}

class _AmountRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _AmountRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          AppText(
            text: label,
            fontSize: AppSize.font10,
            color: bold ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
          const Spacer(),
          AppText(
            text: value,
            fontSize: bold ? AppSize.font12 : AppSize.font10,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            color: bold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ],
      );
}

class _InfoRow2 extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow2(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: AppSize.icon12, color: AppColors.textSecondary),
          const SizedBox(width: AppSize.space4),
          Expanded(
            child: AppText(
              text: text,
              fontSize: AppSize.font12,
              color: AppColors.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
}
