// ── 6. Restock Button ────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';

class InvRestockButton extends StatelessWidget {
  final bool isOut;
  final bool isLow;
  final VoidCallback onTap;

  const InvRestockButton(
      {super.key,
      required this.isOut,
      required this.isLow,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color bg = isOut
        ? CColors.borderError
        : isLow
            ? CColors.backGroundOrange
            : CColors.backGroundEmeraldGreen;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: CSize.space5, vertical: CSize.space4),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(CSize.radius5Small)),
        child: const Text('+ Restock',
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: CColors.textWhite)),
      ),
    );
  }
}
