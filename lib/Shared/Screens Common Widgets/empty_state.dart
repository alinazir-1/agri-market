import 'package:flutter/material.dart';
import '../../Core/Constant/colors.dart';
import '../../Core/Constant/sizes.dart';

/// Generic empty state shown when a list/table has no items.
/// Used in Inventory, Payment, Reviews, Shipping, My Products screens.
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
          Icon(icon, size: CSize.icon36XLarge, color: CColors.textSecondary),
          const SizedBox(height: CSize.space12),
          Text(
            message,
            style: const TextStyle(
                fontSize: CSize.font13Small, color: CColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
