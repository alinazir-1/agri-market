// ── Nav Item ───────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../side_bar_con.dart';

class NavItemWidget extends StatelessWidget {
  const NavItemWidget({
    super.key,
    required this.item,
    required this.c,
    required this.isCollapsed,
  });

  final NavItem item;
  final SellerSideBarCon c;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isActive = c.selectedIndex.value == item.screenIndex;

      return Tooltip(
        message: isCollapsed ? item.title : '',
        preferBelow: false,
        child: GestureDetector(
          onTap: () => c.changeScreen(item.screenIndex),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 44,
            margin: const EdgeInsets.only(bottom: CSize.space4),
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? CSize.space10 : CSize.space12,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? CColors.backGroundFreshGreen.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
              border: isActive
                  ? Border.all(
                      color: CColors.borderEmeraldGreen.withOpacity(0.3),
                      width: CSize.borderWidth1)
                  : null,
            ),
            child: Row(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Icon(
                  item.icon,
                  size: CSize.icon20Medium,
                  color: isActive
                      ? CColors.iconEmeraldGreen
                      : const Color(0xFF6B7280),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: CSize.space10),
                  Expanded(
                    child: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: CSize.font13Small,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive
                            ? CColors.textEmeraldGreen
                            : CColors.textPrimary,
                      ),
                    ),
                  ),
                  if (isActive)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: CColors.backGroundEmeraldGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}
