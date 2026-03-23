import 'package:flutter/material.dart';

enum ReviewFilter { all, fiveStar, fourStar, threeStar, lowRating, pendingReply, flagged }
enum ReviewSort   { latest, oldest, highestRating, lowestRating }

class ReviewModel {
  final String   id;
  final String   buyerId;
  final String   buyerName;
  final String   buyerLocation;
  final Color    avatarColor;
  final String   productId;
  final String   productName;
  final String   productCategory;
  final String   productType;
  final String   productEmoji;
  final int      rating;
  final String   reviewText;
  final DateTime reviewDate;
  final bool     isVerified;
  final bool     isFlagged;
  final String?  sellerReply;

  const ReviewModel({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.buyerLocation,
    required this.avatarColor,
    required this.productId,
    required this.productName,
    required this.productCategory,
    required this.productType,
    required this.productEmoji,
    required this.rating,
    required this.reviewText,
    required this.reviewDate,
    required this.isVerified,
    required this.isFlagged,
    this.sellerReply,
  });

  bool get hasReply    => sellerReply != null && sellerReply!.isNotEmpty;
  bool get isPending   => !hasReply && !isFlagged;

  String get initials {
    final parts = buyerName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return buyerName.substring(0, 2).toUpperCase();
  }

  ReviewModel copyWith({String? sellerReply, bool? isFlagged}) {
    return ReviewModel(
      id: id, buyerId: buyerId, buyerName: buyerName,
      buyerLocation: buyerLocation, avatarColor: avatarColor,
      productId: productId, productName: productName,
      productCategory: productCategory, productType: productType,
      productEmoji: productEmoji, rating: rating,
      reviewText: reviewText, reviewDate: reviewDate,
      isVerified: isVerified,
      isFlagged: isFlagged ?? this.isFlagged,
      sellerReply: sellerReply ?? this.sellerReply,
    );
  }
}

class TopRatedProduct {
  final String productId;
  final String productName;
  final String emoji;
  final int    reviewCount;
  final double avgRating;

  const TopRatedProduct({
    required this.productId,
    required this.productName,
    required this.emoji,
    required this.reviewCount,
    required this.avgRating,
  });
}