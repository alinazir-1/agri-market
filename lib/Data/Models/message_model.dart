import 'package:flutter/material.dart';

enum MessageType { text, orderCard }

enum ConversationTab { all, unread, orders }

class MessageModel {
  final String id;
  final String text;
  final bool isMine;
  final DateTime time;
  final MessageType type;
  final OrderCardData? orderCard;

  const MessageModel({
    required this.id,
    required this.text,
    required this.isMine,
    required this.time,
    this.type = MessageType.text,
    this.orderCard,
  });
}

class OrderCardData {
  final String orderId;
  final String productName;
  final String quantity;
  final String total;

  const OrderCardData({
    required this.orderId,
    required this.productName,
    required this.quantity,
    required this.total,
  });
}

class ConversationModel {
  final String id;
  final String buyerName;
  final String buyerEmail;
  final String buyerLocation;
  final Color avatarColor;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;
  final bool isVip;
  final int totalOrders;
  final double totalSpent;
  final String memberSince;
  final List<MessageModel> messages;
  final List<RecentOrderInfo> recentOrders;

  const ConversationModel({
    required this.id,
    required this.buyerName,
    required this.buyerEmail,
    required this.buyerLocation,
    required this.avatarColor,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isOnline,
    required this.isVip,
    required this.totalOrders,
    required this.totalSpent,
    required this.memberSince,
    required this.messages,
    required this.recentOrders,
  });

  String get initials {
    final parts = buyerName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return buyerName.substring(0, 2).toUpperCase();
  }
}

class RecentOrderInfo {
  final String productName;
  final String status;
  final String date;
  final String amount;
  final bool isDelivered;

  const RecentOrderInfo({
    required this.productName,
    required this.status,
    required this.date,
    required this.amount,
    required this.isDelivered,
  });
}
