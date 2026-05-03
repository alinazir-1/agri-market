import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

class HomeSectionHeading extends StatelessWidget {
  const HomeSectionHeading({
    super.key,
    required this.text,
    this.fontSize,
    this.letterSpacing,
    this.showAccentBar = false,
  });

  final String text;

  /// When null, uses [AppSize.font20] (section default). Use [AppSize.font24] for primary bands.
  final double? fontSize;

  /// Optional tracking (e.g. `0.12`–`0.2` for section titles).
  final double? letterSpacing;

  /// Centered emerald bar above title (B2B section anchor).
  final bool showAccentBar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space32,
        vertical: AppSize.space16,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showAccentBar) ...[
              AppContainer(
                width: 36,
                height: 3,
                borderRadius: BorderRadius.circular(2),
                backgroundColor: AppColors.emeraldGreen,
              ),
              const SizedBox(height: AppSize.space12),
            ],
            AppText(
              text: text,
              fontSize: fontSize ?? AppSize.font20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: letterSpacing,
            ),
          ],
        ),
      ),
    );
  }
}
