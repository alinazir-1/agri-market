// ── 3. Product Type Badge ────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/product_type_enums.dart';

class InvTypeBadge extends StatelessWidget {
  final ProductType type;

  const InvTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final Map<ProductType, _BadgeStyle> styles = {
      ProductType.marketplace: const _BadgeStyle(
          Color(0xFFDBEAFE), Color(0xFF1E40AF), 'Marketplace'),
      ProductType.liveAuction: const _BadgeStyle(
          Color(0xFFFEF9C3), Color(0xFF854D0E), 'Live Auction'),
      ProductType.advanceBooking: const _BadgeStyle(
          Color(0xFFEDE9FE), Color(0xFF5B21B6), 'Adv. Booking'),
    };
    final style = styles[type] ??
        const _BadgeStyle(Color(0xFFF3F4F6), CColors.textSecondary, 'Unknown');
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: CSize.space5, vertical: 2),
      decoration: BoxDecoration(
          color: style.bg,
          borderRadius: BorderRadius.circular(CSize.radius5Small)),
      child: Text(style.label,
          style: TextStyle(
              fontSize: 8, fontWeight: FontWeight.w700, color: style.text)),
    );
  }
}

class _BadgeStyle {
  final Color bg, text;
  final String label;
  const _BadgeStyle(this.bg, this.text, this.label);
}
