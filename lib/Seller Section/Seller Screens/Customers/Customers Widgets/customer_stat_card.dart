// Replaced by shared ScreenStatCard — thin wrapper kept for backward-compatible imports.
// Note: uses `badgeText` param name (maps to `badgeTextColor` in ScreenStatCard).
import 'package:flutter/material.dart';
import '../../../../Shared/Screens Common Widgets/screen_stat_card.dart';

class CustomerStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String badge;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color badgeBg;
  final Color badgeText;
  final Color valueColor;

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
    this.valueColor = const Color(0xFF1E293B),
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
        valueColor: valueColor,
      );
}
