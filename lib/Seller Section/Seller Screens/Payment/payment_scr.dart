import 'package:agri_market/Seller%20Section/Seller%20Screens/Payment/payment_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Data/Models/payment_model.dart';
import 'Payment Widgets/all_widgets.dart';

class PaymentsScr extends StatelessWidget {
  final PaymentsCon paymentsController = Get.put(PaymentsCon());

  PaymentsScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(paymentsController: paymentsController),
            _SummaryCards(paymentsController: paymentsController),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: _TableSection(
                          paymentsController: paymentsController)),
                  _Sidebar(paymentsController: paymentsController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILE: payments_top_bar.dart
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final PaymentsCon paymentsController;
  const _TopBar({required this.paymentsController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: CColors.backGroundWhite,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: CSize.space20,
        vertical: CSize.space12,
      ),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payments',
                style: TextStyle(
                  fontSize: CSize.font24Large,
                  fontWeight: FontWeight.w900,
                  color: CColors.textPrimary,
                ),
              ),
              SizedBox(height: CSize.space2),
              Text(
                'Track your earnings and transactions',
                style: TextStyle(
                  fontSize: CSize.font10XSmall,
                  color: CColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(width: CSize.space20),
          SizedBox(
            width: 280,
            height: 36,
            child: TextField(
              controller: paymentsController.searchController,
              onChanged: paymentsController.onSearch,
              style: const TextStyle(fontSize: 11, color: CColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search by buyer, order ID...',
                hintStyle:
                    const TextStyle(fontSize: 11, color: CColors.textSecondary),
                prefixIcon: const Icon(Icons.search,
                    size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
                filled: true,
                fillColor: CColors.backGroundLightGrey,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: CSize.space10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                  borderSide: const BorderSide(
                    color: CColors.borderEmeraldGreen,
                    width: CSize.borderWidth1,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Stack(children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: CColors.backGroundWhite,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Icon(Icons.notifications_none_rounded,
                  size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: CColors.notificationDot,
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: CColors.backGroundWhite, width: 1.5),
                ),
              ),
            ),
          ]),
          const SizedBox(width: CSize.space8),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: CColors.backGroundWhite,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Icon(Icons.messenger_outline_rounded,
                size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
          ),
          const SizedBox(width: CSize.space8),
          const CircleAvatar(
            radius: 17,
            backgroundColor: CColors.backGroundEmeraldGreen,
            child: Text(
              'AS',
              style: TextStyle(
                fontSize: CSize.font10XSmall,
                fontWeight: FontWeight.w800,
                color: CColors.textWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILE: payments_summary_cards.dart
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryCards extends StatelessWidget {
  final PaymentsCon paymentsController;
  const _SummaryCards({required this.paymentsController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: CSize.space20,
            vertical: CSize.space14,
          ),
          child: Row(
            children: [
              Expanded(
                  child: PayStatCard(
                label: 'Total Revenue',
                value: paymentsController
                    .formatAmount(paymentsController.totalRevenue),
                badge: 'Lifetime',
                icon: Icons.attach_money_rounded,
                iconBg: CColors.backgroundEmerald100,
                iconColor: CColors.iconEmeraldGreen,
                badgeBg: CColors.backgroundEmerald100,
                badgeText: CColors.textEmeraldGreen,
              )),
              const SizedBox(width: CSize.space12),
              Expanded(
                  child: PayStatCard(
                label: 'This Month',
                value: paymentsController
                    .formatAmount(paymentsController.thisMonthRevenue),
                badge: '↑ 12% vs last',
                icon: Icons.trending_up_rounded,
                iconBg: CColors.backgroundEmerald100,
                iconColor: CColors.iconEmeraldGreen,
                badgeBg: CColors.backgroundEmerald100,
                badgeText: CColors.textEmeraldGreen,
              )),
              const SizedBox(width: CSize.space12),
              Expanded(
                  child: PayStatCard(
                label: 'Pending',
                value: paymentsController
                    .formatAmount(paymentsController.pendingAmount),
                badge: '${paymentsController.pendingCount} orders',
                icon: Icons.access_time_rounded,
                iconBg: const Color(0xFFFFF7ED),
                iconColor: CColors.backGroundOrange,
                badgeBg: const Color(0xFFFFF7ED),
                badgeText: CColors.textOrange,
                valueColor: CColors.backGroundOrange,
              )),
              const SizedBox(width: CSize.space12),
              Expanded(
                  child: PayStatCard(
                label: 'Failed / Refunded',
                value: paymentsController
                    .formatAmount(paymentsController.failedAmount),
                badge: '${paymentsController.failedCount} orders',
                icon: Icons.cancel_outlined,
                iconBg: const Color(0xFFFEE2E2),
                iconColor: CColors.iconError,
                badgeBg: const Color(0xFFFEE2E2),
                badgeText: CColors.textError,
                valueColor: CColors.textError,
              )),
            ],
          ),
        ));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILE: payments_table_section.dart
// ─────────────────────────────────────────────────────────────────────────────

class _TableSection extends StatelessWidget {
  final PaymentsCon paymentsController;
  const _TableSection({required this.paymentsController});

  static const List<String> _headers = [
    'Order ID',
    'Buyer',
    'Product',
    'Type',
    'Amount',
    'Status',
    'Date',
    'Action',
  ];

  static const Map<int, TableColumnWidth> _colWidths = {
    0: FlexColumnWidth(1.5),
    1: FlexColumnWidth(2.5),
    2: FlexColumnWidth(2.5),
    3: FlexColumnWidth(1.5),
    4: FlexColumnWidth(1.5),
    5: FlexColumnWidth(1.2),
    6: FlexColumnWidth(1.5),
    7: FlexColumnWidth(1),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        children: [
          _tableHeader(),
          Expanded(child: _tableBody()),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CSize.space20,
        CSize.space14,
        CSize.space20,
        CSize.space12,
      ),
      child: Row(
        children: [
          const Text(
            'Transactions',
            style: TextStyle(
              fontSize: CSize.font13Small,
              fontWeight: FontWeight.w800,
              color: CColors.textPrimary,
            ),
          ),
          const SizedBox(width: CSize.space12),
          Obx(() => Wrap(
                spacing: CSize.space5,
                children: [
                  PayFilterChip(
                      label: 'All',
                      isActive: paymentsController.selectedFilter.value ==
                          PaymentFilter.all,
                      onTap: () =>
                          paymentsController.setFilter(PaymentFilter.all)),
                  PayFilterChip(
                      label: 'Paid',
                      isActive: paymentsController.selectedFilter.value ==
                          PaymentFilter.paid,
                      onTap: () =>
                          paymentsController.setFilter(PaymentFilter.paid)),
                  PayFilterChip(
                      label: 'Pending',
                      isActive: paymentsController.selectedFilter.value ==
                          PaymentFilter.pending,
                      onTap: () =>
                          paymentsController.setFilter(PaymentFilter.pending),
                      activeColor: CColors.backGroundOrange,
                      activeBorder: CColors.backGroundOrange,
                      inactiveBorder: const Color(0xFFFED7AA),
                      inactiveText: CColors.textOrange),
                  PayFilterChip(
                      label: 'Partial',
                      isActive: paymentsController.selectedFilter.value ==
                          PaymentFilter.partial,
                      onTap: () =>
                          paymentsController.setFilter(PaymentFilter.partial),
                      activeColor: const Color(0xFF1D4ED8),
                      activeBorder: const Color(0xFF1D4ED8),
                      inactiveBorder: const Color(0xFFDBEAFE),
                      inactiveText: const Color(0xFF1E40AF)),
                  PayFilterChip(
                      label: 'Failed',
                      isActive: paymentsController.selectedFilter.value ==
                          PaymentFilter.failed,
                      onTap: () =>
                          paymentsController.setFilter(PaymentFilter.failed),
                      activeColor: CColors.borderError,
                      activeBorder: CColors.borderError,
                      inactiveBorder: const Color(0xFFFCA5A5),
                      inactiveText: CColors.textRichRed),
                ],
              )),
          const Spacer(),
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: CSize.space12,
                  vertical: CSize.space5,
                ),
                decoration: BoxDecoration(
                  color: CColors.backGroundWhite,
                  borderRadius: BorderRadius.circular(CSize.radius10Medium),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<PaymentSort>(
                    value: paymentsController.selectedSort.value,
                    isDense: true,
                    style: const TextStyle(
                      fontSize: CSize.font10XSmall,
                      fontWeight: FontWeight.w600,
                      color: CColors.textPrimary,
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down,
                        size: CSize.icon16Small,
                        color: CColors.iconEmeraldGreen),
                    items: const [
                      DropdownMenuItem(
                          value: PaymentSort.latest, child: Text('Latest')),
                      DropdownMenuItem(
                          value: PaymentSort.oldest, child: Text('Oldest')),
                      DropdownMenuItem(
                          value: PaymentSort.highestAmount,
                          child: Text('Highest Amount')),
                      DropdownMenuItem(
                          value: PaymentSort.lowestAmount,
                          child: Text('Lowest Amount')),
                    ],
                    onChanged: (val) =>
                        paymentsController.setSort(val ?? PaymentSort.latest),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _tableBody() {
    return Obx(() {
      final list = paymentsController.filteredPayments;
      if (list.isEmpty) {
        return const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.payments_outlined,
                size: CSize.icon36XLarge, color: CColors.textSecondary),
            SizedBox(height: CSize.space12),
            Text('No transactions found',
                style: TextStyle(
                    fontSize: CSize.font13Small, color: CColors.textSecondary)),
          ]),
        );
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: CSize.space20),
        child: Table(
          columnWidths: _colWidths,
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
              children: _headers
                  .map((h) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: CSize.space8,
                          vertical: CSize.space10,
                        ),
                        child: Text(
                          h.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: CColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            ...list.map((payment) => _buildRow(payment)),
          ],
        ),
      );
    });
  }

  TableRow _buildRow(PaymentModel payment) {
    final amountColor = payment.status == PaymentStatus.failed
        ? CColors.textError
        : payment.status == PaymentStatus.pending ||
                payment.status == PaymentStatus.partial
            ? CColors.backGroundOrange
            : CColors.textEmeraldGreen;

    return TableRow(
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 0.5)),
      ),
      children: [
        // Order ID
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Text(
            '#${payment.orderId}',
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: CColors.textPrimary),
          ),
        ),

        // Buyer
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Row(
            children: [
              PayBuyerAvatar(
                  initials: payment.initials, color: payment.avatarColor),
              const SizedBox(width: CSize.space8),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(payment.buyerName,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: CColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(payment.buyerEmail,
                      style: const TextStyle(
                          fontSize: 9, color: CColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              )),
            ],
          ),
        ),

        // Product
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(payment.productName,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: CColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              Text('${payment.quantity} ${payment.unit}',
                  style: const TextStyle(
                      fontSize: 9, color: CColors.textSecondary)),
            ],
          ),
        ),

        // Type
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: PayTypeBadge(type: payment.productType),
        ),

        // Amount
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Text(
            '\$${payment.amount.toStringAsFixed(0)}',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w800, color: amountColor),
          ),
        ),

        // Status
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: PayStatusPill(status: payment.status),
        ),

        // Date
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Text(
            paymentsController.formatDate(payment.date),
            style: const TextStyle(fontSize: 10, color: CColors.textSecondary),
          ),
        ),

        // Action
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: GestureDetector(
            onTap: () => paymentsController.viewPayment(payment),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: CSize.space10,
                vertical: CSize.space4,
              ),
              decoration: BoxDecoration(
                color: CColors.backGroundWhite,
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                border: Border.all(
                    color: const Color(0xFFE2E8F0), width: CSize.borderWidth1),
              ),
              child: const Text(
                'View',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: CColors.textPrimary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILE: payments_sidebar.dart
// ─────────────────────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  final PaymentsCon paymentsController;
  const _Sidebar({required this.paymentsController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(CSize.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue chart
            MonthlyRevenueChart(
              data: paymentsController.monthlyRevenue,
              maxAmount: paymentsController.maxMonthlyRevenue,
            ),
            const SizedBox(height: CSize.space20),
            // Pending payments
            _pendingSection(),
          ],
        ),
      ),
    );
  }

  Widget _pendingSection() {
    return Obx(() {
      final list = paymentsController.pendingPayments;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.access_time_rounded,
                size: CSize.icon16Small, color: CColors.backGroundOrange),
            const SizedBox(width: CSize.space5),
            const Text(
              'Pending Payments',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: CColors.textPrimary),
            ),
            const SizedBox(width: CSize.space5),
            if (list.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: CSize.space8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(CSize.radius20Large),
                ),
                child: Text(
                  '${list.length}',
                  style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9A3412)),
                ),
              ),
          ]),
          const SizedBox(height: CSize.space10),
          if (list.isEmpty)
            Container(
              padding: const EdgeInsets.all(CSize.space12),
              decoration: BoxDecoration(
                color: CColors.backgroundEmerald100,
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
              ),
              child: const Row(children: [
                Icon(Icons.check_circle_outline,
                    size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
                SizedBox(width: CSize.space8),
                Text('All payments received!',
                    style: TextStyle(
                        fontSize: 10,
                        color: CColors.textEmeraldGreen,
                        fontWeight: FontWeight.w600)),
              ]),
            )
          else
            ...list.map((payment) => PendingPayCard(
                  payment: payment,
                  dateText: paymentsController.formatDate(payment.date),
                  dueDateText: payment.dueDate != null
                      ? paymentsController.formatDate(payment.dueDate!)
                      : 'N/A',
                  onReminder: () => paymentsController.sendReminder(payment),
                )),
        ],
      );
    });
  }
}
