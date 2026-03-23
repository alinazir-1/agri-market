import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import 'Customers Widgets/customer_side_bar.dart';
import 'Customers Widgets/customer_summary_card.dart';
import 'Customers Widgets/table_section.dart';
import 'Customers Widgets/top_bar_c.dart';
import 'customers_con.dart';

class CustomersScr extends StatelessWidget {
  final CustomersCon c = Get.put(CustomersCon());

  CustomersScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            TopBar(c: c),
            SummaryCards(c: c),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: TableSection(c: c)),
                  Sidebar(c: c),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
