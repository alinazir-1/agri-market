import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FaqItem {
  final String question;
  final String answer;
  final String category;
  const FaqItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}

class HelpSupportCon extends GetxController {
  final searchQuery = ''.obs;
  final expandedIndex = Rx<int?>(null);
  final searchController = TextEditingController();

  void onSearch(String v) => searchQuery.value = v;

  void toggleFaq(int index) {
    expandedIndex.value = expandedIndex.value == index ? null : index;
  }

  static const List<FaqItem> faqs = [
    FaqItem(
      question: 'How do I add a new product listing?',
      answer:
          'Navigate to Catalog → Add New Product in the sidebar. Fill in the product details including name, category, price, stock quantity, and images. Click "Publish" to make your product live on the marketplace.',
      category: 'Products',
    ),
    FaqItem(
      question: 'How are payments processed and when do I receive funds?',
      answer:
          'Payments are processed within 24 hours of order confirmation. Funds are transferred to your registered bank account within 3–5 business days after the buyer confirms delivery. You can track payment status in the Payments section.',
      category: 'Payments',
    ),
    FaqItem(
      question: 'How do I manage my inventory effectively?',
      answer:
          'Go to Operations → Inventory from the sidebar. You can set minimum stock thresholds for automatic low-stock alerts, update quantities in bulk, and track stock movement history. Enable stock alerts in Settings → Notifications to get notified.',
      category: 'Inventory',
    ),
    FaqItem(
      question: 'What happens after a buyer places an order?',
      answer:
          'You will receive an instant notification when an order is placed. Go to Operations → Orders to view and manage it. You have 24 hours to accept or decline. Once accepted, prepare the shipment and update the tracking information.',
      category: 'Orders',
    ),
    FaqItem(
      question: 'How do I set up and manage shipping?',
      answer:
          'Navigate to Finance → Shipping & Logistics. You can configure your shipping zones, preferred carriers, and delivery timeframes. Set up flat-rate or weight-based shipping rates. You can also integrate with third-party logistics providers.',
      category: 'Shipping',
    ),
    FaqItem(
      question: 'Can I offer discounts or promotional pricing?',
      answer:
          'Yes. When adding or editing a product, you can set a "Promotional Price" along with a start and end date. Bulk pricing tiers are also available — set different prices for different order quantities.',
      category: 'Products',
    ),
    FaqItem(
      question: 'How do customer reviews and ratings work?',
      answer:
          'Buyers can leave reviews after order completion. You can view and respond to all reviews in Communication → Reviews & Ratings. Maintaining a high rating (above 4.0) gives your products priority placement in search results.',
      category: 'Reviews',
    ),
    FaqItem(
      question: 'What are the platform commission rates?',
      answer:
          'AgriMarket charges a competitive 2.5% commission on each successful transaction. There are no monthly fees or listing charges. The commission is automatically deducted before funds are transferred to your account.',
      category: 'Payments',
    ),
    FaqItem(
      question: 'How do I handle order cancellations and returns?',
      answer:
          'Go to Operations → Orders and select the relevant order. You can initiate a cancellation or return from the order detail page. Provide the reason and any supporting evidence. Refunds are processed within 5–7 business days once approved.',
      category: 'Orders',
    ),
    FaqItem(
      question: 'How do I contact my buyers directly?',
      answer:
          'Use the built-in messaging system at Communication → Messages. You can send text, images, and documents directly to buyers. WhatsApp integration is also available — enable it in Settings → Integrations.',
      category: 'Communication',
    ),
  ];

  List<FaqItem> get filteredFaqs {
    if (searchQuery.value.trim().isEmpty) return faqs;
    final q = searchQuery.value.toLowerCase();
    return faqs
        .where((f) =>
            f.question.toLowerCase().contains(q) ||
            f.answer.toLowerCase().contains(q) ||
            f.category.toLowerCase().contains(q))
        .toList();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
