// ── Sidebar Widget ─────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../side_bar_con.dart';
import 'logout_button.dart';
import 'nav_item.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key, required this.c});
  final SellerSideBarCon c;

  @override
  Widget build(BuildContext context) {
    // Responsive width: 72px (icon only) on small screens, 230px on large
    final double sidebarWidth =
        MediaQuery.of(context).size.width < 900 ? 72 : 230;
    final bool isCollapsed = sidebarWidth <= 72;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: sidebarWidth,
      decoration: const BoxDecoration(
        color: CColors.backGroundWhite,
        border: Border(
            right: BorderSide(
                color: CColors.borderGray, width: CSize.borderWidth1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo ──────────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? CSize.space12 : CSize.space16,
              vertical: CSize.space16,
            ),
            child: isCollapsed
                ? Image.asset('assets/logo/Agri Krop.png',
                    height: 32, width: 32, fit: BoxFit.contain)
                : Image.asset('assets/logo/Agri Krop.png', height: 40),
          ),

          const Divider(height: 1, thickness: 0.5, color: Color(0xFFE2E8F0)),
          const SizedBox(height: CSize.space8),

          // ── Nav Items ─────────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? CSize.space8 : CSize.space10,
                vertical: CSize.space4,
              ),
              itemCount: SellerSideBarCon.navItems.length,
              itemBuilder: (context, index) => NavItemWidget(
                item: SellerSideBarCon.navItems[index],
                index: index,
                c: c,
                isCollapsed: isCollapsed,
              ),
            ),
          ),

          // ── Divider + Logout ───────────────────────────────────────────────
          const Divider(height: 1, thickness: 0.5, color: Color(0xFFE2E8F0)),
          LogoutButton(isCollapsed: isCollapsed),
        ],
      ),
    );
  }
}
