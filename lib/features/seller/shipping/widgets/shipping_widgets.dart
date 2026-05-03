import 'package:flutter/material.dart';

import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/delivery_partner_model.dart';
import 'package:agri_market/data/models/shipping_model.dart';

import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_text.dart';

// ── 1. Shipping Stat Card ─────────────────────────────────────────────────────

class ShipStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String badge;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color badgeBg;
  final Color badgeText;
  final Color valueColor;

  const ShipStatCard({
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
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(AppSize.space12),
      backgroundColor: AppColors.backGroundWhite,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      border:
          Border.all(color: AppColors.borderLight, width: AppSize.borderWidth1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppContainer(
            width: AppSize.icon32, // mapped 30 to 32
            height: AppSize.icon32,
            backgroundColor: iconBg,
            borderRadius:
                BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
            child: Center(
                child: Icon(icon, size: AppSize.icon16, color: iconColor)),
          ),
          const SizedBox(height: AppSize.space8),
          AppText(
              text: value,
              fontSize: AppSize.font20,
              fontWeight: FontWeight.w800,
              color: valueColor),
          const SizedBox(height: AppSize.space4), // mapped 2 to 4
          AppText(
              text: label,
              fontSize: AppSize.font8, // mapped 9 to 8
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.3),
          const SizedBox(height: AppSize.space4), // mapped 5 to 4
          AppContainer(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.space8, vertical: 2),
            backgroundColor: badgeBg,
            borderRadius: BorderRadius.circular(AppSize.radius20),
            child: AppText(
                text: badge,
                fontSize: AppSize.font8, // mapped 9 to 8
                fontWeight: FontWeight.w700,
                color: badgeText),
          ),
        ],
      ),
    );
  }
}

// ── 2. Shipment Status Pill ───────────────────────────────────────────────────

class ShipStatusPill extends StatelessWidget {
  final ShipmentStatus status;
  const ShipStatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color text;
    final String label;
    switch (status) {
      case ShipmentStatus.pending:
        bg = AppColors.badgeWarningBg; // mapped 0xFFFFF7ED
        text = AppColors.textWarning; // mapped 0xFF9A3412
        label = 'Pending';
        break;
      case ShipmentStatus.processing:
        bg = AppColors.badgeInfoBg; // mapped 0xFFEFF6FF
        text = AppColors.textInfo; // mapped 0xFF1E40AF
        label = 'Processing';
        break;
      case ShipmentStatus.shipped:
        bg = AppColors.badgePurpleBg; // mapped 0xFFFEF9C3
        text = AppColors.textPurple; // mapped 0xFF854D0E
        label = 'Shipped';
        break;
      case ShipmentStatus.inTransit:
        bg = AppColors.badgeInfoBg; // mapped 0xFFE0F2FE
        text = AppColors.textInfo; // mapped 0xFF0369A1
        label = 'In Transit';
        break;
      case ShipmentStatus.delivered:
        bg = AppColors.badgeSuccessBg; // mapped backgroundEmerald100
        text = AppColors.textEmeraldGreen;
        label = 'Delivered';
        break;
      case ShipmentStatus.cancelled:
        bg = AppColors.badgeErrorBg; // mapped 0xFFFEE2E2
        text = AppColors.textError; // mapped 0xFF991B1B
        label = 'Cancelled';
        break;
    }
    return AppContainer(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSize.space8, vertical: 2),
      backgroundColor: bg,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      child: AppText(
          text: label,
          fontSize: AppSize.font8, // mapped 9 to 8
          fontWeight: FontWeight.w700,
          color: text),
    );
  }
}

// ── 3. Shipment Progress Bar ──────────────────────────────────────────────────

class ShipmentProgressBar extends StatelessWidget {
  final int currentStep;
  const ShipmentProgressBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (i) {
        if (i.isEven) {
          final stepIdx = i ~/ 2;
          final isDone = stepIdx <= currentStep;
          final isNext = stepIdx == currentStep + 1;
          return AppContainer(
            width: AppSize.icon16,
            height: AppSize.icon16,
            backgroundColor: isDone
                ? AppColors.emeraldGreen // mapped backGroundEmeraldGreen
                : AppColors.backGroundWhite,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDone || isNext
                  ? AppColors.borderEmeraldGreen
                  : AppColors.borderLight, // mapped 0xFFE2E8F0
              width: AppSize.borderWidth1,
            ),
            child: isDone
                ? const Center(
                    child: Icon(Icons.check_rounded,
                        size: AppSize.icon12,
                        color: AppColors.iconWhite)) // mapped 9 to 12
                : isNext
                    ? Center(
                        child: AppContainer(
                            width: 6.0, // Used direct size
                            height: 6.0,
                            backgroundColor: AppColors.emeraldGreen,
                            shape: BoxShape.circle))
                    : const SizedBox.shrink(),
          );
        } else {
          final lineIdx = i ~/ 2;
          return Expanded(
            child: AppContainer(
              height: AppSize.borderWidth2,
              backgroundColor: lineIdx < currentStep
                  ? AppColors.emeraldGreen
                  : AppColors.borderLight, // mapped 0xFFE2E8F0
              borderRadius:
                  BorderRadius.circular(AppSize.radiusCircular), // mapped 99
            ),
          );
        }
      }),
    );
  }
}

// ── 4. Shipping Filter Chip ───────────────────────────────────────────────────

class ShipFilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color? activeColor;
  final Color? activeBorder;
  final Color? inactiveBorder;
  final Color? inactiveText;

  const ShipFilterChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.activeColor,
    this.activeBorder,
    this.inactiveBorder,
    this.inactiveText,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = isActive
        ? (activeColor ??
            AppColors.emeraldGreen) // mapped backGroundEmeraldGreen
        : AppColors.backGroundWhite;
    final Color border = isActive
        ? (activeBorder ?? AppColors.borderEmeraldGreen)
        : (inactiveBorder ?? AppColors.borderLight); // mapped 0xFFE2E8F0
    final Color text = isActive
        ? AppColors.textWhite
        : (inactiveText ?? AppColors.textSecondary);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space12, vertical: AppSize.space4),
          decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(AppSize.radius20),
              border: Border.all(color: border)),
          child: AppText(
              text: label,
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w600,
              color: text),
        ),
      ),
    );
  }
}

// ── 5. Delayed Shipment Card ──────────────────────────────────────────────────

class DelayedShipCard extends StatelessWidget {
  final ShipmentModel shipment;
  final VoidCallback onAction;
  final bool isActionLoading;

  const DelayedShipCard({
    super.key,
    required this.shipment,
    required this.onAction,
    this.isActionLoading = false,
  });

  String get _actionLabel => shipment.status == ShipmentStatus.pending
      ? 'Mark as Dispatched'
      : 'Contact Courier';

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      margin: const EdgeInsets.only(bottom: AppSize.space8),
      padding: const EdgeInsets.all(AppSize.space12), // mapped 10 to 12
      backgroundColor: AppColors.badgeWarningBg, // mapped 0xFFFFF8F0
      borderRadius: BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
      border: Border.all(
          color: AppColors.textWarning.withValues(alpha: 0.3),
          width: AppSize.borderWidth1), // mapped 0xFFFED7AA
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
              text: '#${shipment.orderId} · ${shipment.buyerName}',
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary),
          const SizedBox(height: AppSize.space4), // mapped 2 to 4
          AppText(
              text:
                  '${shipment.productName} · ${shipment.quantity} ${shipment.unit}',
              fontSize: AppSize.font8, // mapped 9 to 8
              color: AppColors.textSecondary),
          const SizedBox(height: AppSize.space4),
          AppText(
              text: shipment.delayReason ?? 'Delayed',
              fontSize: AppSize.font8, // mapped 9 to 8
              fontWeight: FontWeight.w600,
              color: AppColors.textWarning), // mapped 0xFF9A3412
          const SizedBox(height: AppSize.space8),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: isActionLoading ? null : onAction,
              child: AppContainer(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: AppSize.space4), // mapped 5 to 4
                backgroundColor: AppColors.emeraldGreen,
                borderRadius:
                    BorderRadius.circular(AppSize.radius4), // mapped 5 to 4
                child: Center(
                  child: isActionLoading
                      ? const AppInlineProgress()
                      : AppText(
                          text: _actionLabel,
                          fontSize: AppSize.font8, // mapped 9 to 8
                          fontWeight: FontWeight.w700,
                          color: AppColors.textWhite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 6. Buyer Avatar ───────────────────────────────────────────────────────────

class ShipBuyerAvatar extends StatelessWidget {
  final String initials;
  final String? avatarHex; // Changed to String? hex per the model rule fix
  final double size;

  const ShipBuyerAvatar(
      {super.key, required this.initials, this.avatarHex, this.size = 28});

  // String to Color Parser
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
            color: AppColors.textWhite),
      ),
    );
  }
}

// ── 7. Delivery Partner Card ──────────────────────────────────────────────────

class DeliveryPartnerCard extends StatelessWidget {
  final DeliveryPartnerModel partner;
  final VoidCallback onAssign;
  final VoidCallback onViewDetails;
  final VoidCallback onToggleStatus;

  const DeliveryPartnerCard({
    super.key,
    required this.partner,
    required this.onAssign,
    required this.onViewDetails,
    required this.onToggleStatus,
  });

  bool get _isActive => partner.status == PartnerStatus.active;

  // String to Color Parser for logoBgHex
  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.badgeSuccessBg;
    try {
      final hexCode = hex.replaceAll('#', '').replaceAll('0xFF', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    } catch (_) {
      return AppColors.badgeSuccessBg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(AppSize.space16),
      backgroundColor: AppColors.backGroundWhite,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      border: Border.all(
        color: _isActive
            ? AppColors.borderEmeraldGreen
            : AppColors.borderLight, // mapped 0xFFE2E8F0
        width: AppSize.borderWidth1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row — logo + name + badge
          Row(
            children: [
              AppContainer(
                width: 44.0, // specific layout width
                height: 44.0, // specific layout height
                backgroundColor:
                    _parseColor(partner.logoBgHex), // used hex parsing
                borderRadius:
                    BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
                child: Center(
                    child:
                        AppText(text: partner.emoji, fontSize: AppSize.font20)),
              ),
              const SizedBox(width: AppSize.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                        text: partner.name,
                        fontSize: AppSize.font12, // mapped 13 to 12
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary),
                    AppText(
                        text: partner.typeLabel,
                        fontSize: AppSize.font10,
                        color: AppColors.textSecondary),
                  ],
                ),
              ),
              // Status badge
              AppContainer(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.space8, vertical: 2),
                backgroundColor: _isActive
                    ? AppColors.badgeSuccessBg // mapped backgroundEmerald100
                    : AppColors.backgroundHover, // mapped 0xFFF3F4F6
                borderRadius: BorderRadius.circular(AppSize.radius20),
                child: AppText(
                  text: _isActive ? 'Active' : 'Inactive',
                  fontSize: AppSize.font8,
                  fontWeight: FontWeight.w700,
                  color: _isActive
                      ? AppColors.textEmeraldGreen
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSize.space12),

          // Stats row
          Row(
            children: [
              Expanded(
                  child: _statItem('${partner.totalShipments}', 'Shipments',
                      AppColors.textPrimary)),
              Expanded(
                  child: _statItem(
                      '${partner.onTimePercent.toStringAsFixed(0)}%',
                      'On Time',
                      AppColors.textEmeraldGreen)),
              Expanded(
                  child: _statItem(partner.rating.toStringAsFixed(1), 'Rating',
                      AppColors.textInfo)), // mapped 0xFF1D4ED8
            ],
          ),

          const SizedBox(height: AppSize.space12), // mapped 10 to 12
          Divider(
              height: AppSize.borderWidth1,
              color: AppColors.borderLight), // mapped 0xFFF1F5F9
          const SizedBox(height: AppSize.space12), // mapped 10 to 12

          // Coverage
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: AppSize.font10, color: AppColors.textSecondary),
              const SizedBox(width: AppSize.space4),
              Expanded(
                child: AppText(
                    text: partner.coverage,
                    fontSize: AppSize.font10,
                    color: AppColors.textSecondary),
              ),
            ],
          ),

          const SizedBox(height: AppSize.space12), // mapped 10 to 12

          // Action buttons
          Row(
            children: _isActive
                ? [
                    Expanded(child: _primaryBtn('Assign to Order', onAssign)),
                    const SizedBox(width: AppSize.space8),
                    Expanded(
                        child: _secondaryBtn('View Details', onViewDetails)),
                  ]
                : [
                    Expanded(child: _secondaryBtn('Activate', onToggleStatus)),
                    const SizedBox(width: AppSize.space8),
                    Expanded(child: _secondaryBtn('Remove', () {})),
                  ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label, Color valueColor) {
    return Column(
      children: [
        AppText(
            text: value,
            fontSize: AppSize.font16,
            fontWeight: FontWeight.w800,
            color: valueColor),
        AppText(
            text: label,
            fontSize: AppSize.font8, // mapped 9 to 8
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.3),
      ],
    );
  }

  Widget _primaryBtn(String label, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AppContainer(
          padding: const EdgeInsets.symmetric(vertical: AppSize.space8),
          backgroundColor:
              AppColors.emeraldGreen, // mapped backGroundEmeraldGreen
          borderRadius:
              BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
          child: Center(
            child: AppText(
                text: label,
                fontSize: AppSize.font10,
                fontWeight: FontWeight.w700,
                color: AppColors.textWhite),
          ),
        ),
      ),
    );
  }

  Widget _secondaryBtn(String label, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AppContainer(
          padding: const EdgeInsets.symmetric(vertical: AppSize.space8),
          backgroundColor: AppColors.backGroundWhite,
          borderRadius:
              BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
          border: Border.all(
              color: AppColors.borderLight,
              width: AppSize.borderWidth1), // mapped 0xFFE2E8F0
          child: Center(
            child: AppText(
                text: label,
                fontSize: AppSize.font10,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
