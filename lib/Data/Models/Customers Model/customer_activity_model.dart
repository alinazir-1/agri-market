import 'package:flutter/material.dart';

enum CustomerActivityType { newOrder, auctionWon, booking, inactive, other }

class CustomerActivity {
  final String message;
  final String timeAgo;
  final Color dotColor;
  final CustomerActivityType type;

  const CustomerActivity({
    required this.message,
    required this.timeAgo,
    required this.dotColor,
    required this.type,
  });
}
