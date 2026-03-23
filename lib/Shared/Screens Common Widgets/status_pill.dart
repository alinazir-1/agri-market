// ── 4. Stock Status Pill ─────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';

import '../../Core/Constant/colors.dart';
import '../../Core/Constant/sizes.dart';

class StatusPill extends StatelessWidget {
  final bool isOut;
  final bool isLow;

  const StatusPill({super.key, required this.isOut, required this.isLow});

  @override
  Widget build(BuildContext context) {
    final Color bg = isOut
        ? const Color(0xFFFEE2E2)
        : isLow
            ? const Color(0xFFFFF7ED)
            : CColors.backgroundEmerald100;
    final Color text = isOut
        ? const Color(0xFF991B1B)
        : isLow
            ? const Color(0xFF9A3412)
            : CColors.textEmeraldGreen;
    final String label = isOut
        ? 'Out of Stock'
        : isLow
            ? 'Low Stock'
            : 'In Stock';
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: CSize.space8, vertical: CSize.space2),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(CSize.radius20Large)),
      child: Text(label,
          style:
              TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: text)),
    );
  }
}
