// lib/data/models/customer_activity_model.dart

import 'dart:ui';

enum CustomerActivityType { newOrder, auctionWon, booking, inactive, other }

class CustomerActivity {
  final String message;
  final String timeAgo;
  final CustomerActivityType type;

  const CustomerActivity({
    required this.message,
    required this.timeAgo,
    required this.type,
    required Color dotColor,
  });
}
