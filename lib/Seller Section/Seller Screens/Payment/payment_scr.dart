import 'package:agri_market/Seller%20Section/Seller%20Screens/Payment/payment_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Core/Theme/app_theme.dart';
import '../../../Data/Models/payment_model.dart';
import '../../../Shared/Screens Common Widgets/screen_top_bar.dart';
import 'Payment Widgets/all_widgets.dart';

class PaymentsScr extends StatelessWidget {
  final PaymentsCon paymentsController = Get.find<PaymentsCon>();

  PaymentsScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: SafeArea(
        child: Column(
          children: [
            ScreenTopBar(
              title: 'Payments',
              subtitle: 'Track your earnings and transactions',
              searchController: paymentsController.searchController,
              onSearch: paymentsController.onSearch,
              searchHint: 'Search by buyer, order ID...',
            ),
            _SummaryCards(paymentsController: paymentsController),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final showSidebar = constraints.maxWidth >= 700;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: _TableSection(
                              paymentsController: paymentsController)),
                      if (showSidebar)
                        _Sidebar(paymentsController: paymentsController),
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

// ─────────────────────────────────────────────────────────────────────────────
//  FILE: payments_summary_cards.dart
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryCards extends StatelessWidget {
  final PaymentsCon paymentsController;
  const _SummaryCards({required this.paymentsController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: context.cardBg2,
            border: Border(bottom: BorderSide(color: context.borderClr)),
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
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: context.borderClr)),
      ),
      child: Column(
        children: [
          _tableHeader(context),
          Expanded(child: _tableBody(context)),
        ],
      ),
    );
  }

  Widget _tableHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CSize.space20,
        CSize.space14,
        CSize.space20,
        CSize.space12,
      ),
      child: Row(
        children: [
          Text(
            'Transactions',
            style: TextStyle(
              fontSize: CSize.font13Small,
              fontWeight: FontWeight.w800,
              color: context.txtPrimary,
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
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(CSize.radius10Medium),
                  border: Border.all(color: context.borderClr),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<PaymentSort>(
                    value: paymentsController.selectedSort.value,
                    isDense: true,
                    style: TextStyle(
                      fontSize: CSize.font10XSmall,
                      fontWeight: FontWeight.w600,
                      color: context.txtPrimary,
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

  Widget _tableBody(BuildContext context) {
    return Obx(() {
      final list = paymentsController.filteredPayments;
      if (list.isEmpty) {
        return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.payments_outlined,
                size: CSize.icon36XLarge, color: context.txtSecondary),
            const SizedBox(height: CSize.space12),
            Text('No transactions found',
                style: TextStyle(
                    fontSize: CSize.font13Small, color: context.txtSecondary)),
          ]),
        );
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: CSize.space20),
        child: Table(
          columnWidths: _colWidths,
          children: [
            TableRow(
              decoration: BoxDecoration(color: context.cardBg2),
              children: _headers
                  .map((h) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: CSize.space8,
                          vertical: CSize.space10,
                        ),
                        child: Text(
                          h.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: context.txtSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            ...list.map((payment) => _buildRow(payment, context)),
          ],
        ),
      );
    });
  }

  TableRow _buildRow(PaymentModel payment, BuildContext context) {
    final amountColor = payment.status == PaymentStatus.failed
        ? CColors.textError
        : payment.status == PaymentStatus.pending ||
                payment.status == PaymentStatus.partial
            ? CColors.backGroundOrange
            : CColors.textEmeraldGreen;

    return TableRow(
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: context.dividerClr, width: 0.5)),
      ),
      children: [
        // Order ID
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Text(
            '#${payment.orderId}',
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: context.txtPrimary),
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
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: context.txtPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(payment.buyerEmail,
                      style: TextStyle(
                          fontSize: 9, color: context.txtSecondary),
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
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: context.txtPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              Text('${payment.quantity} ${payment.unit}',
                  style: TextStyle(
                      fontSize: 9, color: context.txtSecondary)),
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
            style: TextStyle(fontSize: 10, color: context.txtSecondary),
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
                color: context.cardBg,
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                border: Border.all(
                    color: context.borderClr, width: CSize.borderWidth1),
              ),
              child: Text(
                'View',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: context.txtPrimary),
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
            _pendingSection(context),
          ],
        ),
      ),
    );
  }

  Widget _pendingSection(BuildContext context) {
    return Obx(() {
      final list = paymentsController.pendingPayments;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.access_time_rounded,
                size: CSize.icon16Small, color: CColors.backGroundOrange),
            const SizedBox(width: CSize.space5),
            Text(
              'Pending Payments',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: context.txtPrimary),
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
