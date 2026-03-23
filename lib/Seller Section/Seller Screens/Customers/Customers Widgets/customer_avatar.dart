import 'package:flutter/material.dart';
import '../../../../Core/Constant/colors.dart';

// ── 1. Customer Avatar ───────────────────────────────────────────────────────

class CustomerAvatar extends StatelessWidget {
  final String initials;
  final Color color;
  final double size;

  const CustomerAvatar({
    super.key,
    required this.initials,
    required this.color,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.33,
          fontWeight: FontWeight.w800,
          color: CColors.textWhite,
        ),
      ),
    );
  }
}
