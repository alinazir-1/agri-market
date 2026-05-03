// home_promo_banner.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/features/buyer/home/home_con.dart';
import 'package:agri_market/core/constants/images.dart';

class HomePromoBanner extends StatelessWidget {
  const HomePromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final con = Get.find<HomeCon>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 300,
          child: Obx(() {
            final idx = con.bannerIndex.value;
            final data = HomeCon.bannerData[idx];

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 420),
              child: _BannerSlide(
                key: ValueKey(idx),
                idx: idx,
                data: data,
                onDotTap: (i) {
                  con.setBanner(i);
                  con.restartBannerAutoPlay();
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ── Slide ─────────────────────────────────────────────────────────────────────
class _BannerSlide extends StatelessWidget {
  final int idx;
  final Map<String, dynamic> data;
  final void Function(int) onDotTap;

  // Map each banner index to an image from CImages
  static const List<String> _images = [
    AppImages.homeBanner1, // NEW SEASON
    AppImages.homeBanner2, // BULK OFFER
    AppImages.homeBanner3, // LIVE NOW
    AppImages.homeBanner4, // ADVANCE BOOKING
    AppImages.brandingBanner, // TRUSTED
  ];

  const _BannerSlide({
    super.key,
    required this.idx,
    required this.data,
    required this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    final tagBg = data['tagBg'] as Color;
    final tagColor = data['tagColor'] as Color;
    final btnColor = data['btnColor'] as Color;
    final imagePath = _images[idx % _images.length];

    return SizedBox(
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.black.withValues(alpha: 0.2),
              child: const Icon(
                Icons.eco_outlined,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withValues(alpha: 0.55),
                  Colors.black.withValues(alpha: 0.25),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: tagBg,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    data['tag'] as String,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: tagColor,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data['title'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  data['sub'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  children: [
                    _CtaBtn(color: btnColor),
                    const Spacer(),
                    Row(
                      children: List.generate(HomeCon.bannerCount, (i) {
                        final on = i == idx;
                        return GestureDetector(
                          onTap: () => onDotTap(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(left: 4),
                            width: on ? 16 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: on
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── CTA Button ─────────────────────────────────────────────────────────────────
class _CtaBtn extends StatelessWidget {
  final Color color;
  const _CtaBtn({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Row(mainAxisSize: MainAxisSize.min, children: [
        Text('View',
            style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700)),
        SizedBox(width: 4),
        Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 13),
      ]),
    );
  }
}
