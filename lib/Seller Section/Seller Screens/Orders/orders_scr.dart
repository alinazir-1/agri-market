import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Theme/app_theme.dart';
import '../../../Shared/Screens Common Widgets/screen_top_bar.dart';
import 'Orders Widgets/widgets.dart';
import 'orders_con.dart';

class OrdersScr extends StatelessWidget {
  final OrdersCon c = Get.put(OrdersCon());

  OrdersScr({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.appBg,
        body: SafeArea(
          child: Column(
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
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
//  ORDERS TAB CONTENT
// ─────────────────────────────────────────────────────────────────────────────

class _OrdersTab extends StatelessWidget {
  final OrdersCon c;
  const _OrdersTab({required this.c});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          OrdStatusTabs(c: c),
          OrdFilterBar(c: c),
          Expanded(
            child: Obx(
              () => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: OrdList(c: c)),
                  if (c.selectedOrder.value != null) OrdDetailPanel(c: c),
                ],
              ),
            ),
          ),
        ],
      );
}

// ─────────────────────────────────────────────────────────────────────────────
//  SAMPLES TAB CONTENT
// ─────────────────────────────────────────────────────────────────────────────

class _SamplesTab extends StatelessWidget {
  final OrdersCon c;
  const _SamplesTab({required this.c});

  @override
  Widget build(BuildContext context) => OrdSamplesList(c: c);
}
