import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';

class StarRow extends StatelessWidget {
  final int rating;
  final double size;

  const StarRow({super.key, required this.rating, this.size = 14.0});

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
                    ? AppColors.textWarning // mapped 0xFFFBBF24
                    : AppColors.borderLight, // mapped 0xFFE5E7EB
              )),
    );
  }
}
