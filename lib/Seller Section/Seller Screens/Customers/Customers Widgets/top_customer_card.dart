import 'package:flutter/cupertino.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/Customers Model/customer_model.dart';
import 'customer_avatar.dart';

class TopCustomerCard extends StatelessWidget {
  final CustomerModel customer;

  const TopCustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: CSize.space8),
      padding: const EdgeInsets.all(CSize.space10),
      decoration: BoxDecoration(
        color: CColors.backGroundWhite,
        borderRadius: BorderRadius.circular(CSize.radius10Medium),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: CSize.borderWidth1,
        ),
      ),
      child: Row(
        children: [
          CustomerAvatar(
              initials: customer.initials,
              color: customer.avatarColor,
              size: 32),
          const SizedBox(width: CSize.space10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: CColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${customer.totalOrders} orders · ${customer.location}',
                  style: const TextStyle(
                      fontSize: 9, color: CColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            '\$${(customer.totalSpent / 1000).toStringAsFixed(1)}k',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: CColors.textEmeraldGreen,
            ),
          ),
        ],
      ),
    );
  }
}
