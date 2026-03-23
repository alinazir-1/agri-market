import 'package:flutter/material.dart';
import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';

class CustomerActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color hoverBg;
  final Color hoverBorder;
  final VoidCallback onTap;

  const CustomerActionButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.hoverBg,
    required this.hoverBorder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CSize.radius5Small),
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: CColors.backGroundWhite,
          borderRadius: BorderRadius.circular(CSize.radius5Small),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: CSize.borderWidth05,
          ),
        ),
        child: Icon(icon, size: CSize.icon16Small, color: iconColor),
      ),
    );
  }
}
