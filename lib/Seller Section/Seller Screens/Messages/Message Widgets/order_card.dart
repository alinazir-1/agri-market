// ── 3. Order Card Widget (inside bubble) ────────────────────────────────────

import 'package:flutter/cupertino.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/message_model.dart';

class OrderCard extends StatelessWidget {
  final OrderCardData data;

  const OrderCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: CSize.space8),
      padding: const EdgeInsets.all(CSize.space8),
      decoration: BoxDecoration(
        color: CColors.backgroundEmerald100,
        borderRadius: BorderRadius.circular(CSize.radius10Medium),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order ${data.orderId}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: CColors.textEmeraldGreen,
            ),
          ),
          const SizedBox(height: CSize.space4),
          _orderRow('Product', data.productName),
          _orderRow('Qty', data.quantity),
          _orderRow('Total', data.total),
        ],
      ),
    );
  }

  Widget _orderRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 9, color: CColors.textSecondary)),
          Text(value,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: CColors.textPrimary)),
        ],
      ),
    );
  }
}
