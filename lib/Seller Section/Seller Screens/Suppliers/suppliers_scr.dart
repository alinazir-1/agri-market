import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Theme/app_theme.dart';
import '../../../Shared/Screens Common Widgets/screen_top_bar.dart';
import 'Supplier Widgets/widgets.dart';
import 'suppliers_con.dart';

class SuppliersScr extends StatelessWidget {
  final SuppliersCon c = Get.put(SuppliersCon());

  SuppliersScr({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.appBg,
        body: SafeArea(
          child: Column(
            children: [
              ScreenTopBar(
                title: 'Suppliers',
                subtitle: 'Manage your supply chain partners',
                searchController: c.searchController,
                onSearch: c.onSearch,
                searchHint: 'Search suppliers...',
              ),
              SuppStatRow(c: c),
              SuppFilterBar(c: c),
              Expanded(
                child: Obx(
                  () => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: SuppTable(c: c)),
                      if (c.selectedSupplier.value != null)
                        SuppDetailPanel(c: c),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
