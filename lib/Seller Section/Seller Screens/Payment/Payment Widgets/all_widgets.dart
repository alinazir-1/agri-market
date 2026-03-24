import 'package:flutter/material.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/payment_model.dart';
import '../../../../Data/Models/product_type_enums.dart';
import '../../../../Shared/Screens Common Widgets/screen_filter_chip.dart';
import '../../../../Shared/Screens Common Widgets/screen_stat_card.dart';

/// ── 1. Payment Stat Card ──────────────────────────────────────────────────────
/// Thin wrapper — delegates to shared [ScreenStatCard].
/// Uses `badgeText` param name for backward compatibility.
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
    this.valueColor = CColors.textPrimary,
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
        bg = CColors.backgroundEmerald100;
        text = CColors.textEmeraldGreen;
        label = 'Paid';
        break;
      case PaymentStatus.pending:
        bg = const Color(0xFFFFF7ED);
        text = const Color(0xFF9A3412);
        label = 'Pending';
        break;
      case PaymentStatus.partial:
        bg = const Color(0xFFEFF6FF);
        text = const Color(0xFF1E40AF);
        label = 'Partial';
        break;
      case PaymentStatus.failed:
        bg = const Color(0xFFFEE2E2);
        text = const Color(0xFF991B1B);
        label = 'Failed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CSize.space8,
        vertical: CSize.space2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: text,
        ),
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
        bg = const Color(0xFFDBEAFE);
        text = const Color(0xFF1E40AF);
        label = 'Marketplace';
        break;
      case ProductType.liveAuction:
        bg = const Color(0xFFFEF9C3);
        text = const Color(0xFF854D0E);
        label = 'Live Auction';
        break;
      case ProductType.advanceBooking:
        bg = const Color(0xFFEDE9FE);
        text = const Color(0xFF5B21B6);
        label = 'Adv. Booking';
        break;
      default:
        bg = const Color(0xFFF3F4F6);
        text = CColors.textSecondary;
        label = type.name;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CSize.space5,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(CSize.radius5Small),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: text,
        ),
      ),
    );
  }
}

/// ── 4. Payment Filter Chip ────────────────────────────────────────────────────
/// Thin wrapper — delegates to shared [ScreenFilterChip].
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
    return Container(
      padding: const EdgeInsets.all(CSize.space12),
      decoration: BoxDecoration(
        color: CColors.backGroundWhite,
        borderRadius: BorderRadius.circular(CSize.radius10Medium),
        border: Border.all(
            color: const Color(0xFFE2E8F0), width: CSize.borderWidth1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Revenue',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: CColors.textPrimary,
            ),
          ),
          const SizedBox(height: CSize.space10),
          SizedBox(
            height: 70,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((m) {
                final barH = maxAmount == 0 ? 0.0 : (m.amount / maxAmount) * 60;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: barH,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: m.isCurrent
                              ? CColors.backGroundEmeraldGreen
                              : CColors.backgroundEmerald100,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        m.month,
                        style: TextStyle(
                          fontSize: 8,
                          color: m.isCurrent
                              ? CColors.textEmeraldGreen
                              : CColors.textSecondary,
                          fontWeight:
                              m.isCurrent ? FontWeight.w700 : FontWeight.w400,
                        ),
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

  const PendingPayCard({
    super.key,
    required this.payment,
    required this.dateText,
    required this.dueDateText,
    required this.onReminder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: CSize.space8),
      padding: const EdgeInsets.all(CSize.space10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(CSize.radius10Medium),
        border: Border.all(
          color: const Color(0xFFFED7AA),
          width: CSize.borderWidth1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            payment.buyerName,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: CColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '#${payment.orderId} · ${payment.productName}',
            style: const TextStyle(fontSize: 9, color: CColors.textSecondary),
          ),
          const SizedBox(height: CSize.space4),
          Text(
            '\$${payment.amount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: CSize.font13Small,
              fontWeight: FontWeight.w800,
              color: CColors.backGroundOrange,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Due: $dueDateText',
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF9A3412),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: CSize.space8),
          GestureDetector(
            onTap: onReminder,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: CSize.space5),
              decoration: BoxDecoration(
                color: CColors.backGroundEmeraldGreen,
                borderRadius: BorderRadius.circular(CSize.radius5Small),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Send Reminder',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: CColors.textWhite,
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
  final Color color;
  final double size;

  const PayBuyerAvatar({
    super.key,
    required this.initials,
    required this.color,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.33,
          fontWeight: FontWeight.w800,
          color: CColors.textWhite,
        ),
      ),
    );
  }
}
