// ── Sidebar Widget ─────────────────────────────────────────────────────────

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
          // ── Logo ────────────────────────────────────────────────────────
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

          // ── Nav Items ───────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? CSize.space8 : CSize.space10,
                vertical: CSize.space4,
              ),
              itemCount: SellerSideBarCon.sideBarEntries.length,
              itemBuilder: (context, index) {
                final entry = SellerSideBarCon.sideBarEntries[index];
                if (entry is SideBarHeading) {
                  return isCollapsed
                      ? const SizedBox(height: CSize.space12)
                      : _SectionHeading(title: entry.title);
                }
                return NavItemWidget(
                  item: entry as NavItem,
                  c: c,
                  isCollapsed: isCollapsed,
                );
              },
            ),
          ),

          // ── Divider + Logout ─────────────────────────────────────────────
          const Divider(height: 1, thickness: 0.5, color: Color(0xFFE2E8F0)),
          LogoutButton(isCollapsed: isCollapsed),
        ],
      ),
    );
  }
}

// ── Section Heading ─────────────────────────────────────────────────────────

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: CSize.space12,
        top: CSize.space12,
        bottom: CSize.space4,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Color(0xFF9CA3AF),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
