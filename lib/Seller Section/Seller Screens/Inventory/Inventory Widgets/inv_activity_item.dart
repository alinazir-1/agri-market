// ── 9. Activity Item ─────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../inventory_con.dart';

class InvActivityItem extends StatelessWidget {
  final ActivityEntry entry;

  const InvActivityItem({super.key, required this.entry});

  Color get _dotColor {
    switch (entry.type) {
      case ActivityType.restock:
        return CColors.backGroundEmeraldGreen;
      case ActivityType.outOfStock:
        return CColors.borderError;
      case ActivityType.lowStock:
        return CColors.backGroundOrange;
      case ActivityType.booking:
        return const Color(0xFF3B82F6);
      default:
        return CColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: CSize.space8),
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 0.5))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 3),
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: _dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: CSize.space8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.message,
                    style: const TextStyle(
                        fontSize: 10, color: CColors.textPrimary, height: 1.4)),
                const SizedBox(height: 2),
                Text(entry.timeAgo,
                    style: const TextStyle(
                        fontSize: 9, color: CColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
