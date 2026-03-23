// ── 8. Alert Card ────────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';

class InvAlertCard extends StatelessWidget {
  final String name;
  final String detail;
  final String stockText;
  final bool isOut;

  const InvAlertCard({
    super.key,
    required this.name,
    required this.detail,
    required this.stockText,
    required this.isOut,
  });

  @override
  Widget build(BuildContext context) {
    final Color border =
        isOut ? const Color(0xFFFCA5A5) : const Color(0xFFFED7AA);
    final Color bg = isOut ? const Color(0xFFFEE2E2) : const Color(0xFFFFF7ED);
    final Color textClr =
        isOut ? const Color(0xFF991B1B) : const Color(0xFFB45309);
    return Container(
      margin: const EdgeInsets.only(bottom: CSize.space8),
      padding: const EdgeInsets.all(CSize.space10),
      decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(CSize.radius10Medium),
          border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: CColors.textPrimary)),
          const SizedBox(height: 2),
          Text(detail,
              style:
                  const TextStyle(fontSize: 9, color: CColors.textSecondary)),
          const SizedBox(height: CSize.space4),
          Text(stockText,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w700, color: textClr)),
        ],
      ),
    );
  }
}
