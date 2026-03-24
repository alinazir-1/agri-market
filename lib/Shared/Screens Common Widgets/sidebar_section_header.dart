import 'package:flutter/material.dart';
import '../../Core/Constant/colors.dart';
import '../../Core/Constant/sizes.dart';

/// Sidebar section header with an icon, title, and an optional count badge.
/// Used in Inventory (Stock Alerts), Payment, Reviews, Shipping sidebars.
class SidebarSectionHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final int? count;
  final Color countBg;
  final Color countTextColor;

  const SidebarSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor = CColors.textError,
    this.count,
    this.countBg = const Color(0xFFFEE2E2),
    this.countTextColor = CColors.textError,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: CSize.icon16Small, color: iconColor),
      const SizedBox(width: CSize.space5),
      Text(
        title,
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: CColors.textPrimary),
      ),
      if (count != null && count! > 0) ...[
        const SizedBox(width: CSize.space5),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: CSize.space8, vertical: 2),
          decoration: BoxDecoration(
            color: countBg,
            borderRadius: BorderRadius.circular(CSize.radius20Large),
          ),
          child: Text(
            '$count',
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: countTextColor),
          ),
        ),
      ],
    ]);
  }
}

/// Green "all clear" banner shown when there are no alerts.
/// Used below SidebarSectionHeader when the alert list is empty.
class AllClearBanner extends StatelessWidget {
  final String message;

  const AllClearBanner({
    super.key,
    this.message = 'Everything looks good',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(CSize.space12),
      decoration: BoxDecoration(
        color: CColors.backgroundEmerald100,
        borderRadius: BorderRadius.circular(CSize.radius10Medium),
      ),
      child: Row(children: [
        const Icon(Icons.check_circle_outline,
            size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
        const SizedBox(width: CSize.space8),
        Text(
          message,
          style: const TextStyle(
              fontSize: 10,
              color: CColors.textEmeraldGreen,
              fontWeight: FontWeight.w600),
        ),
      ]),
    );
  }
}
