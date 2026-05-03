import 'package:agri_market/features/seller/customers/widgets/customer_side_bar.dart';
import 'package:agri_market/features/seller/customers/widgets/customer_summary_card.dart';
import 'package:agri_market/features/seller/customers/widgets/table_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/features/seller/customers/customers_con.dart';
import 'package:agri_market/shared/widgets/seller/screen_top_bar.dart';

class CustomersScr extends StatelessWidget {
  final CustomersCon ctrlCustomers = Get.put(CustomersCon(), permanent: true);

  CustomersScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: Column(
        children: [
          ScreenTopBar(
            title: 'Customers',
            subtitle: 'Manage your buyer relationships',
            searchController: ctrlCustomers.searchController,
            onSearch: ctrlCustomers.onSearch,
            searchHint: 'Search by name, email...',
          ),
          SummaryCards(ctrlCustomers: ctrlCustomers),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: TableSection(ctrlCustomers: ctrlCustomers)),
                CustomerSidebar(ctrlCustomers: ctrlCustomers),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
