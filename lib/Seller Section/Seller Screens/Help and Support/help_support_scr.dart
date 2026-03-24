import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Core/Theme/app_theme.dart';
import '../../../Shared/Screens Common Widgets/screen_top_bar.dart';
import 'help_support_con.dart';

class HelpSupportScr extends StatelessWidget {
  final HelpSupportCon c = Get.put(HelpSupportCon());
  HelpSupportScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: SafeArea(
        child: Column(
          children: [
            ScreenTopBar(
              title: 'Help & Support',
              subtitle: 'Find answers, contact us, or explore resources',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(CSize.space24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      children: [
                        _HeroBanner(c: c),
                        const SizedBox(height: CSize.space24),
                        LayoutBuilder(builder: (context, constraints) {
                          final wide = constraints.maxWidth > 600;
                          if (wide) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: _FaqSection(c: c)),
                                const SizedBox(width: CSize.space20),
                                SizedBox(
                                  width: 260,
                                  child: Column(children: [
                                    _ContactSection(),
                                    const SizedBox(height: CSize.space20),
                                    _ResourcesSection(),
                                  ]),
                                ),
                              ],
                            );
                          }
                          return Column(children: [
                            _FaqSection(c: c),
                            const SizedBox(height: CSize.space20),
                            _ContactSection(),
                            const SizedBox(height: CSize.space20),
                            _ResourcesSection(),
                          ]);
                        }),
                        const SizedBox(height: CSize.space24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hero Banner ───────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.c});
  final HelpSupportCon c;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(CSize.space28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        gradient: const LinearGradient(
          colors: [Color(0xFF0E7C66), Color(0xFF1AA37A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(CSize.radius20Large),
            ),
            child: const Icon(Icons.support_agent_rounded,
                size: 28, color: Colors.white),
          ),
          const SizedBox(height: CSize.space14),
          const Text(
            'How can we help you?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: CSize.space8),
          const Text(
            'Search our knowledge base or browse the FAQs below',
            style: TextStyle(fontSize: 13, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: CSize.space20),
          // Search bar
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(CSize.radius24XLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: c.searchController,
              onChanged: c.onSearch,
              style: const TextStyle(
                  fontSize: CSize.font13Small,
                  color: CColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Search FAQs, topics, or keywords...',
                hintStyle: TextStyle(
                    fontSize: CSize.font13Small,
                    color: CColors.textSecondary),
                prefixIcon: Icon(Icons.search_rounded,
                    color: CColors.iconEmeraldGreen,
                    size: CSize.icon20Medium),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14),
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
  const _FaqSection({required this.c});
  final HelpSupportCon c;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(color: context.borderClr),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                CSize.space20, CSize.space16, CSize.space20, CSize.space12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: CColors.backgroundEmerald100,
                    borderRadius: BorderRadius.circular(CSize.radius10Medium),
                  ),
                  child: const Icon(Icons.quiz_outlined,
                      size: CSize.icon16Small,
                      color: CColors.iconEmeraldGreen),
                ),
                const SizedBox(width: CSize.space10),
                Expanded(
                  child: Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: CSize.font13Small,
                      fontWeight: FontWeight.w700,
                      color: context.txtPrimary,
                    ),
                  ),
                ),
                Obx(() => Text(
                      '${c.filteredFaqs.length} articles',
                      style: TextStyle(
                          fontSize: 11, color: context.txtSecondary),
                    )),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderClr),
          Obx(() {
            final faqs = c.filteredFaqs;
            if (faqs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(CSize.space40),
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 36, color: context.txtSecondary),
                    const SizedBox(height: CSize.space12),
                    Text('No results found',
                        style: TextStyle(
                            fontSize: CSize.font13Small,
                            fontWeight: FontWeight.w600,
                            color: context.txtPrimary)),
                    const SizedBox(height: 4),
                    Text('Try different keywords',
                        style: TextStyle(
                            fontSize: 11, color: context.txtSecondary)),
                  ],
                ),
              );
            }
            return Column(
              children: List.generate(
                faqs.length,
                (i) => _FaqTile(
                  faq: faqs[i],
                  index: i,
                  c: c,
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
    required this.c,
    required this.last,
  });
  final FaqItem faq;
  final int index;
  final HelpSupportCon c;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final expanded = c.expandedIndex.value == index;
      return Column(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => c.toggleFaq(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                color: expanded ? CColors.fillColor.withOpacity(
                    context.isDark ? 0.05 : 1.0) : Colors.transparent,
                padding: const EdgeInsets.symmetric(
                    horizontal: CSize.space20, vertical: CSize.space14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: CColors.backgroundEmerald100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              faq.category,
                              style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: CColors.textEmeraldGreen),
                            ),
                          ),
                          const SizedBox(height: CSize.space5),
                          Text(
                            faq.question,
                            style: TextStyle(
                              fontSize: CSize.font13Small,
                              fontWeight: FontWeight.w600,
                              color: expanded
                                  ? CColors.textEmeraldGreen
                                  : context.txtPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: CSize.space12),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: CSize.icon20Medium,
                        color: expanded
                            ? CColors.iconEmeraldGreen
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
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                  CSize.space20, 0, CSize.space20, CSize.space16),
              color: CColors.fillColor.withOpacity(
                  context.isDark ? 0.05 : 1.0),
              child: Text(
                faq.answer,
                style: TextStyle(
                  fontSize: 12,
                  color: context.txtSecondary,
                  height: 1.6,
                ),
              ),
            ),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
          if (!last) Divider(height: 1, color: context.dividerClr),
        ],
      );
    });
  }
}

// ── Contact Section ───────────────────────────────────────────────────────

class _ContactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(color: context.borderClr),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                CSize.space16, CSize.space14, CSize.space16, CSize.space10),
            child: Text(
              'Contact Support',
              style: TextStyle(
                fontSize: CSize.font13Small,
                fontWeight: FontWeight.w700,
                color: context.txtPrimary,
              ),
            ),
          ),
          Divider(height: 1, color: context.borderClr),
          _ContactTile(
            icon: Icons.chat_bubble_outline_rounded,
            bg: const Color(0xFFDBEAFE),
            fg: const Color(0xFF1D4ED8),
            title: 'Live Chat',
            subtitle: 'Avg. response: 2 min',
            onTap: () {},
          ),
          Divider(height: 1, color: context.dividerClr),
          _ContactTile(
            icon: Icons.email_outlined,
            bg: const Color(0xFFF3E8FF),
            fg: const Color(0xFF7C3AED),
            title: 'Email Us',
            subtitle: 'support@agrimarket.com',
            onTap: () {},
          ),
          Divider(height: 1, color: context.dividerClr),
          _ContactTile(
            icon: Icons.phone_outlined,
            bg: const Color(0xFFD1FAE5),
            fg: CColors.textEmeraldGreen,
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

class _ContactTile extends StatefulWidget {
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
  State<_ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends State<_ContactTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          color: _hovered ? context.hoverBg : Colors.transparent,
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space16, vertical: CSize.space12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.bg,
                  borderRadius: BorderRadius.circular(CSize.radius10Medium),
                ),
                child: Icon(widget.icon, size: 18, color: widget.fg),
              ),
              const SizedBox(width: CSize.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: context.txtPrimary)),
                    Text(widget.subtitle,
                        style: TextStyle(
                            fontSize: 10, color: context.txtSecondary)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 12, color: context.txtSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Resources Section ─────────────────────────────────────────────────────

class _ResourcesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(color: context.borderClr),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                CSize.space16, CSize.space14, CSize.space16, CSize.space10),
            child: Text(
              'Quick Resources',
              style: TextStyle(
                fontSize: CSize.font13Small,
                fontWeight: FontWeight.w700,
                color: context.txtPrimary,
              ),
            ),
          ),
          Divider(height: 1, color: context.borderClr),
          _ResourceTile(
            icon: Icons.menu_book_outlined,
            label: 'Documentation',
            onTap: () {},
          ),
          Divider(height: 1, color: context.dividerClr),
          _ResourceTile(
            icon: Icons.play_circle_outline_rounded,
            label: 'Video Tutorials',
            onTap: () {},
          ),
          Divider(height: 1, color: context.dividerClr),
          _ResourceTile(
            icon: Icons.bug_report_outlined,
            label: 'Report a Problem',
            onTap: () {},
          ),
          Divider(height: 1, color: context.dividerClr),
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

class _ResourceTile extends StatefulWidget {
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
  State<_ResourceTile> createState() => _ResourceTileState();
}

class _ResourceTileState extends State<_ResourceTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          color: _hovered ? context.hoverBg : Colors.transparent,
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space16, vertical: CSize.space12),
          child: Row(
            children: [
              Icon(widget.icon,
                  size: CSize.icon16Small,
                  color: CColors.iconEmeraldGreen),
              const SizedBox(width: CSize.space12),
              Expanded(
                child: Text(widget.label,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: context.txtPrimary)),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 11, color: context.txtSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
