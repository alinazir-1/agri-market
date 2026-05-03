// home_ticker_bar.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/features/buyer/home/home_bin.dart';
import 'package:agri_market/features/buyer/home/home_con.dart';
import 'package:agri_market/features/buyer/home/home_ticker_con.dart';

/// Stateless; marquee animation lives in [HomeTickerCon] (GetX).
class HomeTickerBar extends StatelessWidget {
  const HomeTickerBar({super.key});

  static const Color _bg = AppColors.textPrimary;
  static const Color _tagBg = AppColors.borderDark;
  static const Color _upColor = Color(0xFF81C784);
  static const Color _downColor = Color(0xFFEF9A9A);
  static const Color _ntColor = Color(0xFFFFD54F);
  static const Color _prColor = Color(0xFFA5D6A7);
  static const Color _divColor = Color(0xFF2E7D32);

  List<Widget> _buildItems() {
    return HomeCon.tickerItems.map((item) {
      final isUp = item.change > 0;
      final isDown = item.change < 0;
      final chgColor = isUp ? _upColor : isDown ? _downColor : _ntColor;
      final arrow = isUp ? '▲' : isDown ? '▼' : '●';
      final pct = item.change == 0.0
          ? '0.0%'
          : '${item.change.abs().toStringAsFixed(1)}%';

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 3,
                  height: 3,
                  decoration: const BoxDecoration(
                      color: Color(0xFF6EE7B7), shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(item.price,
                    style: const TextStyle(color: _prColor, fontSize: 10.5)),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: chgColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(arrow,
                          style: TextStyle(
                              color: chgColor,
                              fontSize: 8,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(width: 3),
                      Text(pct,
                          style: TextStyle(
                              color: chgColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 20, color: _divColor),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    HomeBinding.ensureHomeTickerCon();
    final tickerCon = Get.find<HomeTickerCon>();

    return Container(
      height: 34,
      color: _bg,
      child: Row(
        children: [
          Container(
            color: _tagBg,
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _BlinkDot(),
                SizedBox(width: 7),
                Text(
                  'LIVE PRICES',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRect(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  final items = _buildItems();
                  final itemsWidth = items.isEmpty
                      ? 200.0
                      : items.length * 200.0;
                  final copies = math.min(
                    48,
                    math.max(
                      3,
                      (availableWidth * 2 / itemsWidth).ceil() + 1,
                    ),
                  );
                  final allItems = List.generate(copies, (_) => items)
                      .expand((e) => e)
                      .toList();
                  final totalW = itemsWidth * copies;
                  final rowChild = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: allItems,
                  );

                  return AnimatedBuilder(
                    animation: tickerCon.scrollAnimation,
                    builder: (context, child) {
                      final offset =
                          -(tickerCon.scrollAnimation.value * totalW / 2);
                      return OverflowBox(
                        alignment: Alignment.centerLeft,
                        minWidth: 0,
                        maxWidth: double.infinity,
                        child: Transform.translate(
                          offset: Offset(offset, 0),
                          child: child,
                        ),
                      );
                    },
                    child: rowChild,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlinkDot extends StatelessWidget {
  const _BlinkDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
