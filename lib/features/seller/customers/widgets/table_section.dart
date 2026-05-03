import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/customer_model.dart';
import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:agri_market/features/seller/customers/customers_con.dart';
import 'package:agri_market/features/seller/customers/widgets/buy_type_badge.dart';
import 'package:agri_market/features/seller/customers/widgets/customer_avatar.dart';
import 'package:agri_market/features/seller/customers/widgets/customer_status_pill.dart';
import 'package:agri_market/features/seller/customers/widgets/customer_action_button.dart';
import 'package:agri_market/features/seller/customers/add_customer/add_customer_dialog.dart';
import 'package:agri_market/shared/widgets/seller/screen_filter_chip.dart';
import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_text.dart';

class TableSection extends StatelessWidget {
  final CustomersCon ctrlCustomers;
  const TableSection({super.key, required this.ctrlCustomers});

  static const List<String> _headers = [
    'Customer',
    'Location',
    'Status',
    'Bought From',
    'Total Orders',
    'Total Spent',
    'Last Order',
    'Actions',
  ];

  static const Map<int, TableColumnWidth> _colWidths = {
    0: FlexColumnWidth(3),
    1: FlexColumnWidth(1.5),
    2: FlexColumnWidth(1.5),
    3: FlexColumnWidth(1.5),
    4: FlexColumnWidth(1.2),
    5: FlexColumnWidth(1.5),
    6: FlexColumnWidth(1.5),
    7: FlexColumnWidth(1.5),
  };

  String _formatDate(DateTime d) {
    const months = [
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
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      border: const Border(right: BorderSide(color: AppColors.borderLight)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tableHeader(context),
          Expanded(child: _tableBody()),
        ],
      ),
    );
  }

  Widget _tableHeader(BuildContext context) {
    /// 💀🔥 ---------------- Customer Filter Header ----------------
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSize.space20,
        AppSize.space16,
        AppSize.space20,
        AppSize.space12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => Wrap(
                  spacing: AppSize.space4,
                  runSpacing: AppSize.space4,
                  children: [
                    ScreenFilterChip(
                      label: 'All',
                      isActive: ctrlCustomers.filter.value == CustomerFilter.all,
                      onTap: () => ctrlCustomers.setFilter(CustomerFilter.all),
                    ),
                    ScreenFilterChip(
                      label: 'Active',
                      isActive:
                          ctrlCustomers.filter.value == CustomerFilter.active,
                      onTap: () => ctrlCustomers.setFilter(CustomerFilter.active),
                    ),
                    ScreenFilterChip(
                      label: 'Inactive',
                      isActive:
                          ctrlCustomers.filter.value == CustomerFilter.inactive,
                      onTap: () =>
                          ctrlCustomers.setFilter(CustomerFilter.inactive),
                    ),
                    ScreenFilterChip(
                      label: 'VIP',
                      isActive: ctrlCustomers.filter.value == CustomerFilter.vip,
                      onTap: () => ctrlCustomers.setFilter(CustomerFilter.vip),
                      activeColor: AppColors.textWarning,
                      activeBorder: AppColors.textWarning,
                      inactiveBorder: AppColors.badgeWarningBg,
                      inactiveText: AppColors.textWarning,
                    ),
                  ],
                )),
          ),
          const SizedBox(width: AppSize.space12),
          /// 💀🔥 ---------------- Add Customer Action ----------------
          _CustomerActionButton(onTap: () => showAddCustomerDialog(context)),
          const SizedBox(width: AppSize.space12),
          Obx(() => AppContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space12,
                  vertical: AppSize.space4,
                ),
                backgroundColor: AppColors.backGroundWhite,
                borderRadius: BorderRadius.circular(AppSize.radius8),
                border: Border.all(color: AppColors.borderLight),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<CustomerSort>(
                    value: ctrlCustomers.sort.value,
                    isDense: true,
                    style: const TextStyle(
                      fontSize: AppSize.font10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: AppSize.icon16,
                      color: AppColors.iconEmeraldGreen,
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: CustomerSort.latest,
                          child: Text('Sort: Latest')),
                      DropdownMenuItem(
                          value: CustomerSort.oldest,
                          child: Text('Sort: Oldest')),
                      DropdownMenuItem(
                          value: CustomerSort.highestSpent,
                          child: Text('Highest Spent')),
                      DropdownMenuItem(
                          value: CustomerSort.mostOrders,
                          child: Text('Most Orders')),
                    ],
                    onChanged: (val) =>
                        ctrlCustomers.setSort(val ?? CustomerSort.latest),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _tableBody() {
    return Obx(() {
      if (ctrlCustomers.isLoading.value) {
        return const AppSkeletonListColumn();
      }
      final list = ctrlCustomers.filteredCustomers;
      if (list.isEmpty) {
        return const AppEmptyListState(
          message: 'No customers found',
          icon: Icons.people_alt_outlined,
        );
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSize.space20),
        child: Table(
          columnWidths: _colWidths,
          children: [
            TableRow(
              decoration:
                  const BoxDecoration(color: AppColors.backgroundSurface),
              children: _headers
                  .map((h) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.space8,
                            vertical: AppSize.space12),
                        child: AppText(
                          text: h.toUpperCase(),
                          fontSize: AppSize.font8,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ))
                  .toList(),
            ),
            ...list.map((customer) => _buildRow(customer)),
          ],
        ),
      );
    });
  }

  TableRow _buildRow(CustomerModel customer) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(color: AppColors.backgroundDivider, width: 0.5)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space12),
          child: Row(
            children: [
              CustomerAvatar(
                  initials: customer.initials, avatarHex: customer.avatarHex),
              const SizedBox(width: AppSize.space8),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                      text: customer.name,
                      fontSize: AppSize.font12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  AppText(
                      text: customer.email,
                      fontSize: AppSize.font10,
                      color: AppColors.textSecondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space12),
          child: AppText(
              text: customer.location,
              fontSize: AppSize.font10,
              color: AppColors.textPrimary),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space12),
          child: CustomerStatusPill(status: customer.status),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space12),
          child: BuyTypeBadge(type: customer.primaryBuyType),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                  text: '${customer.totalOrders}',
                  fontSize: AppSize.font12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
              const AppText(
                  text: 'orders',
                  fontSize: AppSize.font10,
                  color: AppColors.textSecondary),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space12),
          child: AppText(
            text: '\$${customer.totalSpent.toStringAsFixed(0)}',
            fontSize: AppSize.font12,
            fontWeight: FontWeight.w700,
            color: AppColors.textEmeraldGreen,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space12),
          child: AppText(
              text: _formatDate(customer.lastOrderDate),
              fontSize: AppSize.font10,
              color: AppColors.textSecondary),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space8, vertical: AppSize.space12),
          child: Row(
            children: [
              CustomerActionButton(
                icon: Icons.remove_red_eye_outlined,
                iconColor: AppColors.iconEmeraldGreen,
                hoverBg: AppColors.badgeSuccessBg,
                hoverBorder: AppColors.borderEmeraldGreen,
                onTap: () => ctrlCustomers.viewCustomer(customer),
              ),
              const SizedBox(width: AppSize.space4),
              CustomerActionButton(
                icon: Icons.chat_bubble_outline_rounded,
                iconColor: AppColors.textInfo,
                hoverBg: AppColors.badgeInfoBg,
                hoverBorder: AppColors.textInfo, onTap: () {},
                // onTap: () => ctrlCustomers.messageCustomer(customer),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 💀🔥 ---------------- Add Customer Hover Button ----------------
class _CustomerActionButton extends StatelessWidget {
  final VoidCallback onTap;
  _CustomerActionButton({required this.onTap});

  final RxBool _isHovered = false.obs;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Obx(() => AppContainer(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: AppSize.space16),
              backgroundColor: _isHovered.value
                  ? AppColors.textEmeraldGreen
                  : AppColors.emeraldGreen,
              borderRadius: BorderRadius.circular(AppSize.radius8),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded,
                      size: AppSize.icon16, color: AppColors.iconWhite),
                  SizedBox(width: AppSize.space4),
                  AppText(
                      text: 'Add Customer',
                      fontSize: AppSize.font10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite),
                ],
              ),
            )),
      ),
    );
  }
}
