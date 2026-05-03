// lib/features/buyer/cart/buyer_cart_scr.dart
//
// Full-screen procurement cart (B2B-style). Not a popup — dedicated route.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/cart/buyer_cart_con.dart';
import 'package:agri_market/features/buyer/cart/widgets/buyer_cart_widgets.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

class BuyerCartScr extends StatelessWidget {
  const BuyerCartScr({super.key});

  BuyerCartCon get c => Get.find<BuyerCartCon>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4EF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CartTopBar(onBack: () => Get.back<void>()),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Obx(() {
                    if (c.lines.isEmpty) {
                      return const AppEmptyListState(
                        message:
                            'Your procurement cart is empty. Add products from the marketplace or supplier catalog.',
                        icon: Icons.shopping_cart_outlined,
                      );
                    }
                    return LayoutBuilder(
                      builder: (context, box) {
                        final wide = box.maxWidth >= 900;
                        if (wide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: _LinesColumn(con: c, shrinkWrap: false),
                              ),
                              const SizedBox(width: AppSize.space24),
                              SizedBox(
                                width: 340,
                                child: BuyerCartSummaryPanel(con: c),
                              ),
                            ],
                          );
                        }
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _LinesColumn(con: c, shrinkWrap: true),
                              const SizedBox(height: AppSize.space20),
                              BuyerCartSummaryPanel(con: c),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartTopBar extends StatelessWidget {
  const _CartTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space32,
        vertical: AppSize.space12,
      ),
      backgroundColor: AppColors.backGroundWhite,
      border: const Border(
        bottom: BorderSide(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onBack,
              child: AppContainer(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                borderRadius: BorderRadius.circular(AppSize.radius8),
                border: Border.all(color: AppColors.borderLight),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: AppSize.icon20,
                  color: AppColors.iconEmeraldGreen,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSize.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                AppText(
                  text: 'Procurement cart',
                  fontSize: AppSize.font24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: AppSize.space4),
                AppText(
                  text:
                      'Review lots, suppliers, and quantities before checkout.',
                  fontSize: AppSize.font12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinesColumn extends StatelessWidget {
  const _LinesColumn({
    required this.con,
    required this.shrinkWrap,
  });

  final BuyerCartCon con;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final listView = Obx(() {
      final list = con.lines;
      return ListView.builder(
        shrinkWrap: shrinkWrap,
        physics: shrinkWrap
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: list.length,
        itemBuilder: (_, i) {
          final line = list[i];
          return BuyerCartLineCard(
            line: line,
            onInc: () => con.incrementQty(line.id),
            onDec: () => con.decrementQty(line.id),
            onRemove: () => con.removeLine(line.id),
          );
        },
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppContainer(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space16,
            vertical: AppSize.space12,
          ),
          backgroundColor: AppColors.backGroundWhite,
          borderRadius: BorderRadius.circular(AppSize.radius8),
          border: Border.all(color: AppColors.borderLight),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: AppSize.icon20,
                color: AppColors.iconEmeraldGreen,
              ),
              const SizedBox(width: AppSize.space12),
              const Expanded(
                child: AppText(
                  text:
                      'B2B procurement: negotiated pricing and delivery terms apply. You can adjust quantities in MT steps as shown per line.',
                  fontSize: AppSize.font12,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSize.space16),
        const AppText(
          text: 'Line items',
          fontSize: AppSize.font18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: AppSize.space12),
        if (shrinkWrap) listView else Expanded(child: listView),
      ],
    );
  }
}
