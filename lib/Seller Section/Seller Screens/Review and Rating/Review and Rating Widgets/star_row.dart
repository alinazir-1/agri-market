// ── 1. Star Row ───────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class StarRow extends StatelessWidget {
  final int rating;
  final double size;

  const StarRow({super.key, required this.rating, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
          5,
          (i) => Icon(
                Icons.star_rounded,
                size: size,
                color: i < rating
                    ? const Color(0xFFFBBF24)
                    : const Color(0xFFE5E7EB),
              )),
    );
  }
}
