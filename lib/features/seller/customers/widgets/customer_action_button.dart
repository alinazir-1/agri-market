import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import '../../../../shared/widgets/common/app_container.dart';

class CustomerActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color hoverBg;
  final Color hoverBorder;
  final VoidCallback onTap;

  CustomerActionButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.hoverBg,
    required this.hoverBorder,
    required this.onTap,
  });

  final RxBool _isHovered = false.obs;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      child: GestureDetector(
        onTap: onTap,
        child: Obx(() => AppContainer(
              width: 26,
              height: 26,
              backgroundColor:
                  _isHovered.value ? hoverBg : AppColors.backGroundWhite,
              borderRadius: BorderRadius.circular(AppSize.radius4),
              border: Border.all(
                color: _isHovered.value ? hoverBorder : AppColors.borderLight,
                width: AppSize.borderWidth1,
              ),
              child: Center(
                  child: Icon(icon, size: AppSize.icon16, color: iconColor)),
            )),
      ),
    );
  }
}
