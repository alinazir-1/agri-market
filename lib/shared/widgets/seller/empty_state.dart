import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import '../common/app_text.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyState({
    super.key,
    this.message = 'No items found',
    this.icon = Icons.inventory_2_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSize.icon32, // Closest to 36
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSize.space12),
          AppText(
            text: message,
            fontSize: AppSize.font12, // Closest to 13
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
