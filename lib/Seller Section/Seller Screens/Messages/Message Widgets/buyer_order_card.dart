// ── 7. Recent Order Card (in buyer info panel) ────────────────────────────────

import 'package:flutter/cupertino.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/message_model.dart';

class BuyerOrderCard extends StatelessWidget {
  final RecentOrderInfo order;

  const BuyerOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: CSize.space8),
      padding: const EdgeInsets.all(CSize.space8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(CSize.radius10Medium),
        border: Border.all(
            color: const Color(0xFFE2E8F0), width: CSize.borderWidth1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  order.productName,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: CColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: CSize.space5,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: order.isDelivered
                      ? const Color(0xFFDBEAFE)
                      : CColors.backgroundEmerald100,
                  borderRadius: BorderRadius.circular(CSize.radius20Large),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: order.isDelivered
                        ? const Color(0xFF1E40AF)
                        : CColors.textEmeraldGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: CSize.space2),
          Text(
            '${order.date} · ${order.amount}',
            style: const TextStyle(fontSize: 9, color: CColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
