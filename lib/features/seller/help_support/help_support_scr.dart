import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/shared/widgets/seller/screen_top_bar.dart';
import 'package:agri_market/features/seller/help_support/help_support_con.dart';
import '../../../shared/widgets/common/app_container.dart';
import '../../../shared/widgets/common/app_text.dart';
import '../../../shared/widgets/common/app_text_field.dart';

class HelpSupportScr extends StatelessWidget {
  final HelpSupportCon ctrlHelpSupport =
      Get.put(HelpSupportCon(), permanent: true);
  HelpSupportScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: Column(
          children: [
            const ScreenTopBar(
              title: 'Help & Support',
              subtitle: 'Find answers, contact us, or explore resources',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSize.space24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxWidth: AppSize.breakpointDesktop),
                    child: Column(
                      children: [
                        _HeroBanner(ctrlHelpSupport: ctrlHelpSupport),
                        const SizedBox(height: AppSize.space24),
                        LayoutBuilder(builder: (context, constraints) {
                          final isWide =
                              constraints.maxWidth > AppSize.breakpointTablet;
                          if (isWide) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: _FaqSection(
                                        ctrlHelpSupport: ctrlHelpSupport)),
                                const SizedBox(width: AppSize.space20),
                                Expanded(
                                  flex: 1,
                                  child: Column(children: [
                                    const _ContactSection(),
                                    const SizedBox(height: AppSize.space20),
                                    const _ResourcesSection(),
                                  ]),
                                ),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              _FaqSection(ctrlHelpSupport: ctrlHelpSupport),
                              const SizedBox(height: AppSize.space20),
                              const _ContactSection(),
                              const SizedBox(height: AppSize.space20),
                              const _ResourcesSection(),
                            ],
                          );
                        }),
                        const SizedBox(height: AppSize.space24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}

// ── Hero Banner ───────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.ctrlHelpSupport});
  final HelpSupportCon ctrlHelpSupport;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSize.space24), // mapped 28 to 24 grid
      borderRadius: BorderRadius.circular(AppSize.radius20),
      gradient: const LinearGradient(
        colors: [AppColors.emeraldGreen, AppColors.freshGreen],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        children: [
          AppContainer(
            width: AppSize.icon48, // mapped 52 to 48
            height: AppSize.icon48,
            backgroundColor: AppColors.textWhite.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppSize.radius20),
            child: const Center(
              child: Icon(Icons.support_agent_rounded,
                  size: AppSize.icon24, color: AppColors.iconWhite),
            ),
          ),
          const SizedBox(height: AppSize.space12), // mapped 14 to 12
          const AppText(
            text: 'How can we help you?',
            fontSize: AppSize.font24, // mapped 22 to 24
            fontWeight: FontWeight.w800,
            color: AppColors.textWhite,
          ),
          const SizedBox(height: AppSize.space8),
          const AppText(
            text: 'Search our knowledge base or browse the FAQs below',
            fontSize: AppSize.font12, // mapped 13 to 12
            color: AppColors.textWhite, // replaced white70
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSize.space20),
          // Search bar
          AppContainer(
            height: 48,
            backgroundColor: AppColors.backGroundWhite,
            borderRadius: BorderRadius.circular(AppSize.radius24),
            boxShadows: [
              BoxShadow(
                color: AppColors.shadowBase.withValues(alpha: 0.10),
                blurRadius: AppSize.space12,
                offset: const Offset(0, 4),
              ),
            ],
            child: Center(
              child: AppTextField(
                controller: ctrlHelpSupport.searchController,
                onChanged: ctrlHelpSupport.onSearch,
                hintText: 'Search FAQs, topics, or keywords...',
                hintStyle: const TextStyle(
                    fontSize: AppSize.font12, // mapped 13 to 12
                    color: AppColors.textSecondary),
                prefixIcon: Icons.search_rounded,
                prefixIconColor: AppColors.iconEmeraldGreen,
                iconSize: AppSize.icon20,
                fillColor: AppColors.backGroundTransparent,
                filled: true,
                customBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
                customFocusedBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: AppSize.space12), // mapped 14 to 12
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── FAQ Section ───────────────────────────────────────────────────────────

class _FaqSection extends StatelessWidget {
  const _FaqSection({required this.ctrlHelpSupport});
  final HelpSupportCon ctrlHelpSupport;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      backgroundColor: context.cardBg,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      border: Border.all(color: context.borderClr),
      boxShadows: [
        BoxShadow(
          color: AppColors.shadowBase.withValues(alpha: 0.03),
          blurRadius: AppSize.space8, // mapped 10 to 8
          offset: const Offset(0, 3),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSize.space20, AppSize.space16,
                AppSize.space20, AppSize.space12),
            child: Row(
              children: [
                AppContainer(
                  width: AppSize.icon32,
                  height: AppSize.icon32,
                  backgroundColor:
                      AppColors.badgeSuccessBg, // mapped emerald100
                  borderRadius: BorderRadius.circular(
                      AppSize.radius12), // mapped 10 to 12
                  child: const Center(
                    child: Icon(Icons.quiz_outlined,
                        size: AppSize.icon16,
                        color: AppColors.iconEmeraldGreen),
                  ),
                ),
                const SizedBox(width: AppSize.space12), // mapped 10 to 12
                Expanded(
                  child: AppText(
                    text: 'Frequently Asked Questions',
                    fontSize: AppSize.font12, // mapped 13 to 12
                    fontWeight: FontWeight.w700,
                    color: context.txtPrimary,
                  ),
                ),
                Obx(() => AppText(
                      text: '${ctrlHelpSupport.filteredFaqs.length} articles',
                      fontSize: AppSize.font10, // mapped 11 to 10
                      color: context.txtSecondary,
                    )),
              ],
            ),
          ),
          Divider(height: AppSize.borderWidth1, color: context.borderClr),
          Obx(() {
            if (ctrlHelpSupport.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.all(AppSize.space16),
                child: AppSkeletonListColumn(itemCount: 4),
              );
            }
            final faqs = ctrlHelpSupport.filteredFaqs;
            if (faqs.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(AppSize.space24),
                child: AppEmptyListState(
                  message: 'No results found',
                  icon: Icons.search_off_rounded,
                ),
              );
            }
            return Column(
              children: List.generate(
                faqs.length,
                (i) => _FaqTile(
                  faq: faqs[i],
                  index: i,
                  ctrlHelpSupport: ctrlHelpSupport,
                  last: i == faqs.length - 1,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({
    required this.faq,
    required this.index,
    required this.ctrlHelpSupport,
    required this.last,
  });
  final FaqItem faq;
  final int index;
  final HelpSupportCon ctrlHelpSupport;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final expanded = ctrlHelpSupport.expandedIndex.value == index;
      return Column(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => ctrlHelpSupport.toggleFaq(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                color: expanded
                    ? AppColors.badgeSuccessBg
                        .withValues(alpha: context.isDark ? 0.05 : 1.0)
                    : AppColors.backGroundTransparent,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.space20,
                    vertical: AppSize.space12), // mapped 14 to 12
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category chip
                          AppContainer(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.space8,
                                vertical: AppSize.space2),
                            backgroundColor: AppColors.badgeSuccessBg,
                            borderRadius:
                                BorderRadius.circular(AppSize.radius4),
                            child: AppText(
                              text: faq.category,
                              fontSize: AppSize.font8, // mapped 9 to 8
                              fontWeight: FontWeight.w700,
                              color: AppColors.textEmeraldGreen,
                            ),
                          ),
                          const SizedBox(
                              height: AppSize.space4), // mapped 5 to 4
                          AppText(
                            text: faq.question,
                            fontSize: AppSize.font12, // mapped 13 to 12
                            fontWeight: FontWeight.w600,
                            color: expanded
                                ? AppColors.textEmeraldGreen
                                : context.txtPrimary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSize.space12),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: AppSize.icon20,
                        color: expanded
                            ? AppColors.iconEmeraldGreen
                            : context.txtSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: AppContainer(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                  AppSize.space20, 0, AppSize.space20, AppSize.space16),
              backgroundColor: AppColors.badgeSuccessBg
                  .withValues(alpha: context.isDark ? 0.05 : 1.0),
              child: AppText(
                text: faq.answer,
                fontSize: AppSize.font12,
                color: context.txtSecondary,
                height: 1.6,
              ),
            ),
            crossFadeState:
                expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
          if (!last)
            Divider(height: AppSize.borderWidth1, color: context.dividerClr),
        ],
      );
    });
  }
}

// ── Contact Section ───────────────────────────────────────────────────────

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      backgroundColor: context.cardBg,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      border: Border.all(color: context.borderClr),
      boxShadows: [
        BoxShadow(
          color: AppColors.shadowBase.withValues(alpha: 0.03),
          blurRadius: AppSize.space8,
          offset: const Offset(0, 3),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSize.space16, AppSize.space12,
                AppSize.space16, AppSize.space8),
            child: AppText(
              text: 'Contact Support',
              fontSize: AppSize.font12, // mapped 13 to 12
              fontWeight: FontWeight.w700,
              color: context.txtPrimary,
            ),
          ),
          Divider(height: AppSize.borderWidth1, color: context.borderClr),
          _ContactTile(
            icon: Icons.chat_bubble_outline_rounded,
            bg: AppColors.badgeInfoBg,
            fg: AppColors.badgeInfoText,
            title: 'Live Chat',
            subtitle: 'Avg. response: 2 min',
            onTap: () {},
          ),
          Divider(height: AppSize.borderWidth1, color: context.dividerClr),
          _ContactTile(
            icon: Icons.email_outlined,
            bg: AppColors.badgePurpleBg,
            fg: AppColors.badgePurpleText,
            title: 'Email Us',
            subtitle: 'support@agrimarket.com',
            onTap: () {},
          ),
          Divider(height: AppSize.borderWidth1, color: context.dividerClr),
          _ContactTile(
            icon: Icons.phone_outlined,
            bg: AppColors.badgeSuccessBg,
            fg: AppColors.textEmeraldGreen,
            title: 'Call Support',
            subtitle: '+92 51 111-AGRI',
            onTap: () {},
            last: true,
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.bg,
    required this.fg,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.last = false,
  });
  final IconData icon;
  final Color bg, fg;
  final String title, subtitle;
  final VoidCallback onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final RxBool isHovered = false.obs;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: GestureDetector(
        onTap: onTap,
        child: Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              color: isHovered.value
                  ? context.hoverBg
                  : AppColors.backGroundTransparent,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space16, vertical: AppSize.space12),
              child: Row(
                children: [
                  AppContainer(
                    width: AppSize.icon32, // mapped 36 to 32
                    height: AppSize.icon32,
                    backgroundColor: bg,
                    borderRadius: BorderRadius.circular(
                        AppSize.radius12), // mapped 10 to 12
                    child: Center(
                        child: Icon(icon,
                            size: AppSize.icon16,
                            color: fg)), // mapped 18 to 16
                  ),
                  const SizedBox(width: AppSize.space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                            text: title,
                            fontSize: AppSize.font12,
                            fontWeight: FontWeight.w700,
                            color: context.txtPrimary),
                        AppText(
                            text: subtitle,
                            fontSize: AppSize.font10,
                            color: context.txtSecondary),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: AppSize.icon12, color: context.txtSecondary),
                ],
              ),
            )),
      ),
    );
  }
}

// ── Resources Section ─────────────────────────────────────────────────────

class _ResourcesSection extends StatelessWidget {
  const _ResourcesSection();

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      backgroundColor: context.cardBg,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      border: Border.all(color: context.borderClr),
      boxShadows: [
        BoxShadow(
          color: AppColors.shadowBase.withValues(alpha: 0.03),
          blurRadius: AppSize.space8,
          offset: const Offset(0, 3),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSize.space16, AppSize.space12,
                AppSize.space16, AppSize.space8),
            child: AppText(
              text: 'Quick Resources',
              fontSize: AppSize.font12, // mapped 13 to 12
              fontWeight: FontWeight.w700,
              color: context.txtPrimary,
            ),
          ),
          Divider(height: AppSize.borderWidth1, color: context.borderClr),
          _ResourceTile(
            icon: Icons.menu_book_outlined,
            label: 'Documentation',
            onTap: () {},
          ),
          Divider(height: AppSize.borderWidth1, color: context.dividerClr),
          _ResourceTile(
            icon: Icons.play_circle_outline_rounded,
            label: 'Video Tutorials',
            onTap: () {},
          ),
          Divider(height: AppSize.borderWidth1, color: context.dividerClr),
          _ResourceTile(
            icon: Icons.bug_report_outlined,
            label: 'Report a Problem',
            onTap: () {},
          ),
          Divider(height: AppSize.borderWidth1, color: context.dividerClr),
          _ResourceTile(
            icon: Icons.lightbulb_outline_rounded,
            label: 'Feature Requests',
            onTap: () {},
            last: true,
          ),
        ],
      ),
    );
  }
}

class _ResourceTile extends StatelessWidget {
  const _ResourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.last = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final RxBool isHovered = false.obs;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: GestureDetector(
        onTap: onTap,
        child: Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              color: isHovered.value
                  ? context.hoverBg
                  : AppColors.backGroundTransparent,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space16, vertical: AppSize.space12),
              child: Row(
                children: [
                  Icon(icon,
                      size: AppSize.icon16, color: AppColors.iconEmeraldGreen),
                  const SizedBox(width: AppSize.space12),
                  Expanded(
                    child: AppText(
                        text: label,
                        fontSize: AppSize.font12,
                        fontWeight: FontWeight.w600,
                        color: context.txtPrimary),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: AppSize.icon12,
                      color: context.txtSecondary), // mapped 11 to 12
                ],
              ),
            )),
      ),
    );
  }
}
