import 'package:flutter/material.dart';
import 'package:agri_market/core/constants/colors.dart';
import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_text.dart';

class CustomerAvatar extends StatelessWidget {
  final String initials;
  final String? avatarHex;
  final double size;

  const CustomerAvatar({
    super.key,
    required this.initials,
    this.avatarHex,
    this.size = 36,
  });

  // Helper to fix the avatarHex error
  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.emeraldGreen;
    try {
      final hexCode = hex.replaceAll('#', '').replaceAll('0xFF', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    } catch (_) {
      return AppColors.emeraldGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: size,
      height: size,
      backgroundColor: _parseColor(avatarHex),
      shape: BoxShape.circle,
      alignment: Alignment.center,
      child: AppText(
        text: initials,
        fontSize: size * 0.33,
        fontWeight: FontWeight.w800,
        color: AppColors.textWhite,
      ),
    );
  }
}
