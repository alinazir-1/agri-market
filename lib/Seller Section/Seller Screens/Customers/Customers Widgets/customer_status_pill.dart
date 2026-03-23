// ── 2. Customer Status Pill ──────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/Customers Model/customer_model.dart';

class CustomerStatusPill extends StatelessWidget {
  final CustomerStatus status;

  const CustomerStatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color text;
    final String label;

    switch (status) {
      case CustomerStatus.active:
        bg = CColors.backgroundEmerald100;
        text = CColors.textEmeraldGreen;
        label = 'Active';
        break;
      case CustomerStatus.vip:
        bg = const Color(0xFFFEF9C3);
        text = const Color(0xFF854D0E);
        label = 'VIP';
        break;
      case CustomerStatus.inactive:
        bg = const Color(0xFFF3F4F6);
        text = CColors.textSecondary;
        label = 'Inactive';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CSize.space8,
        vertical: CSize.space2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: text,
        ),
      ),
    );
  }
}
