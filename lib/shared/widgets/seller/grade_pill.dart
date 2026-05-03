import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import '../common/app_container.dart';
import '../common/app_text.dart';

class GradePill extends StatelessWidget {
  final String grade;
  const GradePill({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.space8,
        vertical: AppSize.space2,
      ),
      backgroundColor:
          AppColors.badgeWarningBg, // Using warning bg for amber look
      borderRadius: BorderRadius.circular(AppSize.radius20),
      child: AppText(
        text: 'GRADE $grade',
        fontSize: AppSize.font10,
        fontWeight: FontWeight.w700,
        color: AppColors.badgeWarningText,
      ),
    );
  }
}
