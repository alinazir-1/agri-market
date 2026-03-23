import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/message_model.dart';
import '../message_con.dart';
import 'buyer_info.dart';
import 'buyer_order_card.dart';

class BuyerInfoPanel extends StatelessWidget {
  final MessagesCon messageController;
  const BuyerInfoPanel({super.key, required this.messageController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final conv = messageController.selectedConversation;
      if (conv == null) return const SizedBox(width: 260);
      return Container(
        width: 260,
        decoration: const BoxDecoration(
          color: CColors.backGroundWhite,
          border: Border(left: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(CSize.space14),
          child: Column(
            children: [
              _buyerHeader(conv),
              const SizedBox(height: CSize.space14),
              _buyerStats(conv),
              const SizedBox(height: CSize.space14),
              _recentOrders(conv),
            ],
          ),
        ),
      );
    });
  }

  Widget _buyerHeader(ConversationModel conv) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration:
              BoxDecoration(color: conv.avatarColor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(conv.initials,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: CColors.textWhite)),
        ),
        const SizedBox(height: CSize.space8),
        Text(conv.buyerName,
            style: const TextStyle(
                fontSize: CSize.font13Small,
                fontWeight: FontWeight.w800,
                color: CColors.textPrimary)),
        const SizedBox(height: CSize.space2),
        Text(conv.buyerEmail,
            style: const TextStyle(fontSize: 10, color: CColors.textSecondary)),
        if (conv.isVip) ...[
          const SizedBox(height: CSize.space8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: CSize.space10, vertical: CSize.space4),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF9C3),
              borderRadius: BorderRadius.circular(CSize.radius20Large),
            ),
            child: const Text('VIP Customer',
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF854D0E))),
          ),
        ],
        const SizedBox(height: CSize.space12),
        const Divider(height: 1, thickness: 0.5, color: Color(0xFFF1F5F9)),
      ],
    );
  }

  Widget _buyerStats(ConversationModel conv) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BUYER INFO',
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: CColors.textSecondary,
              letterSpacing: 0.5),
        ),
        const SizedBox(height: CSize.space8),
        BuyerInfoRow(label: 'Location', value: conv.buyerLocation),
        BuyerInfoRow(
            label: 'Total Orders', value: '${conv.totalOrders} orders'),
        BuyerInfoRow(
            label: 'Total Spent',
            value: '\$${conv.totalSpent.toStringAsFixed(0)}',
            valueColor: CColors.textEmeraldGreen),
        BuyerInfoRow(label: 'Member Since', value: conv.memberSince),
      ],
    );
  }

  Widget _recentOrders(ConversationModel conv) {
    if (conv.recentOrders.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RECENT ORDERS',
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: CColors.textSecondary,
              letterSpacing: 0.5),
        ),
        const SizedBox(height: CSize.space8),
        ...conv.recentOrders.map((order) => BuyerOrderCard(order: order)),
      ],
    );
  }
}
