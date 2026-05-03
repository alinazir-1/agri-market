import 'package:flutter/material.dart';
import 'package:agri_market/common/loading/app_shimmer_loading.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Small inline spinner (e.g. swap with button while loading).
class AppInlineProgress extends StatelessWidget {
  const AppInlineProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      backgroundColor: AppColors.backGroundTransparent,
      child: CircularProgressIndicator(
        strokeWidth: AppSize.borderWidth2,
        color: AppColors.emeraldGreen,
      ),
    );
  }
}

/// Shimmer column for list/table placeholders (5 rows).
class AppSkeletonListColumn extends StatelessWidget {
  const AppSkeletonListColumn({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space20,
        vertical: AppSize.space12,
      ),
      children: List.generate(
        itemCount,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: AppSize.space8),
          child: AppSkeletonBox(
            width: double.infinity,
            height: 80,
            borderRadius: BorderRadius.circular(AppSize.radius8),
          ),
        ),
      ),
    );
  }
}

/// Generic empty list / table state.
class AppEmptyListState extends StatelessWidget {
  const AppEmptyListState({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      alignment: Alignment.center,
      child: AppContainer(
        padding: const EdgeInsets.all(AppSize.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppSize.icon40, color: AppColors.textSecondary),
            AppContainer(height: AppSize.space16),
            AppText(
              text: message,
              fontSize: AppSize.font16,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
