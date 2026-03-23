// ── Logout Button ──────────────────────────────────────────────────────────

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, required this.isCollapsed});
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isCollapsed ? 'Log Out' : '',
      child: GestureDetector(
        onTap: () {
          if (kDebugMode) print('Log Out tapped');
          // Add your logout logic here
        },
        child: Container(
          height: 48,
          margin: EdgeInsets.symmetric(
            horizontal: isCollapsed ? CSize.space8 : CSize.space10,
            vertical: CSize.space10,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? CSize.space10 : CSize.space12,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFEE2E2),
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
          ),
          child: Row(
            mainAxisAlignment: isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              const Icon(Icons.logout_rounded,
                  size: CSize.icon20Medium, color: CColors.iconError),
              if (!isCollapsed) ...[
                const SizedBox(width: CSize.space10),
                const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: CSize.font13Small,
                    fontWeight: FontWeight.w700,
                    color: CColors.textError,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
