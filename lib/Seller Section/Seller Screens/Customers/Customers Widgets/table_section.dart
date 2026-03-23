import 'package:agri_market/Seller%20Section/Seller%20Screens/Customers/Customers%20Widgets/customer_action_button.dart';
import 'package:agri_market/Seller%20Section/Seller%20Screens/Customers/Customers%20Widgets/customer_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/Customers Model/customer_model.dart';
import '../customers_con.dart';
import 'buy_type_badge.dart';
import 'customer_avatar.dart';
import 'customer_status_pill.dart';

class TableSection extends StatelessWidget {
  final CustomersCon c;
  const TableSection({super.key, required this.c});

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
    return Container(
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            'All Customers',
            style: TextStyle(
              fontSize: CSize.font13Small,
              fontWeight: FontWeight.w800,
              color: CColors.textPrimary,
            ),
          ),
          const Spacer(),
          Obx(() => Wrap(
                spacing: CSize.space5,
                children: [
                  CustomerFilterChip(
                    label: 'All',
                    isActive: c.filter.value == CustomerFilter.all,
                    onTap: () => c.setFilter(CustomerFilter.all),
                  ),
                  CustomerFilterChip(
                    label: 'Active',
                    isActive: c.filter.value == CustomerFilter.active,
                    onTap: () => c.setFilter(CustomerFilter.active),
                  ),
                  CustomerFilterChip(
                    label: 'Inactive',
                    isActive: c.filter.value == CustomerFilter.inactive,
                    onTap: () => c.setFilter(CustomerFilter.inactive),
                  ),
                  CustomerFilterChip(
                    label: 'VIP',
                    isActive: c.filter.value == CustomerFilter.vip,
                    onTap: () => c.setFilter(CustomerFilter.vip),
                    activeColor: const Color(0xFFFBBF24),
                    activeBorder: const Color(0xFFFBBF24),
                    inactiveBorder: const Color(0xFFFDE68A),
                    inactiveText: const Color(0xFF92400E),
                  ),
                ],
              )),
          const SizedBox(width: CSize.space12),
          // Sort dropdown
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
                  child: DropdownButton<CustomerSort>(
                    value: c.sort.value,
                    isDense: true,
                    style: const TextStyle(
                      fontSize: CSize.font10XSmall,
                      fontWeight: FontWeight.w600,
                      color: CColors.textPrimary,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: CSize.icon16Small,
                      color: CColors.iconEmeraldGreen,
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
                    onChanged: (val) => c.setSort(val ?? CustomerSort.latest),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _tableBody() {
    return Obx(() {
      final list = c.filteredCustomers;
      if (list.isEmpty) {
        return const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.people_alt_outlined,
                size: CSize.icon36XLarge, color: CColors.textSecondary),
            SizedBox(height: CSize.space12),
            Text('No customers found',
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
            // Header row
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
              children: _headers
                  .map((h) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: CSize.space8, vertical: CSize.space10),
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
            // Data rows
            ...list.map((customer) => _buildRow(customer)),
          ],
        ),
      );
    });
  }

  TableRow _buildRow(CustomerModel customer) {
    return TableRow(
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 0.5)),
      ),
      children: [
        // Customer
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Row(
            children: [
              CustomerAvatar(
                  initials: customer.initials, color: customer.avatarColor),
              const SizedBox(width: CSize.space8),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customer.name,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: CColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(customer.email,
                      style: const TextStyle(
                          fontSize: 9, color: CColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              )),
            ],
          ),
        ),

        // Location
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Text(customer.location,
              style: const TextStyle(fontSize: 10, color: CColors.textPrimary)),
        ),

        // Status
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: CustomerStatusPill(status: customer.status),
        ),

        // Bought From
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: BuyTypeBadge(type: customer.primaryBuyType),
        ),

        // Total Orders
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${customer.totalOrders}',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: CColors.textPrimary)),
              const Text('orders',
                  style: TextStyle(fontSize: 9, color: CColors.textSecondary)),
            ],
          ),
        ),

        // Total Spent
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Text(
            '\$${customer.totalSpent.toStringAsFixed(0)}',
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: CColors.textEmeraldGreen),
          ),
        ),

        // Last Order
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Text(_formatDate(customer.lastOrderDate),
              style:
                  const TextStyle(fontSize: 10, color: CColors.textSecondary)),
        ),

        // Actions
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space8, vertical: CSize.space10),
          child: Row(
            children: [
              CustomerActionButton(
                icon: Icons.remove_red_eye_outlined,
                iconColor: CColors.iconEmeraldGreen,
                hoverBg: CColors.backgroundEmerald100,
                hoverBorder: CColors.borderEmeraldGreen,
                onTap: () => c.viewCustomer(customer),
              ),
              const SizedBox(width: CSize.space4),
              CustomerActionButton(
                icon: Icons.chat_bubble_outline_rounded,
                iconColor: const Color(0xFF3B82F6),
                hoverBg: const Color(0xFFEFF6FF),
                hoverBorder: const Color(0xFF93C5FD),
                onTap: () => c.messageCustomer(customer),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
