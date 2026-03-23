import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Data/Models/order_model.dart';
import '../../../Data/Models/product_type_enums.dart';
import 'orders_con.dart';

class OrdersScr extends StatelessWidget {
  final OrdersCon ordersController = Get.put(OrdersCon());

  OrdersScr({super.key});

  // ── Tab labels ──────────────────────────────────────────────────────────────
  final List<String> _tabs = [
    'All',
    'Pending',
    'Confirmed',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  final List<String> _typeFilters = [
    'All Types',
    'Marketplace',
    'Live Auction',
    'Advance Booking',
  ];

  final List<String> _sortOptions = ['Latest', 'Oldest', 'Amount High'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(CSize.space24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(),
              const SizedBox(height: CSize.space20),
              _statsRow(),
              const SizedBox(height: CSize.space20),
              _tabs_(),
              const SizedBox(height: CSize.space12),
              _filters(),
              const SizedBox(height: CSize.space12),
              _ordersTable(),
              const SizedBox(height: CSize.space28),
              _sampleSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  TOP BAR
  // ════════════════════════════════════════════════════════════════════════════

  Widget _topBar() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Orders",
                style: TextStyle(
                  fontSize: CSize.font30XLarge,
                  fontWeight: FontWeight.w800,
                  color: CColors.textPrimary,
                ),
              ),
              SizedBox(height: CSize.space2),
              Text(
                "Manage all incoming orders and sample requests",
                style: TextStyle(
                  fontSize: CSize.font13Small,
                  color: CColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        // Search
        SizedBox(
          width: 240,
          height: 38,
          child: TextField(
            controller: ordersController.searchController,
            onChanged: ordersController.onSearch,
            style: const TextStyle(fontSize: 11, color: CColors.textPrimary),
            decoration: InputDecoration(
              hintText: "Search by order ID, buyer...",
              hintStyle: const TextStyle(
                fontSize: 11,
                color: CColors.textSecondary,
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: CSize.icon16Small,
                color: CColors.iconEmeraldGreen,
              ),
              filled: true,
              fillColor: CColors.backGroundWhite,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: CSize.space10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                borderSide: const BorderSide(color: CColors.borderGray),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CSize.radius24XLarge),
                borderSide: const BorderSide(color: CColors.borderGray),
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

        const SizedBox(width: CSize.space10),

        // Export button
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.download_outlined,
            size: CSize.icon16Small,
            color: CColors.iconEmeraldGreen,
          ),
          label: const Text(
            "Export",
            style: TextStyle(
              fontSize: CSize.font13Small,
              fontWeight: FontWeight.w600,
              color: CColors.textEmeraldGreen,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: CColors.borderGray),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: CSize.space16,
              vertical: CSize.space10,
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  STATS ROW
  // ════════════════════════════════════════════════════════════════════════════

  Widget _statsRow() {
    return Obx(
      () => Row(
        children: [
          _statCard(
            "Total Orders",
            "${ordersController.totalOrders}",
            "All time",
            CColors.backgroundEmerald100,
            CColors.textEmeraldGreen,
          ),
          const SizedBox(width: CSize.space12),
          _statCard(
            "Pending",
            "${ordersController.pendingOrders}",
            "Needs action",
            const Color(0xFFFFF7ED),
            const Color(0xFF9A3412),
          ),
          const SizedBox(width: CSize.space12),
          _statCard(
            "Processing",
            "${ordersController.processingOrders}",
            "In progress",
            const Color(0xFFDBEAFE),
            const Color(0xFF1E40AF),
          ),
          const SizedBox(width: CSize.space12),
          _statCard(
            "Revenue (Month)",
            "\$${ordersController.monthRevenue.toStringAsFixed(0)}",
            "+8.2%",
            CColors.backgroundEmerald100,
            CColors.textEmeraldGreen,
          ),
          const SizedBox(width: CSize.space12),
          _statCard(
            "Sample Requests",
            "${ordersController.sampleRequests.length}",
            "${ordersController.newSamples} new",
            const Color(0xFFFFF7ED),
            const Color(0xFF9A3412),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    String label,
    String value,
    String badge,
    Color badgeBg,
    Color badgeText,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(CSize.space14),
        decoration: BoxDecoration(
          color: CColors.backGroundWhite,
          borderRadius: BorderRadius.circular(CSize.radius20Large),
          border: Border.all(
            color: CColors.borderGray,
            width: CSize.borderWidth1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: CSize.font24Large,
                fontWeight: FontWeight.w800,
                color: CColors.textPrimary,
              ),
            ),
            const SizedBox(height: CSize.space2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: CColors.textSecondary,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: CSize.space5),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: CSize.space8,
                vertical: CSize.space2,
              ),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(CSize.radius20Large),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: badgeText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  TABS
  // ════════════════════════════════════════════════════════════════════════════

  Widget _tabs_() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(CSize.space4),
        decoration: BoxDecoration(
          color: CColors.backGroundWhite,
          borderRadius: BorderRadius.circular(CSize.radius20Large),
          border: Border.all(
            color: CColors.borderGray,
            width: CSize.borderWidth1,
          ),
        ),
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final isActive = ordersController.selectedTab.value == i;
            final count = i == 0
                ? ordersController.totalOrders
                : i == 1
                    ? ordersController.countByStatus(OrderStatus.pending)
                    : i == 2
                        ? ordersController.countByStatus(OrderStatus.confirmed)
                        : i == 3
                            ? ordersController
                                .countByStatus(OrderStatus.processing)
                            : i == 4
                                ? ordersController
                                    .countByStatus(OrderStatus.shipped)
                                : i == 5
                                    ? ordersController
                                        .countByStatus(OrderStatus.delivered)
                                    : ordersController
                                        .countByStatus(OrderStatus.cancelled);

            return Expanded(
              child: GestureDetector(
                onTap: () => ordersController.selectTab(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: CSize.space8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? CColors.backGroundEmeraldGreen
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(CSize.radius10Medium),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _tabs[i],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? CColors.textWhite
                              : CColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: CSize.space4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: CSize.space5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.white.withOpacity(0.25)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(
                            CSize.radius20Large,
                          ),
                        ),
                        child: Text(
                          "$count",
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: isActive
                                ? CColors.textWhite
                                : CColors.textSecondary,
                          ),
                        ),
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

  // ════════════════════════════════════════════════════════════════════════════
  //  FILTERS
  // ════════════════════════════════════════════════════════════════════════════

  Widget _filters() {
    return Obx(
      () => Row(
        children: [
          ..._typeFilters.map(
            (f) => Padding(
              padding: const EdgeInsets.only(right: CSize.space8),
              child: GestureDetector(
                onTap: () => ordersController.selectTypeFilter(f),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CSize.space12,
                    vertical: CSize.space5,
                  ),
                  decoration: BoxDecoration(
                    color: ordersController.selectedTypeFilter.value == f
                        ? CColors.backgroundEmerald100
                        : CColors.backGroundWhite,
                    border: Border.all(
                      color: ordersController.selectedTypeFilter.value == f
                          ? CColors.borderEmeraldGreen
                          : CColors.borderGray,
                      width: CSize.borderWidth1,
                    ),
                    borderRadius: BorderRadius.circular(CSize.radius20Large),
                  ),
                  child: Text(
                    f,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: ordersController.selectedTypeFilter.value == f
                          ? CColors.textEmeraldGreen
                          : CColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          // Sort dropdown
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: CSize.space12,
              vertical: CSize.space5,
            ),
            decoration: BoxDecoration(
              color: CColors.backGroundWhite,
              border: Border.all(
                color: CColors.borderGray,
                width: CSize.borderWidth1,
              ),
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: ordersController.sortBy.value,
                isDense: true,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: CColors.textPrimary,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  size: CSize.icon16Small,
                  color: CColors.iconEmeraldGreen,
                ),
                items: _sortOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) =>
                    ordersController.selectSort(val ?? 'Latest'),
              ),
            ),
          ),

          const SizedBox(width: CSize.space8),

          // Date range button
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.calendar_today_outlined,
              size: CSize.icon16Small,
              color: CColors.iconEmeraldGreen,
            ),
            label: const Text(
              "Date Range",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: CColors.textEmeraldGreen,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: CColors.borderGray),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: CSize.space12,
                vertical: CSize.space5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  ORDERS TABLE
  // ════════════════════════════════════════════════════════════════════════════

  Widget _ordersTable() {
    return Container(
      decoration: BoxDecoration(
        color: CColors.backGroundWhite,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(
          color: CColors.borderGray,
          width: CSize.borderWidth1,
        ),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: CSize.space16,
              vertical: CSize.space10,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(CSize.radius20Large),
              ),
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: const Row(
              children: [
                Expanded(flex: 3, child: _TH("Product")),
                Expanded(flex: 2, child: _TH("Buyer")),
                Expanded(flex: 2, child: _TH("Qty & Amount")),
                Expanded(flex: 2, child: _TH("Order Status")),
                Expanded(flex: 2, child: _TH("Payment")),
                Expanded(flex: 2, child: _TH("Order Date")),
                Expanded(flex: 2, child: _TH("Actions")),
              ],
            ),
          ),

          // Table rows
          Obx(() {
            final orders = ordersController.filteredOrders;
            if (orders.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(CSize.space32),
                child: Center(
                  child: Text(
                    "No orders found",
                    style: TextStyle(
                      color: CColors.textSecondary,
                      fontSize: CSize.font13Small,
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: orders.map((order) => _orderRow(order)).toList(),
            );
          }),

          // Pagination
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: CSize.space16,
              vertical: CSize.space12,
            ),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(CSize.radius20Large),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    "Showing ${ordersController.filteredOrders.length} of ${ordersController.totalOrders} orders",
                    style: const TextStyle(
                      fontSize: 10,
                      color: CColors.textSecondary,
                    ),
                  ),
                ),
                Row(
                  children: [
                    _pgBtn("‹", false),
                    _pgBtn("1", true),
                    _pgBtn("2", false),
                    _pgBtn("3", false),
                    _pgBtn("›", false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderRow(OrderModel order) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CSize.space16,
        vertical: CSize.space12,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF1F5F9), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Product
          Expanded(
            flex: 3,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(CSize.radius10Medium),
                  child: Image.asset(
                    order.productImage,
                    width: 38,
                    height: 38,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 38,
                      height: 38,
                      color: CColors.backgroundEmerald100,
                      child: const Icon(
                        Icons.image_outlined,
                        size: CSize.icon16Small,
                        color: CColors.iconEmeraldGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: CSize.space10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.productName,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: CColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "#${order.orderId} · Grade ${order.productGrade}",
                        style: const TextStyle(
                          fontSize: 9,
                          color: CColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: CSize.space2),
                      _productTypeBadge(order.productType),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Buyer
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.buyerName,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: CColors.textPrimary,
                  ),
                ),
                Text(
                  "📍 ${order.buyerLocation}",
                  style: const TextStyle(
                    fontSize: 9,
                    color: CColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Qty & Amount
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\$${order.totalAmount.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: CColors.textEmeraldGreen,
                  ),
                ),
                Text(
                  "${order.quantity.toStringAsFixed(0)} ${order.unit} · \$${order.pricePerUnit}/${order.unit}",
                  style: const TextStyle(
                    fontSize: 9,
                    color: CColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Order Status
          Expanded(flex: 2, child: _orderStatusPill(order.orderStatus)),

          // Payment
          Expanded(flex: 2, child: _paymentPill(order.orderPaymentStatus)),

          // Date
          Expanded(
            flex: 2,
            child: Text(
              "${order.orderDate.day} ${_month(order.orderDate.month)} ${order.orderDate.year}",
              style: const TextStyle(
                fontSize: 10,
                color: CColors.textSecondary,
              ),
            ),
          ),

          // Actions
          Expanded(flex: 2, child: _actionButtons(order)),
        ],
      ),
    );
  }

  Widget _actionButtons(OrderModel order) {
    return Row(
      children: [
        // View
        _iconBtn(
          Icons.remove_red_eye_outlined,
          CColors.iconEmeraldGreen,
          CColors.backgroundEmerald100,
          () {},
        ),
        const SizedBox(width: CSize.space4),

        // Status action
        if (order.orderStatus == OrderStatus.pending)
          _iconBtn(
            Icons.check_circle_outline,
            CColors.iconEmeraldGreen,
            CColors.backgroundEmerald100,
            () => ordersController.updateOrderStatus(
              order.orderId,
              OrderStatus.confirmed,
            ),
          ),
        if (order.orderStatus == OrderStatus.confirmed)
          _iconBtn(
            Icons.settings_outlined,
            CColors.iconEmeraldGreen,
            CColors.backgroundEmerald100,
            () => ordersController.updateOrderStatus(
              order.orderId,
              OrderStatus.processing,
            ),
          ),
        if (order.orderStatus == OrderStatus.processing)
          _iconBtn(
            Icons.local_shipping_outlined,
            CColors.iconEmeraldGreen,
            CColors.backgroundEmerald100,
            () => ordersController.updateOrderStatus(
              order.orderId,
              OrderStatus.shipped,
            ),
          ),
        if (order.orderStatus == OrderStatus.shipped)
          _iconBtn(
            Icons.location_on_outlined,
            CColors.iconEmeraldGreen,
            CColors.backgroundEmerald100,
            () {},
          ),
        if (order.orderStatus == OrderStatus.delivered)
          _iconBtn(
            Icons.receipt_long_outlined,
            CColors.iconEmeraldGreen,
            CColors.backgroundEmerald100,
            () {},
          ),

        const SizedBox(width: CSize.space4),

        // Cancel
        if (order.orderStatus != OrderStatus.delivered &&
            order.orderStatus != OrderStatus.cancelled)
          _iconBtn(
            Icons.cancel_outlined,
            CColors.iconError,
            CColors.backgroundErrorLight,
            () => ordersController.updateOrderStatus(
              order.orderId,
              OrderStatus.cancelled,
            ),
          ),
      ],
    );
  }

  Widget _iconBtn(
    IconData icon,
    Color iconColor,
    Color bg,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CSize.radius5Small),
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(CSize.radius5Small),
          border: Border.all(
            color: CColors.borderGray,
            width: CSize.borderWidth05,
          ),
        ),
        child: Icon(icon, size: CSize.icon16Small, color: iconColor),
      ),
    );
  }

  Widget _pgBtn(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(left: CSize.space4),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color:
            isActive ? CColors.backGroundEmeraldGreen : CColors.backGroundWhite,
        borderRadius: BorderRadius.circular(CSize.radius5Small),
        border: Border.all(
          color: isActive ? CColors.borderEmeraldGreen : CColors.borderGray,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isActive ? CColors.textWhite : CColors.textPrimary,
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  SAMPLE REQUESTS
  // ════════════════════════════════════════════════════════════════════════════

  Widget _sampleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.bolt_outlined,
              size: CSize.icon16Small,
              color: CColors.iconEmeraldGreen,
            ),
            const SizedBox(width: CSize.space8),
            const Text(
              "Sample Requests",
              style: TextStyle(
                fontSize: CSize.font16Medium,
                fontWeight: FontWeight.w800,
                color: CColors.textPrimary,
              ),
            ),
            const SizedBox(width: CSize.space8),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: CSize.space8,
                  vertical: CSize.space2,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(CSize.radius20Large),
                ),
                child: Text(
                  "${ordersController.newSamples} new",
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9A3412),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: CSize.space12),
        Obx(
          () => GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ordersController.sampleRequests.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: CSize.space12,
              mainAxisSpacing: CSize.space12,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, i) =>
                _sampleCard(ordersController.sampleRequests[i]),
          ),
        ),
      ],
    );
  }

  Widget _sampleCard(SampleRequestModel s) {
    return Container(
      padding: const EdgeInsets.all(CSize.space14),
      decoration: BoxDecoration(
        color: CColors.backGroundWhite,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(
          color: CColors.borderGray,
          width: CSize.borderWidth1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.productName,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: CColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "#${s.sampleId} · ${s.requestDate.day} ${_month(s.requestDate.month)}",
                      style: const TextStyle(
                        fontSize: 9,
                        color: CColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _sampleStatusPill(s.status),
            ],
          ),

          const SizedBox(height: CSize.space8),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: CSize.space8),

          // Details
          _sampleRow("Buyer", s.buyerName),
          _sampleRow(
            "Qty",
            "${s.sampleQty.toStringAsFixed(0)} ${s.sampleUnit}",
          ),
          _sampleRow(
            "Price",
            s.samplePrice == 0
                ? "Free"
                : "\$${s.samplePrice.toStringAsFixed(2)}",
          ),
          _sampleRow(
            "Delivery",
            s.isDeliveryBySeller ? "Seller pays" : "Buyer pays",
          ),
          _sampleRow("Location", s.buyerLocation),

          const Spacer(),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (s.status == SampleStatus.newRequest)
                      ordersController.updateSampleStatus(
                        s.sampleId,
                        SampleStatus.accepted,
                      );
                    if (s.status == SampleStatus.accepted)
                      ordersController.updateSampleStatus(
                        s.sampleId,
                        SampleStatus.dispatched,
                      );
                    if (s.status == SampleStatus.dispatched)
                      ordersController.updateSampleStatus(
                        s.sampleId,
                        SampleStatus.delivered,
                      );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CColors.backGroundEmeraldGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(CSize.radius10Medium),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: CSize.space5),
                    elevation: 0,
                  ),
                  child: Text(
                    s.status == SampleStatus.newRequest
                        ? "Accept"
                        : s.status == SampleStatus.accepted
                            ? "Dispatch"
                            : s.status == SampleStatus.dispatched
                                ? "Delivered"
                                : "Done",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: CColors.textWhite,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: CSize.space8),
              if (s.status == SampleStatus.newRequest ||
                  s.status == SampleStatus.accepted)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (s.status == SampleStatus.newRequest)
                        ordersController.updateSampleStatus(
                          s.sampleId,
                          SampleStatus.rejected,
                        );
                      if (s.status == SampleStatus.accepted)
                        ordersController.updateSampleStatus(
                          s.sampleId,
                          SampleStatus.cancelled,
                        );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: CColors.borderError),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          CSize.radius10Medium,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: CSize.space5,
                      ),
                    ),
                    child: Text(
                      s.status == SampleStatus.newRequest ? "Reject" : "Cancel",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: CColors.textError,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sampleRow(String key, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: CColors.textSecondary,
            ),
          ),
          Text(
            val,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: CColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  HELPERS — Status Pills + Badges
  // ════════════════════════════════════════════════════════════════════════════

  Widget _orderStatusPill(OrderStatus status) {
    final Map<OrderStatus, List<dynamic>> cfg = {
      OrderStatus.pending: [
        const Color(0xFFFFF7ED),
        const Color(0xFF9A3412),
        const Color(0xFFF97316),
      ],
      OrderStatus.confirmed: [
        const Color(0xFFDBEAFE),
        const Color(0xFF1E40AF),
        const Color(0xFF3B82F6),
      ],
      OrderStatus.processing: [
        const Color(0xFFFEF9C3),
        const Color(0xFF854D0E),
        const Color(0xFFEAB308),
      ],
      OrderStatus.shipped: [
        const Color(0xFFEDE9FE),
        const Color(0xFF5B21B6),
        const Color(0xFF8B5CF6),
      ],
      OrderStatus.delivered: [
        CColors.backgroundEmerald100,
        CColors.textEmeraldGreen,
        CColors.backGroundEmeraldGreen,
      ],
      OrderStatus.cancelled: [
        const Color(0xFFFEE2E2),
        const Color(0xFF991B1B),
        const Color(0xFFEF4444),
      ],
    };
    final c = cfg[status]!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: CSize.space8,
            vertical: CSize.space2,
          ),
          decoration: BoxDecoration(
            color: c[0],
            borderRadius: BorderRadius.circular(CSize.radius20Large),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(color: c[2], shape: BoxShape.circle),
              ),
              const SizedBox(width: CSize.space4),
              Text(
                status.name[0].toUpperCase() + status.name.substring(1),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: c[1],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentPill(OrderPaymentStatus status) {
    final Map<OrderPaymentStatus, List<Color>> cfg = {
      OrderPaymentStatus.paid: [
        CColors.backgroundEmerald100,
        CColors.textEmeraldGreen,
      ],
      OrderPaymentStatus.pending: [
        const Color(0xFFFFF7ED),
        const Color(0xFF9A3412)
      ],
      OrderPaymentStatus.partial: [
        const Color(0xFFDBEAFE),
        const Color(0xFF1E40AF)
      ],
    };
    final c = cfg[status]!;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CSize.space8,
        vertical: CSize.space2,
      ),
      decoration: BoxDecoration(
        color: c[0],
        borderRadius: BorderRadius.circular(CSize.radius20Large),
      ),
      child: Text(
        status.name[0].toUpperCase() + status.name.substring(1),
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: c[1]),
      ),
    );
  }

  Widget _sampleStatusPill(SampleStatus status) {
    final Map<SampleStatus, List<Color>> cfg = {
      SampleStatus.newRequest: [
        const Color(0xFFFFF7ED),
        const Color(0xFF9A3412),
      ],
      SampleStatus.accepted: [const Color(0xFFDBEAFE), const Color(0xFF1E40AF)],
      SampleStatus.dispatched: [
        const Color(0xFFEDE9FE),
        const Color(0xFF5B21B6),
      ],
      SampleStatus.delivered: [
        CColors.backgroundEmerald100,
        CColors.textEmeraldGreen,
      ],
      SampleStatus.rejected: [const Color(0xFFFEE2E2), const Color(0xFF991B1B)],
      SampleStatus.cancelled: [const Color(0xFFF3F4F6), CColors.textSecondary],
    };
    final c = cfg[status]!;
    final label = status == SampleStatus.newRequest
        ? "New"
        : status.name[0].toUpperCase() + status.name.substring(1);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CSize.space8,
        vertical: CSize.space2,
      ),
      decoration: BoxDecoration(
        color: c[0],
        borderRadius: BorderRadius.circular(CSize.radius20Large),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: c[1]),
      ),
    );
  }

  Widget _productTypeBadge(ProductType type) {
    final Map<ProductType, List<Color>> cfg = {
      ProductType.marketplace: [
        const Color(0xFFDBEAFE),
        const Color(0xFF1E40AF),
      ],
      ProductType.liveAuction: [
        const Color(0xFFFEF9C3),
        const Color(0xFF854D0E),
      ],
      ProductType.advanceBooking: [
        const Color(0xFFEDE9FE),
        const Color(0xFF5B21B6),
      ],
    };
    final c = cfg[type] ?? [const Color(0xFFF3F4F6), CColors.textSecondary];
    final label = type == ProductType.marketplace
        ? "Marketplace"
        : type == ProductType.liveAuction
            ? "Live Auction"
            : "Adv. Booking";
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CSize.space5,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: c[0],
        borderRadius: BorderRadius.circular(CSize.radius5Small),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: c[1]),
      ),
    );
  }

  String _month(int m) => [
        '',
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
        'Dec',
      ][m];
}

// ── Table Header helper ───────────────────────────────────────────────────────

class _TH extends StatelessWidget {
  final String label;
  const _TH(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w800,
        color: CColors.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }
}
