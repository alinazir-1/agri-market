// ── 5. Conv Tab Chip ─────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';

class ConvTabChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const ConvTabChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: CSize.space12,
          vertical: CSize.space4,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? CColors.backGroundEmeraldGreen
              : CColors.backGroundWhite,
          borderRadius: BorderRadius.circular(CSize.radius20Large),
          border: Border.all(
            color:
                isActive ? CColors.borderEmeraldGreen : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isActive ? CColors.textWhite : CColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
