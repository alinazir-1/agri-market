// ── 5. Grade Pill ────────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';

import '../../Core/Constant/sizes.dart';

class GradePill extends StatelessWidget {
  final String grade;
  const GradePill({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: CSize.space5, vertical: 2),
      decoration: BoxDecoration(
          color: const Color(0xFFFBBF24),
          borderRadius: BorderRadius.circular(CSize.radius20Large)),
      child: Text('GRADE $grade',
          style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: Color(0xFF78350F))),
    );
  }
}
