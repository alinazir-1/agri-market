import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/order_model.dart';
import '../../../../Data/Models/product_type_enums.dart';
import '../orders_con.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  EXTENSIONS
// ─────────────────────────────────────────────────────────────────────────────

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
        OrderStatus.pending => const Color(0xFFD97706),
        OrderStatus.confirmed => const Color(0xFF1D4ED8),
        OrderStatus.processing => const Color(0xFF7C3AED),
        OrderStatus.shipped => const Color(0xFF0891B2),
        OrderStatus.delivered => const Color(0xFF059669),
        OrderStatus.cancelled => const Color(0xFFDC2626),
      };

  Color get bgColor => switch (this) {
        OrderStatus.pending => const Color(0xFFFEF3C7),
        OrderStatus.confirmed => const Color(0xFFDBEAFE),
        OrderStatus.processing => const Color(0xFFEDE9FE),
        OrderStatus.shipped => const Color(0xFFCFFAFE),
        OrderStatus.delivered => const Color(0xFFD1FAE5),
        OrderStatus.cancelled => const Color(0xFFFEE2E2),
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
        OrderPaymentStatus.paid => const Color(0xFF059669),
        OrderPaymentStatus.pending => const Color(0xFFD97706),
        OrderPaymentStatus.partial => const Color(0xFF1D4ED8),
        OrderPaymentStatus.failed => const Color(0xFFDC2626),
      };

  Color get bgColor => switch (this) {
        OrderPaymentStatus.paid => const Color(0xFFD1FAE5),
        OrderPaymentStatus.pending => const Color(0xFFFEF3C7),
        OrderPaymentStatus.partial => const Color(0xFFDBEAFE),
        OrderPaymentStatus.failed => const Color(0xFFFEE2E2),
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
        SampleStatus.newRequest => const Color(0xFF7C3AED),
        SampleStatus.accepted => const Color(0xFF1D4ED8),
        SampleStatus.dispatched => const Color(0xFF0891B2),
        SampleStatus.delivered => const Color(0xFF059669),
        SampleStatus.rejected => const Color(0xFFDC2626),
        SampleStatus.cancelled => const Color(0xFF6B7280),
      };

  Color get bgColor => switch (this) {
        SampleStatus.newRequest => const Color(0xFFEDE9FE),
        SampleStatus.accepted => const Color(0xFFDBEAFE),
        SampleStatus.dispatched => const Color(0xFFCFFAFE),
        SampleStatus.delivered => const Color(0xFFD1FAE5),
        SampleStatus.rejected => const Color(0xFFFEE2E2),
        SampleStatus.cancelled => const Color(0xFFF3F4F6),
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
        ProductType.marketplace => const Color(0xFF0E7C66),
        ProductType.liveAuction => const Color(0xFF7C3AED),
        ProductType.advanceBooking => const Color(0xFFD97706),
        ProductType.booking => const Color(0xFFD97706),
        ProductType.auction => const Color(0xFF7C3AED),
      };

  Color get bgColor => switch (this) {
        ProductType.marketplace => const Color(0xFFD1FAE5),
        ProductType.liveAuction => const Color(0xFFEDE9FE),
        ProductType.advanceBooking => const Color(0xFFFEF3C7),
        ProductType.booking => const Color(0xFFFEF3C7),
        ProductType.auction => const Color(0xFFEDE9FE),
      };
}

// ─────────────────────────────────────────────────────────────────────────────
//  STAT ROW
// ─────────────────────────────────────────────────────────────────────────────

class OrdStatRow extends StatelessWidget {
  final OrdersCon c;
  const OrdStatRow({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(
        () => Container(
          color: CColors.backGroundWhite,
          padding: const EdgeInsets.fromLTRB(
              CSize.space20, CSize.space12, CSize.space20, CSize.space12),
          child: Row(
            children: [
              Expanded(
                  child: _card(
                      'TOTAL ORDERS',
                      '${c.totalOrders}',
                      'All Time',
                      Icons.receipt_long_outlined,
                      const Color(0xFFD1FAE5),
                      const Color(0xFF065F46))),
              const SizedBox(width: CSize.space12),
              Expanded(
                  child: _card(
                      'PENDING',
                      '${c.pendingOrders}',
                      'Action Required',
                      Icons.hourglass_empty_rounded,
                      const Color(0xFFFEF3C7),
                      const Color(0xFFD97706))),
              const SizedBox(width: CSize.space12),
              Expanded(
                  child: _card(
                      'PROCESSING',
                      '${c.processingOrders}',
                      'In Progress',
                      Icons.sync_rounded,
                      const Color(0xFFEDE9FE),
                      const Color(0xFF7C3AED))),
              const SizedBox(width: CSize.space12),
              Expanded(
                  child: _card(
                      'REVENUE',
                      '\$${c.monthRevenue.toStringAsFixed(0)}',
                      'Paid Orders',
                      Icons.payments_outlined,
                      const Color(0xFFDBEAFE),
                      const Color(0xFF1D4ED8),
                      valueColor: const Color(0xFF1D4ED8))),
            ],
          ),
        ),
      );

  Widget _card(String label, String value, String badge, IconData icon,
          Color iconBg, Color iconColor,
          {Color? valueColor}) =>
      Container(
        padding: const EdgeInsets.all(CSize.space12),
        decoration: BoxDecoration(
          color: CColors.backGroundWhite,
          borderRadius: BorderRadius.circular(CSize.radius20Large),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(CSize.radius10Medium)),
              child: Icon(icon, size: CSize.icon16Small, color: iconColor),
            ),
            const SizedBox(height: CSize.space8),
            Text(value,
                style: TextStyle(
                    fontSize: CSize.font24Large,
                    fontWeight: FontWeight.w800,
                    color: valueColor ?? CColors.textPrimary)),
            const SizedBox(height: CSize.space2),
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: CColors.textSecondary,
                    letterSpacing: 0.4)),
            const SizedBox(height: CSize.space5),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: CSize.space8, vertical: 2),
              decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(CSize.radius20Large)),
              child: Text(badge,
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: iconColor)),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
//  MAIN TABS — Orders | Sample Requests
// ─────────────────────────────────────────────────────────────────────────────

class OrdMainTabs extends StatelessWidget {
  final OrdersCon c;
  const OrdMainTabs({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(
        () => Container(
          decoration: const BoxDecoration(
            color: CColors.backGroundWhite,
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          padding: const EdgeInsets.symmetric(horizontal: CSize.space20),
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
            horizontal: CSize.space4, vertical: CSize.space12),
        margin: const EdgeInsets.only(right: CSize.space24),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? CColors.borderEmeraldGreen : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 13,
                color:
                    active ? CColors.iconEmeraldGreen : CColors.textSecondary),
            const SizedBox(width: CSize.space4),
            Text(label,
                style: TextStyle(
                    fontSize: CSize.font13Small,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    color: active
                        ? CColors.textEmeraldGreen
                        : CColors.textSecondary)),
            const SizedBox(width: CSize.space5),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: CSize.space5, vertical: 1),
              decoration: BoxDecoration(
                color: active
                    ? CColors.backGroundEmeraldGreen
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(CSize.radius50Circular),
              ),
              child: Text('$count',
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color:
                          active ? CColors.textWhite : CColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  STATUS TABS
// ─────────────────────────────────────────────────────────────────────────────

class OrdStatusTabs extends StatelessWidget {
  final OrdersCon c;
  const OrdStatusTabs({super.key, required this.c});

  static const _statuses = [
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
        () => Container(
          color: CColors.backGroundWhite,
          child: Row(
            children: List.generate(_statuses.length, (i) {
              final status = _statuses[i];
              final count =
                  status == null ? c.totalOrders : c.countByStatus(status);
              final label = status == null ? 'All' : status.label;
              final active = c.selectedTab.value == i;
              final color = status?.color ?? CColors.textEmeraldGreen;

              return Expanded(
                child: GestureDetector(
                  onTap: () => c.selectTab(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(vertical: CSize.space10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: active ? color : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(label,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight:
                                    active ? FontWeight.w700 : FontWeight.w500,
                                color: active ? color : CColors.textSecondary)),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: active
                                ? color.withOpacity(0.12)
                                : const Color(0xFFF1F5F9),
                            borderRadius:
                                BorderRadius.circular(CSize.radius50Circular),
                          ),
                          child: Text('$count',
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      active ? color : CColors.textSecondary)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILTER BAR
// ─────────────────────────────────────────────────────────────────────────────

class OrdFilterBar extends StatelessWidget {
  final OrdersCon c;
  const OrdFilterBar({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(
        () => Container(
          decoration: const BoxDecoration(
            color: CColors.backGroundWhite,
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space20, vertical: CSize.space10),
          child: Row(
            children: [
              // Type filter
              _dropdown<String>(
                value: c.selectedTypeFilter.value,
                items: [
                  'All Types',
                  'Marketplace',
                  'Live Auction',
                  'Advance Booking'
                ],
                onChanged: c.selectTypeFilter,
                icon: Icons.filter_list_rounded,
              ),
              const SizedBox(width: CSize.space12),
              // Sort
              _dropdown<String>(
                value: c.sortBy.value,
                items: ['Latest', 'Oldest', 'Amount High'],
                onChanged: c.selectSort,
                icon: Icons.sort_rounded,
              ),
              const Spacer(),
              // Count info
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: CSize.space12, vertical: CSize.space4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(CSize.radius20Large),
                ),
                child: Text(
                  'Showing ${c.filteredOrders.length} order${c.filteredOrders.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: CColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _dropdown<T>({
    required T value,
    required List<String> items,
    required void Function(String) onChanged,
    required IconData icon,
  }) =>
      Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: CSize.space10),
        decoration: BoxDecoration(
          color: CColors.backGroundWhite,
          borderRadius: BorderRadius.circular(CSize.radius20Large),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: CColors.textSecondary),
            const SizedBox(width: CSize.space4),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value as String,
                isDense: true,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: CColors.textPrimary),
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    size: 14, color: CColors.textSecondary),
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

// ─────────────────────────────────────────────────────────────────────────────
//  ORDERS LIST
// ─────────────────────────────────────────────────────────────────────────────

class OrdList extends StatelessWidget {
  final OrdersCon c;
  const OrdList({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(() {
        final list = c.filteredOrders;
        if (list.isEmpty) return _emptyState();
        return Column(
          children: [
            _header(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                    CSize.space20, CSize.space8, CSize.space20, CSize.space20),
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

  Widget _header() => Container(
        color: const Color(0xFFF1F5F9),
        padding: const EdgeInsets.symmetric(
            horizontal: CSize.space20, vertical: CSize.space8),
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

  Widget _emptyState() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(CSize.radius20Large)),
              child: const Icon(Icons.receipt_long_outlined,
                  size: 28, color: Color(0xFF065F46)),
            ),
            const SizedBox(height: CSize.space12),
            const Text('No orders found',
                style: TextStyle(
                    fontSize: CSize.font16Medium,
                    fontWeight: FontWeight.w700,
                    color: CColors.textPrimary)),
            const SizedBox(height: CSize.space4),
            const Text('Try adjusting your filters or search query',
                style: TextStyle(
                    fontSize: CSize.font13Small, color: CColors.textSecondary)),
          ],
        ),
      );
}

class _H extends StatelessWidget {
  final String text;
  const _H(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: CColors.textSecondary,
          letterSpacing: 0.5));
}

// ─────────────────────────────────────────────────────────────────────────────
//  ORDER CARD
// ─────────────────────────────────────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final OrdersCon c;
  final bool isSelected;

  const _OrderCard(
      {required this.order, required this.c, required this.isSelected});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => c.selectOrder(order),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: CSize.space8),
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space12, vertical: CSize.space12),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFFECFDF5) : CColors.backGroundWhite,
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
            border: Border.all(
              color: isSelected
                  ? CColors.borderEmeraldGreen
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              // ── Order ID + date + type ───────────────────────────────────
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.orderId,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: CColors.textPrimary)),
                    const SizedBox(height: 3),
                    _TypeBadge(order.productType),
                    const SizedBox(height: 3),
                    Text(_formatDate(order.orderDate),
                        style: const TextStyle(
                            fontSize: 9, color: CColors.textSecondary)),
                  ],
                ),
              ),

              // ── Product ───────────────────────────────────────────────────
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(CSize.radius5Small),
                      child: Image.asset(order.productImage,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius:
                                      BorderRadius.circular(CSize.radius5Small),
                                ),
                                child: const Icon(Icons.image_outlined,
                                    size: 16, color: CColors.textSecondary),
                              )),
                    ),
                    const SizedBox(width: CSize.space8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.productName,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: CColors.textPrimary),
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          _GradeBadge(order.productGrade),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Buyer ─────────────────────────────────────────────────────
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: CColors.backGroundEmeraldGreen,
                      child: Text(
                        order.buyerName.isNotEmpty
                            ? order.buyerName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: CSize.space5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.buyerName,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: CColors.textPrimary),
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 9, color: CColors.textSecondary),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(order.buyerLocation,
                                    style: const TextStyle(
                                        fontSize: 9,
                                        color: CColors.textSecondary),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Amount ────────────────────────────────────────────────────
              SizedBox(
                width: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('\$${order.totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: CSize.font13Small,
                            fontWeight: FontWeight.w800,
                            color: CColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text('${order.quantity.toStringAsFixed(0)} ${order.unit}',
                        style: const TextStyle(
                            fontSize: 9, color: CColors.textSecondary)),
                  ],
                ),
              ),

              // ── Status ────────────────────────────────────────────────────
              SizedBox(
                width: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatusBadge(order.orderStatus),
                    const SizedBox(height: 4),
                    _PayBadge(order.orderPaymentStatus),
                  ],
                ),
              ),

              // ── Action ────────────────────────────────────────────────────
              SizedBox(
                width: 52,
                child: Center(
                  child: Tooltip(
                    message: 'View Details',
                    child: GestureDetector(
                      onTap: () => c.selectOrder(order),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? CColors.backGroundEmeraldGreen
                              : const Color(0xFFECFDF5),
                          borderRadius:
                              BorderRadius.circular(CSize.radius5Small),
                        ),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: isSelected
                              ? CColors.iconWhite
                              : CColors.iconEmeraldGreen,
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

  String _formatDate(DateTime d) => '${d.day} ${_m(d.month)} ${d.year}';

  String _m(int m) => [
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

// ─────────────────────────────────────────────────────────────────────────────
//  ORDER DETAIL PANEL
// ─────────────────────────────────────────────────────────────────────────────

class OrdDetailPanel extends StatelessWidget {
  final OrdersCon c;
  const OrdDetailPanel({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(() {
        final o = c.selectedOrder.value;
        if (o == null) return const SizedBox.shrink();

        return Container(
          width: 270,
          decoration: const BoxDecoration(
            color: CColors.backGroundWhite,
            border: Border(left: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(CSize.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ───────────────────────────────────────────────────
                Row(children: [
                  const Text('Order Details',
                      style: TextStyle(
                          fontSize: CSize.font13Small,
                          fontWeight: FontWeight.w800,
                          color: CColors.textPrimary)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => c.selectedOrder.value = null,
                    child: const Icon(Icons.close_rounded,
                        size: 16, color: CColors.textSecondary),
                  ),
                ]),

                const SizedBox(height: CSize.space12),

                // ── Order ID + Type + Date ────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(CSize.space12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(CSize.radius10Medium),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.tag_rounded,
                            size: 11, color: CColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(o.orderId,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: CColors.textPrimary)),
                      ]),
                      const SizedBox(height: CSize.space5),
                      Row(children: [
                        _TypeBadge(o.productType),
                        const Spacer(),
                        Text(_fmtDate(o.orderDate),
                            style: const TextStyle(
                                fontSize: 9, color: CColors.textSecondary)),
                      ]),
                    ],
                  ),
                ),

                const SizedBox(height: CSize.space12),
                const _SectionTitle('PRODUCT'),
                const SizedBox(height: CSize.space8),

                // ── Product ───────────────────────────────────────────────────
                Row(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(CSize.radius5Small),
                    child: Image.asset(o.productImage,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                              width: 44,
                              height: 44,
                              color: const Color(0xFFF1F5F9),
                              child: const Icon(Icons.image_outlined,
                                  size: 20, color: CColors.textSecondary),
                            )),
                  ),
                  const SizedBox(width: CSize.space10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(o.productName,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: CColors.textPrimary)),
                        const SizedBox(height: 3),
                        Row(children: [
                          _GradeBadge(o.productGrade),
                          const SizedBox(width: 4),
                          Text('${o.quantity.toStringAsFixed(0)} ${o.unit}',
                              style: const TextStyle(
                                  fontSize: 9, color: CColors.textSecondary)),
                        ]),
                      ],
                    ),
                  ),
                ]),

                const SizedBox(height: CSize.space12),
                const Divider(color: Color(0xFFE2E8F0), height: 1),
                const SizedBox(height: CSize.space12),

                // ── Buyer ─────────────────────────────────────────────────────
                const _SectionTitle('BUYER'),
                const SizedBox(height: CSize.space8),
                Row(children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: CColors.backGroundEmeraldGreen,
                    child: Text(
                      o.buyerName.isNotEmpty
                          ? o.buyerName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: CSize.space8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(o.buyerName,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: CColors.textPrimary)),
                        const SizedBox(height: 2),
                        Row(children: [
                          const Icon(Icons.location_on_outlined,
                              size: 10, color: CColors.textSecondary),
                          const SizedBox(width: 2),
                          Expanded(
                              child: Text(o.buyerLocation,
                                  style: const TextStyle(
                                      fontSize: 9,
                                      color: CColors.textSecondary),
                                  overflow: TextOverflow.ellipsis)),
                        ]),
                      ],
                    ),
                  ),
                ]),

                const SizedBox(height: CSize.space12),
                const Divider(color: Color(0xFFE2E8F0), height: 1),
                const SizedBox(height: CSize.space12),

                // ── Amount breakdown ──────────────────────────────────────────
                const _SectionTitle('PAYMENT'),
                const SizedBox(height: CSize.space8),
                _AmountRow('Qty × Price',
                    '${o.quantity.toStringAsFixed(0)} × \$${o.pricePerUnit.toStringAsFixed(0)}'),
                const SizedBox(height: CSize.space4),
                _AmountRow('Total',
                    '\$${o.totalAmount.toStringAsFixed(0)} ${o.currency}',
                    bold: true),
                const SizedBox(height: CSize.space8),
                _PayBadge(o.orderPaymentStatus),

                const SizedBox(height: CSize.space12),
                const Divider(color: Color(0xFFE2E8F0), height: 1),
                const SizedBox(height: CSize.space12),

                // ── Delivery ──────────────────────────────────────────────────
                const _SectionTitle('DELIVERY'),
                const SizedBox(height: CSize.space8),
                _InfoRow2(Icons.local_shipping_outlined, o.deliveryOption),
                const SizedBox(height: CSize.space5),
                _InfoRow2(Icons.location_on_outlined, o.deliveryAddress),
                if (o.estimatedDeliveryDate != null) ...[
                  const SizedBox(height: CSize.space5),
                  _InfoRow2(Icons.event_available_outlined,
                      'EDD: ${_fmtDate(o.estimatedDeliveryDate!)}'),
                ],

                const SizedBox(height: CSize.space12),
                const Divider(color: Color(0xFFE2E8F0), height: 1),
                const SizedBox(height: CSize.space12),

                // ── Status progression ────────────────────────────────────────
                const _SectionTitle('STATUS'),
                const SizedBox(height: CSize.space10),
                _StatusStepper(o.orderStatus),
                const SizedBox(height: CSize.space12),
                _StatusActions(order: o, c: c),
              ],
            ),
          ),
        );
      });

  String _fmtDate(DateTime d) => '${d.day} ${[
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

// ─────────────────────────────────────────────────────────────────────────────
//  STATUS STEPPER
// ─────────────────────────────────────────────────────────────────────────────

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
      return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: CSize.space12, vertical: CSize.space8),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(CSize.radius10Medium),
        ),
        child: const Row(
          children: [
            Icon(Icons.cancel_outlined, size: 14, color: Color(0xFFDC2626)),
            SizedBox(width: CSize.space5),
            Text('Order Cancelled',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFDC2626))),
          ],
        ),
      );
    }

    final currentIdx = _steps.indexOf(current);

    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Connector line
          final stepIdx = i ~/ 2;
          final done = stepIdx < currentIdx;
          return Expanded(
            child: Container(
              height: 2,
              color:
                  done ? CColors.borderEmeraldGreen : const Color(0xFFE2E8F0),
            ),
          );
        }
        final stepIdx = i ~/ 2;
        final done = stepIdx <= currentIdx;
        final active = stepIdx == currentIdx;
        final step = _steps[stepIdx];

        return Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: done
                    ? CColors.backGroundEmeraldGreen
                    : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
                border: Border.all(
                  color: active
                      ? CColors.borderEmeraldGreen
                      : done
                          ? CColors.borderEmeraldGreen
                          : const Color(0xFFE2E8F0),
                  width: active ? 2 : 1,
                ),
              ),
              child: Icon(
                done ? Icons.check_rounded : step.icon,
                size: 10,
                color: done ? CColors.iconWhite : CColors.textSecondary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              step.label.length > 5
                  ? '${step.label.substring(0, 5)}.'
                  : step.label,
              style: TextStyle(
                  fontSize: 7,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active
                      ? CColors.textEmeraldGreen
                      : CColors.textSecondary),
            ),
          ],
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  STATUS ACTION BUTTONS
// ─────────────────────────────────────────────────────────────────────────────

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
                padding: const EdgeInsets.only(bottom: CSize.space8),
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
              const Color(0xFF1D4ED8),
              const Color(0xFFDBEAFE),
              () => c.updateOrderStatus(order.orderId, OrderStatus.confirmed)),
          _btn(
              'Cancel Order',
              Icons.cancel_outlined,
              const Color(0xFFDC2626),
              const Color(0xFFFEE2E2),
              () => c.updateOrderStatus(order.orderId, OrderStatus.cancelled)),
        ];
      case OrderStatus.confirmed:
        return [
          _btn(
              'Start Processing',
              Icons.sync_rounded,
              const Color(0xFF7C3AED),
              const Color(0xFFEDE9FE),
              () => c.updateOrderStatus(order.orderId, OrderStatus.processing)),
          _btn(
              'Cancel Order',
              Icons.cancel_outlined,
              const Color(0xFFDC2626),
              const Color(0xFFFEE2E2),
              () => c.updateOrderStatus(order.orderId, OrderStatus.cancelled)),
        ];
      case OrderStatus.processing:
        return [
          _btn(
              'Mark as Shipped',
              Icons.local_shipping_outlined,
              const Color(0xFF0891B2),
              const Color(0xFFCFFAFE),
              () => c.updateOrderStatus(order.orderId, OrderStatus.shipped)),
        ];
      case OrderStatus.shipped:
        return [
          _btn(
              'Mark as Delivered',
              Icons.done_all_rounded,
              const Color(0xFF059669),
              const Color(0xFFD1FAE5),
              () => c.updateOrderStatus(order.orderId, OrderStatus.delivered)),
        ];
      default:
        return [];
    }
  }

  Widget _btn(String label, IconData icon, Color color, Color bg,
          VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space12, vertical: CSize.space10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
          ),
          child: Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: CSize.space8),
              Text(label,
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700, color: color)),
            ],
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
//  SAMPLES LIST
// ─────────────────────────────────────────────────────────────────────────────

class OrdSamplesList extends StatelessWidget {
  final OrdersCon c;
  const OrdSamplesList({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(() {
        final list = c.sampleRequests;
        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FE),
                      borderRadius: BorderRadius.circular(CSize.radius20Large)),
                  child: const Icon(Icons.science_outlined,
                      size: 28, color: Color(0xFF7C3AED)),
                ),
                const SizedBox(height: CSize.space12),
                const Text('No sample requests',
                    style: TextStyle(
                        fontSize: CSize.font16Medium,
                        fontWeight: FontWeight.w700,
                        color: CColors.textPrimary)),
              ],
            ),
          );
        }

        return Column(
          children: [
            _header(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                    CSize.space20, CSize.space8, CSize.space20, CSize.space20),
                itemCount: list.length,
                itemBuilder: (_, i) => _SampleCard(sample: list[i], c: c),
              ),
            ),
          ],
        );
      });

  Widget _header() => Container(
        color: const Color(0xFFF1F5F9),
        padding: const EdgeInsets.symmetric(
            horizontal: CSize.space20, vertical: CSize.space8),
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
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: CSize.space8),
        padding: const EdgeInsets.symmetric(
            horizontal: CSize.space12, vertical: CSize.space12),
        decoration: BoxDecoration(
          color: CColors.backGroundWhite,
          borderRadius: BorderRadius.circular(CSize.radius10Medium),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            // ── Sample ID + date ──────────────────────────────────────────
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sample.sampleId,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: CColors.textPrimary)),
                  const SizedBox(height: 3),
                  Text(_fmtDate(sample.requestDate),
                      style: const TextStyle(
                          fontSize: 9, color: CColors.textSecondary)),
                ],
              ),
            ),

            // ── Product ───────────────────────────────────────────────────
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(CSize.radius5Small),
                    child: Image.asset(sample.productImage,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                              width: 32,
                              height: 32,
                              color: const Color(0xFFF1F5F9),
                              child: const Icon(Icons.image_outlined,
                                  size: 14, color: CColors.textSecondary),
                            )),
                  ),
                  const SizedBox(width: CSize.space8),
                  Expanded(
                    child: Text(sample.productName,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: CColors.textPrimary),
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),

            // ── Buyer ─────────────────────────────────────────────────────
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sample.buyerName,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: CColors.textPrimary),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(sample.buyerLocation,
                      style: const TextStyle(
                          fontSize: 9, color: CColors.textSecondary),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),

            // ── Qty + Delivery ────────────────────────────────────────────
            SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${sample.sampleQty.toStringAsFixed(0)} ${sample.sampleUnit}',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: CColors.textPrimary)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        sample.isDeliveryBySeller
                            ? Icons.local_shipping_outlined
                            : Icons.store_outlined,
                        size: 9,
                        color: CColors.textSecondary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        sample.isDeliveryBySeller ? 'Delivered' : 'Pickup',
                        style: const TextStyle(
                            fontSize: 9, color: CColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Price ─────────────────────────────────────────────────────
            SizedBox(
              width: 70,
              child: Text(
                sample.samplePrice == 0
                    ? 'FREE'
                    : '\$${sample.samplePrice.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: CSize.font13Small,
                    fontWeight: FontWeight.w800,
                    color: sample.samplePrice == 0
                        ? const Color(0xFF059669)
                        : CColors.textPrimary),
              ),
            ),

            // ── Status ────────────────────────────────────────────────────
            SizedBox(
              width: 90,
              child: _SampleBadge(sample.status),
            ),

            // ── Actions ───────────────────────────────────────────────────
            SizedBox(
              width: 100,
              child: _SampleActions(sample: sample, c: c),
            ),
          ],
        ),
      );

  String _fmtDate(DateTime d) => '${d.day} ${[
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
                const Color(0xFF059669),
                const Color(0xFFD1FAE5),
                'Accept',
                () => c.updateSampleStatus(
                    sample.sampleId, SampleStatus.accepted)),
            const SizedBox(width: 4),
            _btn(
                Icons.close_rounded,
                const Color(0xFFDC2626),
                const Color(0xFFFEE2E2),
                'Reject',
                () => c.updateSampleStatus(
                    sample.sampleId, SampleStatus.rejected)),
          ],
        );
      case SampleStatus.accepted:
        return _btn(
            Icons.local_shipping_outlined,
            const Color(0xFF0891B2),
            const Color(0xFFCFFAFE),
            'Dispatch',
            () =>
                c.updateSampleStatus(sample.sampleId, SampleStatus.dispatched));
      case SampleStatus.dispatched:
        return _btn(
            Icons.done_all_rounded,
            const Color(0xFF059669),
            const Color(0xFFD1FAE5),
            'Delivered',
            () =>
                c.updateSampleStatus(sample.sampleId, SampleStatus.delivered));
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _btn(IconData icon, Color color, Color bg, String label,
          VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Tooltip(
          message: label,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8, vertical: CSize.space4),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(CSize.radius5Small),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 11, color: color),
                const SizedBox(width: 3),
                Text(label,
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: color)),
              ],
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
//  SMALL SHARED WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: CSize.space5, vertical: 2),
        decoration: BoxDecoration(
          color: status.bgColor,
          borderRadius: BorderRadius.circular(CSize.radius20Large),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(status.icon, size: 8, color: status.color),
            const SizedBox(width: 3),
            Text(status.label,
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: status.color)),
          ],
        ),
      );
}

class _PayBadge extends StatelessWidget {
  final OrderPaymentStatus status;
  const _PayBadge(this.status);

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: CSize.space5, vertical: 2),
        decoration: BoxDecoration(
          color: status.bgColor,
          borderRadius: BorderRadius.circular(CSize.radius20Large),
        ),
        child: Text(status.label,
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w700, color: status.color)),
      );
}

class _SampleBadge extends StatelessWidget {
  final SampleStatus status;
  const _SampleBadge(this.status);

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: CSize.space5, vertical: 3),
        decoration: BoxDecoration(
          color: status.bgColor,
          borderRadius: BorderRadius.circular(CSize.radius20Large),
        ),
        child: Text(status.label,
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w700, color: status.color)),
      );
}

class _TypeBadge extends StatelessWidget {
  final ProductType type;
  const _TypeBadge(this.type);

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: CSize.space5, vertical: 2),
        decoration: BoxDecoration(
          color: type.bgColor,
          borderRadius: BorderRadius.circular(CSize.radius20Large),
        ),
        child: Text(type.shortLabel,
            style: TextStyle(
                fontSize: 8, fontWeight: FontWeight.w700, color: type.color)),
      );
}

class _GradeBadge extends StatelessWidget {
  final String grade;
  const _GradeBadge(this.grade);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(CSize.radius5Small),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Text('Grade $grade',
            style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: CColors.textSecondary)),
      );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: CColors.textSecondary,
          letterSpacing: 0.5));
}

class _AmountRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _AmountRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: bold ? CColors.textPrimary : CColors.textSecondary,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontSize: bold ? CSize.font13Small : 10,
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                  color: bold ? CColors.textPrimary : CColors.textSecondary)),
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
          Icon(icon, size: 11, color: CColors.textSecondary),
          const SizedBox(width: CSize.space5),
          Expanded(
              child: Text(text,
                  style:
                      const TextStyle(fontSize: 11, color: CColors.textPrimary),
                  overflow: TextOverflow.ellipsis)),
        ],
      );
}
