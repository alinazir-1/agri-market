// ── 2. Stock Progress Bar ────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';

class InvStockBar extends StatelessWidget {
  final int current;
  final int total;
  final String unit;
  final bool isLow;
  final bool isOut;

  const InvStockBar({
    super.key,
    required this.current,
    required this.total,
    required this.unit,
    required this.isLow,
    required this.isOut,
  });

  Color get _barColor => isOut
      ? CColors.borderError
      : isLow
          ? CColors.backGroundOrange
          : CColors.backGroundEmeraldGreen;
  Color get _textColor => isOut
      ? CColors.textError
      : isLow
          ? CColors.textOrange
          : CColors.textPrimary;
  double get _progress => total == 0 ? 0 : (current / total).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$current $unit',
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: _textColor)),
        const SizedBox(height: CSize.space4),
        SizedBox(
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(CSize.radius24XLarge),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 4,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(_barColor),
            ),
          ),
        ),
        const SizedBox(height: CSize.space2),
        Text('of $total max',
            style: const TextStyle(fontSize: 9, color: CColors.textSecondary)),
      ],
    );
  }
}
