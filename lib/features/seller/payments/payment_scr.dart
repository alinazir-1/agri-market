import 'package:agri_market/features/seller/payments/payment_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/data/models/payment_model.dart';
import 'package:agri_market/shared/widgets/seller/screen_top_bar.dart';
import 'package:agri_market/shared/widgets/seller/seller_metric_stat_row.dart';
import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:agri_market/features/seller/payments/widgets/payment_widgets.dart';
import '../../../shared/widgets/common/app_container.dart';
import '../../../shared/widgets/common/app_text.dart';

class PaymentsScr extends StatelessWidget {
  final PaymentsCon ctrlPayments = Get.put(PaymentsCon(), permanent: true);

  PaymentsScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: Column(
          children: [
            ScreenTopBar(
              title: 'Payments',
              subtitle: 'Track your earnings and transactions',
              searchController: ctrlPayments.searchController,
              onSearch: ctrlPayments.onSearch,
              searchHint: 'Search by buyer, order ID...',
            ),
            _SummaryCards(ctrlPayments: ctrlPayments),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _TableSection(ctrlPayments: ctrlPayments)),
                  _Sidebar(ctrlPayments: ctrlPayments),
                ],
              ),
            ),
          ],
        ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SUMMARY CARDS
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryCards extends StatelessWidget {
  final PaymentsCon ctrlPayments;
  const _SummaryCards({required this.ctrlPayments});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SellerMetricStatRow(
        items: [
          SellerMetricStatItem(
            label: 'TOTAL REVENUE',
            value: ctrlPayments.formatAmount(ctrlPayments.totalRevenue),
            badge: 'Lifetime',
            icon: Icons.attach_money_rounded,
            iconBg: AppColors.badgeSuccessBg,
            iconColor: AppColors.badgeSuccessText,
          ),
          SellerMetricStatItem(
            label: 'THIS MONTH',
            value: ctrlPayments.formatAmount(ctrlPayments.thisMonthRevenue),
            badge: 'Current period',
            icon: Icons.trending_up_rounded,
            iconBg: AppColors.badgeInfoBg,
            iconColor: AppColors.badgeInfoText,
            valueColor: AppColors.badgeInfoText,
          ),
          SellerMetricStatItem(
            label: 'PENDING',
            value: ctrlPayments.formatAmount(ctrlPayments.pendingAmount),
            badge: '${ctrlPayments.pendingCount} orders',
            icon: Icons.access_time_rounded,
            iconBg: AppColors.badgeWarningBg,
            iconColor: AppColors.badgeWarningText,
            valueColor: AppColors.badgeWarningText,
          ),
          SellerMetricStatItem(
            label: 'FAILED / REFUNDED',
            value: ctrlPayments.formatAmount(ctrlPayments.failedAmount),
            badge: '${ctrlPayments.failedCount} orders',
            icon: Icons.cancel_outlined,
            iconBg: AppColors.badgeErrorBg,
            iconColor: AppColors.badgeErrorText,
            valueColor: AppColors.badgeErrorText,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  TABLE SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _TableSection extends StatelessWidget {
  final PaymentsCon ctrlPayments;
  const _TableSection({required this.ctrlPayments});

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
    return AppContainer(
      border: Border(right: BorderSide(color: context.borderClr)),
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
        AppSize.space20,
        AppSize.space12,
        AppSize.space20,
        AppSize.space12,
      ),
      child: Row(
        children: [
          Obx(() => Wrap(
                spacing: AppSize.space4,
                children: [
                  PayFilterChip(
                      label: 'All',
                      isActive: ctrlPayments.selectedFilter.value ==
                          PaymentFilter.all,
                      onTap: () => ctrlPayments.setFilter(PaymentFilter.all)),
                  PayFilterChip(
                      label: 'Paid',
                      isActive: ctrlPayments.selectedFilter.value ==
                          PaymentFilter.paid,
                      onTap: () => ctrlPayments.setFilter(PaymentFilter.paid)),
                  PayFilterChip(
                      label: 'Pending',
                      isActive: ctrlPayments.selectedFilter.value ==
                          PaymentFilter.pending,
                      onTap: () =>
                          ctrlPayments.setFilter(PaymentFilter.pending),
                      activeColor: AppColors.textWarning,
                      activeBorder: AppColors.textWarning,
                      inactiveBorder: AppColors.badgeWarningBg,
                      inactiveText: AppColors.textWarning),
                  PayFilterChip(
                      label: 'Partial',
                      isActive: ctrlPayments.selectedFilter.value ==
                          PaymentFilter.partial,
                      onTap: () =>
                          ctrlPayments.setFilter(PaymentFilter.partial),
                      activeColor: AppColors.textInfo, // mapped 0xFF1D4ED8
                      activeBorder: AppColors.textInfo,
                      inactiveBorder:
                          AppColors.badgeInfoBg, // mapped 0xFFDBEAFE
                      inactiveText: AppColors.textInfo), // mapped 0xFF1E40AF
                  PayFilterChip(
                      label: 'Failed',
                      isActive: ctrlPayments.selectedFilter.value ==
                          PaymentFilter.failed,
                      onTap: () => ctrlPayments.setFilter(PaymentFilter.failed),
                      activeColor: AppColors.borderError,
                      activeBorder: AppColors.borderError,
                      inactiveBorder: AppColors.badgeErrorBg,
                      inactiveText: AppColors.textRichRed),
                ],
              )),
          const Spacer(),
          Obx(() => AppContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space12,
                  vertical: AppSize.space4, // mapped 5 to 4
                ),
                backgroundColor: context.cardBg,
                borderRadius:
                    BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
                border: Border.all(color: context.borderClr),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<PaymentSort>(
                    value: ctrlPayments.selectedSort.value,
                    isDense: true,
                    style: TextStyle(
                      fontSize: AppSize.font10,
                      fontWeight: FontWeight.w600,
                      color: context.txtPrimary,
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down,
                        size: AppSize.icon16,
                        color: AppColors.iconEmeraldGreen),
                    items: const [
                      DropdownMenuItem(
                          value: PaymentSort.latest,
                          child: AppText(text: 'Latest')),
                      DropdownMenuItem(
                          value: PaymentSort.oldest,
                          child: AppText(text: 'Oldest')),
                      DropdownMenuItem(
                          value: PaymentSort.highestAmount,
                          child: AppText(text: 'Highest Amount')),
                      DropdownMenuItem(
                          value: PaymentSort.lowestAmount,
                          child: AppText(text: 'Lowest Amount')),
                    ],
                    onChanged: (val) =>
                        ctrlPayments.setSort(val ?? PaymentSort.latest),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _tableBody(BuildContext context) {
    return Obx(() {
      if (ctrlPayments.isLoading.value) {
        return const AppSkeletonListColumn();
      }
      final list = ctrlPayments.filteredPayments;
      if (list.isEmpty) {
        return const AppEmptyListState(
          message: 'No transactions found',
          icon: Icons.payments_outlined,
        );
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSize.space20),
        child: Table(
          columnWidths: _colWidths,
          children: [
            TableRow(
              decoration: BoxDecoration(color: context.cardBg2),
              children: _headers
                  .map((h) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.space8,
                          vertical: AppSize.space12, // mapped 10 to 12
                        ),
                        child: AppText(
                          text: h.toUpperCase(),
                          fontSize: AppSize.font8, // mapped 9 to 8
                          fontWeight: FontWeight.w800,
                          color: context.txtSecondary,
                          letterSpacing: 0.5,
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
        ? AppColors.textError
        : payment.status == PaymentStatus.pending ||
                payment.status == PaymentStatus.partial
            ? AppColors.textWarning
            : AppColors.textEmeraldGreen;

    return TableRow(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: context.dividerClr, width: AppSize.borderWidth05)),
      ),
      children: [
        // Order ID
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space12),
          child: AppText(
            text: '#${payment.orderId}',
            fontSize: AppSize.font10,
            fontWeight: FontWeight.w700,
            color: context.txtPrimary,
          ),
        ),

        // Buyer
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space12),
          child: Row(
            children: [
              PayBuyerAvatar(
                  initials: payment.initials, avatarHex: payment.avatarHex),
              const SizedBox(width: AppSize.space8),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                      text: payment.buyerName,
                      fontSize: AppSize.font10, // mapped 11 to 10
                      fontWeight: FontWeight.w600,
                      color: context.txtPrimary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  AppText(
                      text: payment.buyerEmail,
                      fontSize: AppSize.font8, // mapped 9 to 8
                      color: context.txtSecondary,
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
              horizontal: AppSize.space8, vertical: AppSize.space12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                  text: payment.productName,
                  fontSize: AppSize.font10,
                  fontWeight: FontWeight.w600,
                  color: context.txtPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              AppText(
                  text: '${payment.quantity} ${payment.unit}',
                  fontSize: AppSize.font8, // mapped 9 to 8
                  color: context.txtSecondary),
            ],
          ),
        ),

        // Type
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space12),
          child: PayTypeBadge(type: payment.productType),
        ),

        // Amount
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space12),
          child: AppText(
            text: '\$${payment.amount.toStringAsFixed(0)}',
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w800,
            color: amountColor,
          ),
        ),

        // Status
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space12),
          child: PayStatusPill(status: payment.status),
        ),

        // Date
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space12),
          child: AppText(
            text: ctrlPayments.formatDate(payment.date),
            fontSize: AppSize.font10,
            color: context.txtSecondary,
          ),
        ),

        // Action
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space12),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => ctrlPayments.viewPayment(payment),
              child: AppContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space8, // mapped 10 to 8
                  vertical: AppSize.space4,
                ),
                backgroundColor: context.cardBg,
                borderRadius:
                    BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
                border: Border.all(
                    color: context.borderClr, width: AppSize.borderWidth1),
                child: AppText(
                  text: 'View',
                  fontSize: AppSize.font10,
                  fontWeight: FontWeight.w600,
                  color: context.txtPrimary,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SIDEBAR
// ─────────────────────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  final PaymentsCon ctrlPayments;
  const _Sidebar({required this.ctrlPayments});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280.0, // mapped to direct width 280
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSize.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue chart
            MonthlyRevenueChart(
              data: ctrlPayments.monthlyRevenue,
              maxAmount: ctrlPayments.maxMonthlyRevenue,
            ),
            const SizedBox(height: AppSize.space20),
            // Pending payments
            _pendingSection(context),
          ],
        ),
      ),
    );
  }

  Widget _pendingSection(BuildContext context) {
    return Obx(() {
      if (ctrlPayments.isLoading.value) {
        return const AppSkeletonListColumn(itemCount: 3);
      }
      final list = ctrlPayments.pendingPayments;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.access_time_rounded,
                size: AppSize.icon16, color: AppColors.textWarning),
            const SizedBox(width: AppSize.space4), // mapped 5 to 4
            AppText(
              text: 'Pending Payments',
              fontSize: AppSize.font10, // mapped 11 to 10
              fontWeight: FontWeight.w800,
              color: context.txtPrimary,
            ),
            const SizedBox(width: AppSize.space4), // mapped 5 to 4
            if (list.isNotEmpty)
              AppContainer(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.space8, vertical: 2),
                backgroundColor: AppColors.badgeWarningBg, // mapped 0xFFFFF7ED
                borderRadius: BorderRadius.circular(AppSize.radius20),
                child: AppText(
                  text: '${list.length}',
                  fontSize: AppSize.font8, // mapped 9 to 8
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWarning, // mapped 0xFF9A3412
                ),
              ),
          ]),
          const SizedBox(height: AppSize.space12), // mapped 10 to 12
          if (list.isEmpty)
            AppContainer(
              padding: const EdgeInsets.all(AppSize.space12),
              backgroundColor: AppColors.badgeSuccessBg,
              borderRadius: BorderRadius.circular(AppSize.radius12),
              child: const Row(children: [
                Icon(Icons.check_circle_outline,
                    size: AppSize.icon16, color: AppColors.iconEmeraldGreen),
                SizedBox(width: AppSize.space8),
                AppText(
                    text: 'All payments received!',
                    fontSize: AppSize.font10,
                    color: AppColors.textEmeraldGreen,
                    fontWeight: FontWeight.w600),
              ]),
            )
          else
            ...list.map((payment) => PendingPayCard(
                  payment: payment,
                  dateText: ctrlPayments.formatDate(payment.date),
                  dueDateText: payment.dueDate != null
                      ? ctrlPayments.formatDate(payment.dueDate!)
                      : 'N/A',
                  isReminderLoading:
                      ctrlPayments.remindingPaymentId.value == payment.id,
                  onReminder: () => ctrlPayments.sendReminder(payment),
                )),
        ],
      );
    });
  }
}
