// ── 3. Buy Type Badge ────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/product_type_enums.dart';

class BuyTypeBadge extends StatelessWidget {
  final ProductType type;

  const BuyTypeBadge({super.key, required this.type});

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
