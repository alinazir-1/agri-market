import 'package:flutter/cupertino.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';

class CustomerFilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color? activeColor;
  final Color? activeBorder;
  final Color? inactiveBorder;
  final Color? inactiveText;

  const CustomerFilterChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.activeColor,
    this.activeBorder,
    this.inactiveBorder,
    this.inactiveText,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = isActive
        ? (activeColor ?? CColors.backGroundEmeraldGreen)
        : CColors.backGroundWhite;
    final Color border = isActive
        ? (activeBorder ?? CColors.borderEmeraldGreen)
        : (inactiveBorder ?? const Color(0xFFE2E8F0));
    final Color text =
        isActive ? CColors.textWhite : (inactiveText ?? CColors.textSecondary);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: CSize.space12,
          vertical: CSize.space4,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(CSize.radius20Large),
          border: Border.all(color: border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: text,
          ),
        ),
      ),
    );
  }
}
