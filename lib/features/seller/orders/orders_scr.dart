// lib/features/seller/orders/orders_scr.dart

import 'package:agri_market/features/seller/orders/widgets/order_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/shared/widgets/seller/screen_top_bar.dart';
import 'package:agri_market/features/seller/orders/orders_con.dart';

// ─── OrdersScr ───────────────────────────────────────────────────────────────
class OrdersScr extends StatelessWidget {
  final OrdersCon c = Get.put(OrdersCon(), permanent: true);

  OrdersScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: Column(
        children: [
          ScreenTopBar(
            title: 'Orders',
            subtitle: 'Manage incoming orders and sample requests',
            searchController: c.searchController,
            onSearch: c.onSearch,
            searchHint: 'Search by order ID, product, buyer...',
          ),
          OrdStatRow(c: c),
          OrdMainTabs(c: c),
          Expanded(
            child: Obx(
              () => c.mainTabIndex.value == 0
                  ? _OrdersTab(c: c)
                  : _SamplesTab(c: c),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── _OrdersTab ──────────────────────────────────────────────────────────────
class _OrdersTab extends StatelessWidget {
  final OrdersCon c;
  const _OrdersTab({required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OrdStatusTabs(c: c),
        OrdFilterBar(c: c),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: OrdList(c: c)),
              Obx(() {
                if (c.selectedOrder.value == null)
                  return const SizedBox.shrink();
                return OrdDetailPanel(c: c);
              }),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── _SamplesTab ─────────────────────────────────────────────────────────────
class _SamplesTab extends StatelessWidget {
  final OrdersCon c;
  const _SamplesTab({required this.c});

  @override
  Widget build(BuildContext context) {
    return OrdSamplesList(c: c);
  }
}
