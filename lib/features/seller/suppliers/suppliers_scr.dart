// lib/features/seller/suppliers/suppliers_scr.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/shared/widgets/seller/screen_top_bar.dart';
import 'package:agri_market/features/seller/suppliers/suppliers_con.dart';
import 'package:agri_market/features/seller/suppliers/widgets/supplier_components.dart';

class SuppliersScr extends StatelessWidget {
  final SuppliersCon c = Get.put(SuppliersCon(), permanent: true);

  SuppliersScr({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.appBg,
        body: Column(
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: SuppTable(c: c)),
                  Obx(() {
                    if (c.selectedSupplier.value == null)
                      return const SizedBox.shrink();
                    return SuppDetailPanel(c: c);
                  }),
                ],
              ),
            ),
          ],
        ),
      );
}
