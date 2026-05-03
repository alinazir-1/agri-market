import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

/// Phone-shaped “calling” dialog (UI-only; wire WebRTC later).
class CallPhoneDialog extends StatelessWidget {
  const CallPhoneDialog({
    super.key,
    required this.peerName,
    required this.onMinimize,
    required this.onEndCall,
  });

  final String peerName;
  final VoidCallback onMinimize;
  final VoidCallback onEndCall;

  String get _initials {
    final p = peerName.trim().split(RegExp(r'\s+'));
    if (p.isEmpty) return '?';
    if (p.length == 1) return p.first.isNotEmpty ? p.first[0].toUpperCase() : '?';
    return '${p.first[0]}${p.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backGroundTransparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSize.space24,
        vertical: AppSize.space24,
      ),
      child: AppContainer(
        width: 300,
        constraints: const BoxConstraints(maxHeight: 560),
        padding: const EdgeInsets.all(AppSize.space8),
        borderRadius: BorderRadius.circular(AppSize.radius24),
        backgroundColor: context.cardBg,
        border: Border.all(color: context.borderClr, width: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppContainer(
              width: 72,
              height: 6,
              borderRadius: BorderRadius.circular(AppSize.radius20),
              backgroundColor: context.borderClr,
            ),
            const SizedBox(height: AppSize.space8),
            Row(
              children: [
                IconButton(
                  tooltip: 'Minimize',
                  onPressed: onMinimize,
                  icon: Icon(Icons.minimize_rounded,
                      size: AppSize.icon20, color: context.txtSecondary),
                ),
                const Spacer(),
                AppText(
                  text: 'Voice call',
                  fontSize: AppSize.font10,
                  fontWeight: FontWeight.w600,
                  color: context.txtSecondary,
                ),
                const Spacer(),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: AppSize.space24),
            AppText(
              text: 'Calling…',
              fontSize: AppSize.font16,
              fontWeight: FontWeight.w800,
              color: context.txtPrimary,
            ),
            const SizedBox(height: AppSize.space8),
            AppText(
              text: 'Connecting audio',
              fontSize: AppSize.font12,
              color: context.txtSecondary,
            ),
            const SizedBox(height: AppSize.space24),
            AppContainer(
              width: 88,
              height: 88,
              shape: BoxShape.circle,
              backgroundColor: AppColors.badgeSuccessBg,
              alignment: Alignment.center,
              child: AppText(
                text: _initials,
                fontSize: AppSize.font24,
                fontWeight: FontWeight.w800,
                color: AppColors.iconEmeraldGreen,
              ),
            ),
            const SizedBox(height: AppSize.space12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSize.space12),
              child: AppText(
                text: peerName,
                fontSize: AppSize.font14,
                fontWeight: FontWeight.w700,
                color: context.txtPrimary,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppSize.space8),
            AppText(
              text: 'You can minimize and keep chatting below.',
              fontSize: AppSize.font10,
              color: context.txtSecondary,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            const SizedBox(height: AppSize.space24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppContainer(
                  width: 56,
                  height: 56,
                  shape: BoxShape.circle,
                  backgroundColor: AppColors.badgeErrorBg,
                  alignment: Alignment.center,
                  child: IconButton(
                    tooltip: 'End call',
                    onPressed: onEndCall,
                    icon: const Icon(Icons.call_end_rounded,
                        color: AppColors.textError, size: AppSize.icon24),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.space16),
          ],
        ),
      ),
    );
  }
}

/// Bottom bar when call is minimized (tap to expand or end).
class CallMinimizedBar extends StatelessWidget {
  const CallMinimizedBar({
    super.key,
    required this.name,
    required this.onExpand,
    required this.onEnd,
  });

  final String name;
  final VoidCallback onExpand;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(AppSize.radius12),
      color: context.cardBg,
      child: AppContainer(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space12,
          vertical: AppSize.space8,
        ),
        borderRadius: BorderRadius.circular(AppSize.radius12),
        border: Border.all(color: context.borderClr),
        child: Row(
          children: [
            const Icon(Icons.phone_in_talk_rounded,
                size: AppSize.icon20, color: AppColors.emeraldGreen),
            const SizedBox(width: AppSize.space8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppText(
                    text: 'Call in progress',
                    fontSize: AppSize.font10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.emeraldGreen,
                  ),
                  AppText(
                    text: name,
                    fontSize: AppSize.font12,
                    fontWeight: FontWeight.w600,
                    color: context.txtPrimary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Expand',
              onPressed: onExpand,
              icon: Icon(Icons.open_in_full_rounded,
                  size: AppSize.icon20, color: context.txtSecondary),
            ),
            IconButton(
              tooltip: 'End call',
              onPressed: onEnd,
              icon: const Icon(Icons.call_end_rounded,
                  size: AppSize.icon20, color: AppColors.textError),
            ),
          ],
        ),
      ),
    );
  }
}
