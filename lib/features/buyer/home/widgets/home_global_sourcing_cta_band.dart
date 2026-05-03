// lib/features/buyer/home/widgets/home_global_sourcing_cta_band.dart
//
// Horizontal CTA bar before “Source by category” (lite tint of hero emerald).

import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Lite wash of [AppColors.emeraldGreen] / hero — softer than [AppColors.primaryLight].
Color _heroEmeraldWash() {
  return Color.lerp(
    AppColors.backGroundWhite,
    AppColors.primaryLight,
    0.92,
  )!;
}

class HomeGlobalSourcingCtaBand extends StatelessWidget {
  const HomeGlobalSourcingCtaBand({super.key});

  static const double _breakpointStack = 840;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSize.space16,
        AppSize.space8,
        AppSize.space16,
        AppSize.space8,
      ),
      child: AppContainer(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space24,
          vertical: AppSize.space16,
        ),
        borderRadius: BorderRadius.circular(AppSize.radius12),
        backgroundColor: _heroEmeraldWash(),
        border: Border.all(
          color: AppColors.emeraldGreen.withValues(alpha: 0.08),
        ),
        child: LayoutBuilder(
          builder: (context, c) {
            final stack = c.maxWidth < _breakpointStack;
            final headline = AppText(
              text: 'Search products and suppliers worldwide',
              fontSize: AppSize.font16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              height: 1.45,
            );

            final actions = Wrap(
              spacing: AppSize.space12,
              runSpacing: AppSize.space12,
              alignment: WrapAlignment.end,
              children: const [
                _GlobalSourcingCtaPill(
                  icon: Icons.track_changes_rounded,
                  label: 'Request for Quotation',
                ),
                _GlobalSourcingCtaPill(
                  icon: Icons.business_rounded,
                  label: 'Sell on Agrikrop',
                ),
              ],
            );

            if (stack) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  headline,
                  const SizedBox(height: AppSize.space16),
                  actions,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: headline),
                const SizedBox(width: AppSize.space24),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _GlobalSourcingCtaPill(
                        icon: Icons.track_changes_rounded,
                        label: 'Request for Quotation',
                      ),
                      SizedBox(width: AppSize.space12),
                      _GlobalSourcingCtaPill(
                        icon: Icons.business_rounded,
                        label: 'Sell on Agrikrop',
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GlobalSourcingCtaPill extends StatelessWidget {
  const _GlobalSourcingCtaPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: AppContainer(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space12,
            vertical: AppSize.space12,
          ),
          borderRadius: BorderRadius.circular(AppSize.radius12),
          backgroundColor: AppColors.backGroundWhite,
          border: Border.all(color: AppColors.borderLight),
          boxShadows: [
            BoxShadow(
              color: AppColors.shadowBase.withValues(alpha: 0.06),
              blurRadius: AppSize.space8,
              offset: const Offset(0, AppSize.space2),
            ),
          ],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppContainer(
                width: 36,
                height: 36,
                borderRadius: BorderRadius.circular(AppSize.radius8),
                backgroundColor: AppColors.emerald100,
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: AppSize.icon20,
                  color: AppColors.emeraldGreen,
                ),
              ),
              const SizedBox(width: AppSize.space12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: AppText(
                  text: label,
                  fontSize: AppSize.font14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  height: 1.35,
                ),
              ),
              const SizedBox(width: AppSize.space8),
              Icon(
                Icons.north_east_rounded,
                size: AppSize.icon16,
                color: AppColors.iconSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
