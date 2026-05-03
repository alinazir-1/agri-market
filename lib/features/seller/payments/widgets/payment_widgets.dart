import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/payment_model.dart';
import 'package:agri_market/data/models/product_type_enums.dart';
import 'package:agri_market/shared/widgets/seller/screen_filter_chip.dart';
import 'package:agri_market/shared/widgets/seller/screen_stat_card.dart';
import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_text.dart';

/// ── 1. Payment Stat Card ──────────────────────────────────────────────────────
class PayStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String badge;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color badgeBg;
  final Color badgeText;
  final Color valueColor;

  const PayStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.badge,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.badgeBg,
    required this.badgeText,
    this.valueColor = AppColors.textPrimary,
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

/// ── 2. Payment Status Pill ────────────────────────────────────────────────────
class PayStatusPill extends StatelessWidget {
  final PaymentStatus status;

  const PayStatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color text;
    final String label;

    switch (status) {
      case PaymentStatus.paid:
        bg = AppColors.badgeSuccessBg;
        text = AppColors.textEmeraldGreen;
        label = 'Paid';
        break;
      case PaymentStatus.pending:
        bg = AppColors.badgeWarningBg;
        text = AppColors.textWarning;
        label = 'Pending';
        break;
      case PaymentStatus.partial:
        bg = AppColors.badgeInfoBg;
        text = AppColors.textInfo;
        label = 'Partial';
        break;
      case PaymentStatus.failed:
        bg = AppColors.badgeErrorBg;
        text = AppColors.textError;
        label = 'Failed';
        break;
    }

    return AppContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space8,
        vertical: 2,
      ),
      backgroundColor: bg,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      child: AppText(
        text: label,
        fontSize: AppSize.font8, // mapped 9 to 8
        fontWeight: FontWeight.w700,
        color: text,
      ),
    );
  }
}

/// ── 3. Product Type Badge ─────────────────────────────────────────────────────
class PayTypeBadge extends StatelessWidget {
  final ProductType type;

  const PayTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color text;
    final String label;

    switch (type) {
      case ProductType.marketplace:
        bg = AppColors.badgeInfoBg;
        text = AppColors.textInfo;
        label = 'Marketplace';
        break;
      case ProductType.liveAuction:
        bg = AppColors.badgeWarningBg;
        text = AppColors.textWarning;
        label = 'Live Auction';
        break;
      case ProductType.advanceBooking:
        bg = AppColors.badgePurpleBg;
        text = AppColors.textPurple;
        label = 'Adv. Booking';
        break;
      default:
        bg = AppColors.backgroundHover;
        text = AppColors.textSecondary;
        label = type.name;
    }

    return AppContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space4, // mapped 5 to 4
        vertical: 2,
      ),
      backgroundColor: bg,
      borderRadius: BorderRadius.circular(AppSize.radius4), // mapped 5 to 4
      child: AppText(
        text: label,
        fontSize: AppSize.font8,
        fontWeight: FontWeight.w700,
        color: text,
      ),
    );
  }
}

/// ── 4. Payment Filter Chip ────────────────────────────────────────────────────
typedef PayFilterChip = ScreenFilterChip;

/// ── 5. Monthly Revenue Bar Chart ──────────────────────────────────────────────
class MonthlyRevenueChart extends StatelessWidget {
  final List<MonthlyRevenue> data;
  final double maxAmount;

  const MonthlyRevenueChart({
    super.key,
    required this.data,
    required this.maxAmount,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(AppSize.space12),
      backgroundColor: AppColors.backGroundWhite,
      borderRadius: BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
      border:
          Border.all(color: AppColors.borderLight, width: AppSize.borderWidth1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            text: 'Monthly Revenue',
            fontSize: AppSize.font10,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppSize.space12), // mapped 10 to 12
          SizedBox(
            height: 72.0, // Used fixed standard 72 mapping
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((m) {
                final barH = maxAmount == 0 ? 0.0 : (m.amount / maxAmount) * 60;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppContainer(
                        height: barH,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        backgroundColor: m.isCurrent
                            ? AppColors.emeraldGreen
                            : AppColors.badgeSuccessBg,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppSize.radius4),
                        ),
                      ),
                      const SizedBox(height: AppSize.space4),
                      AppText(
                        text: m.month,
                        fontSize: AppSize.font8,
                        color: m.isCurrent
                            ? AppColors.textEmeraldGreen
                            : AppColors.textSecondary,
                        fontWeight:
                            m.isCurrent ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// ── 6. Pending Payment Card ───────────────────────────────────────────────────
class PendingPayCard extends StatelessWidget {
  final PaymentModel payment;
  final String dateText;
  final String dueDateText;
  final VoidCallback onReminder;
  final bool isReminderLoading;

  const PendingPayCard({
    super.key,
    required this.payment,
    required this.dateText,
    required this.dueDateText,
    required this.onReminder,
    this.isReminderLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      margin: const EdgeInsets.only(bottom: AppSize.space8),
      padding: const EdgeInsets.all(AppSize.space12), // mapped 10 to 12
      backgroundColor: AppColors.badgeWarningBg, // mapped 0xFFFFF8F0
      borderRadius: BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
      border: Border.all(
        color:
            AppColors.textWarning.withValues(alpha: 0.3), // mapped 0xFFFED7AA
        width: AppSize.borderWidth1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: payment.buyerName,
            fontSize: AppSize.font10, // mapped 11 to 10
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: 2),
          AppText(
            text: '#${payment.orderId} · ${payment.productName}',
            fontSize: AppSize.font8, // mapped 9 to 8
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSize.space4),
          AppText(
            text: '\$${payment.amount.toStringAsFixed(0)}',
            fontSize: AppSize.font12, // mapped 13 to 12
            fontWeight: FontWeight.w800,
            color: AppColors.textWarning, // mapped backGroundOrange
          ),
          const SizedBox(height: 2),
          AppText(
            text: 'Due: $dueDateText',
            fontSize: AppSize.font8, // mapped 9 to 8
            color: AppColors.textWarning, // mapped 0xFF9A3412
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: AppSize.space8),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onReminder,
              child: AppContainer(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: AppSize.space4), // mapped 5 to 4
                backgroundColor: AppColors.emeraldGreen,
                borderRadius:
                    BorderRadius.circular(AppSize.radius4), // mapped 5 to 4
                child: Center(
                  child: isReminderLoading
                      ? const AppInlineProgress()
                      : const AppText(
                          text: 'Send Reminder',
                          fontSize: AppSize.font8, // mapped 9 to 8
                          fontWeight: FontWeight.w700,
                          color: AppColors.textWhite,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ── 7. Buyer Avatar ───────────────────────────────────────────────────────────
class PayBuyerAvatar extends StatelessWidget {
  final String initials;
  final String? avatarHex;
  final double size;

  const PayBuyerAvatar({
    super.key,
    required this.initials,
    this.avatarHex,
    this.size = 32.0, // mapped 30 to 32
  });

  // Helper string to Color
  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.emeraldGreen;
    try {
      final hexCode = hex.replaceAll('#', '').replaceAll('0xFF', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    } catch (_) {
      return AppColors.emeraldGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: size,
      height: size,
      backgroundColor: _parseColor(avatarHex),
      shape: BoxShape.circle,
      child: Center(
        child: AppText(
          text: initials,
          fontSize: size * 0.33,
          fontWeight: FontWeight.w800,
          color: AppColors.textWhite,
        ),
      ),
    );
  }
}
