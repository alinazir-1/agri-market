import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/shared/widgets/seller/screen_stat_card.dart';

class CustomerStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String badge;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color badgeBg;
  final Color badgeText;
  final Color? valueColor;

  const CustomerStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.badge,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.badgeBg,
    required this.badgeText,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) => ScreenStatCard(
        label: label,
        value: value,
        badge: badge,
        icon: icon,
        iconBg: iconBg,
        iconColor: iconColor,
        badgeBg: badgeBg,
        badgeTextColor: badgeText,
        valueColor: valueColor ?? AppColors.textPrimary,
      );
}
