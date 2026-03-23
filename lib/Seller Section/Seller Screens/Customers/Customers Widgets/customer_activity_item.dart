import 'package:flutter/cupertino.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/Customers Model/customer_activity_model.dart';

class CustomerActivityItem extends StatelessWidget {
  final CustomerActivity entry;

  const CustomerActivityItem({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: CSize.space8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF1F5F9), width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 3),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: entry.dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: CSize.space8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.message,
                  style: const TextStyle(
                    fontSize: 10,
                    color: CColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  entry.timeAgo,
                  style: const TextStyle(
                      fontSize: 9, color: CColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
