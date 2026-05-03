// home_ticker_con.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Drives the home marquee [AnimationController]. Uses GetX ticker mixin — no [StatefulWidget].
class HomeTickerCon extends GetxController with GetSingleTickerProviderStateMixin {
  late final AnimationController scrollAnimation;

  @override
  void onInit() {
    super.onInit();
    scrollAnimation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  void pauseForRouteOverlay() {
    scrollAnimation.stop();
  }

  /// Restart marquee after returning from a pushed route (e.g. product detail).
  /// Always [stop] then [repeat] — do not gate on [isAnimating] (web can report stale state after [stop]).
  void resumeAfterRouteOverlay() {
    try {
      scrollAnimation.stop();
      scrollAnimation.repeat();
    } catch (_) {
      // Controller disposed; next [HomeTickerCon] instance will [repeat] in [onInit].
    }
  }

  @override
  void onClose() {
    scrollAnimation.dispose();
    super.onClose();
  }
}
