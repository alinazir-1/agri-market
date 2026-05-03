// lib/features/seller/dashboard/dashboard_scr.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/common/loading/app_shimmer_loading.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/shared/widgets/seller/screen_top_bar.dart';
import 'package:agri_market/shared/widgets/seller/seller_metric_stat_row.dart';
import 'package:agri_market/features/seller/sidebar/side_bar_con.dart';
import 'package:agri_market/features/seller/dashboard/dashboard_con.dart';
import '../../../shared/widgets/common/app_container.dart';
import '../../../shared/widgets/common/app_text.dart';

class DashboardScr extends StatelessWidget {
  DashboardScr({super.key});

  final DashboardCon ctrlDashboard = Get.put(DashboardCon(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: Column(
          children: [
            const ScreenTopBar(
              title: 'Dashboard',
              subtitle: 'Welcome back! Here\'s what\'s happening today.',
            ),
            Expanded(
              child: Obx(() {
                final loading = ctrlDashboard.isLoading.value;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Offstage(
                      offstage: loading,
                      child: _DashboardLoadedBody(c: ctrlDashboard),
                    ),
                    if (loading)
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSize.space16),
                          child: AppPageSkeleton(
                            showSearchBar: false,
                            rowCount: 8,
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
    );
  }
}

// ── Loaded body (not gated by loading Obx; only shown when skeleton is off) ─

class _DashboardLoadedBody extends StatelessWidget {
  const _DashboardLoadedBody({required this.c});

  final DashboardCon c;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSize.space16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= AppSize.breakpointTablet;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatsRow(c: c),
              const SizedBox(height: AppSize.space16),
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 6, child: _RevenueChartCard(c: c)),
                    const SizedBox(width: AppSize.space16),
                    Expanded(
                        flex: 4, child: _TopProductsCard(c: c)),
                  ],
                )
              else
                Column(children: [
                  _RevenueChartCard(c: c),
                  const SizedBox(height: AppSize.space16),
                  _TopProductsCard(c: c),
                ]),
              const SizedBox(height: AppSize.space16),
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: _RecentOrdersCard(c: c)),
                    const SizedBox(width: AppSize.space16),
                    Expanded(
                      flex: 4,
                      child: Column(children: [
                        const DashQuickActionsCard(),
                        const SizedBox(height: AppSize.space16),
                        _ActivityFeedCard(c: c),
                      ]),
                    ),
                  ],
                )
              else
                Column(children: [
                  _RecentOrdersCard(c: c),
                  const SizedBox(height: AppSize.space16),
                  const DashQuickActionsCard(),
                  const SizedBox(height: AppSize.space16),
                  _ActivityFeedCard(c: c),
                ]),
              const SizedBox(height: AppSize.space24),
            ],
          );
        },
      ),
    );
  }
}

// ── Stats Row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final DashboardCon c;
  const _StatsRow({required this.c});

  @override
  Widget build(BuildContext context) {
    return SellerMetricStatRow(
      items: c.stats
          .map(
            (s) => SellerMetricStatItem(
              label: s.label,
              value: s.value,
              badge: s.trend,
              icon: s.icon,
              iconBg: s.iconBg,
              iconColor: s.iconColor,
            ),
          )
          .toList(),
    );
  }
}

// ── Revenue Chart ─────────────────────────────────────────────────────────────

class _RevenueChartCard extends StatelessWidget {
  final DashboardCon c;
  const _RevenueChartCard({required this.c});

  @override
  Widget build(BuildContext context) {
    final spots = c.revenueMonthly
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
    final maxY = c.revenueMonthly.reduce((a, b) => a > b ? a : b);

    return _DashCard(
      title: 'Revenue Overview',
      subtitle: 'Last 6 months',
      trailing: AppContainer(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space12,
            vertical: AppSize.space4), // Refactored
        backgroundColor: AppColors.badgeSuccessBg,
        borderRadius: BorderRadius.circular(AppSize.radius20), // Refactored
        child: const AppText(
          text: 'Monthly',
          fontSize: AppSize.font10, // Refactored
          fontWeight: FontWeight.w600,
          color: AppColors.textEmeraldGreen,
        ),
      ),
      child: SizedBox(
        height:
            220.0, // Used direct value instead of dirty AppSize fixed height
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: maxY * 1.2,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                  color: context.borderClr, strokeWidth: AppSize.borderWidth1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: AppSize.space48,
                  interval: maxY / 4,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return const SizedBox.shrink();
                    // NOTE: FLChart requires raw Text/TextStyle, AppText cannot be used
                    return Text(
                      '\$${(value / 1000).toStringAsFixed(0)}k',
                      style: TextStyle(
                          fontSize: AppSize.font10, // Refactored
                          color: context.txtSecondary),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: AppSize.space24,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= c.revenueLabels.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: AppSize.space8), // Refactored
                      child: Text(
                        c.revenueLabels[idx],
                        style: TextStyle(
                            fontSize: AppSize.font10, // Refactored
                            color: context.txtSecondary),
                      ),
                    );
                  },
                ),
              ),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.35,
                color: AppColors.emeraldGreen,
                barWidth: 2.5,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, bar, index) =>
                      FlDotCirclePainter(
                    radius: AppSize.space4,
                    color: AppColors.emeraldGreen,
                    strokeWidth: AppSize.borderWidth2,
                    strokeColor: AppColors.textWhite,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.emeraldGreen.withValues(alpha: 0.18),
                      AppColors.emeraldGreen.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => context.cardBg,
                getTooltipItems: (spots) => spots
                    .map((s) => LineTooltipItem(
                          '\$${(s.y / 1000).toStringAsFixed(1)}k',
                          TextStyle(
                            fontSize: AppSize.font12, // Refactored
                            fontWeight: FontWeight.w700,
                            color: context.txtPrimary,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Top Products ──────────────────────────────────────────────────────────────

class _TopProductsCard extends StatelessWidget {
  final DashboardCon c;
  const _TopProductsCard({required this.c});

  @override
  Widget build(BuildContext context) {
    return _DashCard(
      title: 'Top Products',
      subtitle: 'By revenue this month',
      child: Column(
        children: c.topProducts
            .asMap()
            .entries
            .map((e) => Padding(
                  padding: EdgeInsets.only(
                    bottom: e.key < c.topProducts.length - 1
                        ? AppSize.space12
                        : 0, // Refactored
                  ),
                  child: _TopProductItem(rank: e.key + 1, product: e.value),
                ))
            .toList(),
      ),
    );
  }
}

class _TopProductItem extends StatelessWidget {
  final int rank;
  final DashTopProduct product;
  const _TopProductItem({required this.rank, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppContainer(
              width: AppSize.space24, // Refactored
              height: AppSize.space24, // Refactored
              backgroundColor: context.appBg,
              borderRadius:
                  BorderRadius.circular(AppSize.radius4), // Refactored
              child: Center(
                child: AppText(
                  text: '$rank',
                  fontSize: AppSize.font10, // Refactored
                  fontWeight: FontWeight.w700,
                  color: context.txtSecondary,
                ),
              ),
            ),
            const SizedBox(width: AppSize.space8), // Refactored
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: product.name,
                    fontSize: AppSize.font12, // Refactored
                    fontWeight: FontWeight.w600,
                    color: context.txtPrimary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppText(
                    text: product.category,
                    fontSize: AppSize.font10, // Refactored
                    color: context.txtSecondary,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  text: product.revenue,
                  fontSize: AppSize.font12, // Refactored
                  fontWeight: FontWeight.w700,
                  color: context.txtPrimary,
                ),
                AppText(
                  text: product.units,
                  fontSize: AppSize.font10, // Refactored
                  color: context.txtSecondary,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSize.space8), // Refactored
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSize.radius4), // Refactored
          child: LinearProgressIndicator(
            value: product.progress,
            minHeight: AppSize.space4, // Refactored
            backgroundColor: context.appBg,
            valueColor: AlwaysStoppedAnimation<Color>(product.progressColor),
          ),
        ),
      ],
    );
  }
}

// ── Recent Orders ─────────────────────────────────────────────────────────────

class _RecentOrdersCard extends StatelessWidget {
  final DashboardCon c;
  const _RecentOrdersCard({required this.c});

  @override
  Widget build(BuildContext context) {
    return _DashCard(
      title: 'Recent Orders',
      subtitle: 'Latest 5 orders across all products',
      trailing: GestureDetector(
        onTap: () {
          try {
            Get.find<SellerSideBarCon>().changeScreen(3);
          } catch (_) {}
        },
        child:const MouseRegion(
          cursor: SystemMouseCursors.click,
          child:  AppText(
            text: 'View All →',
            fontSize: AppSize.font10, // Refactored
            fontWeight: FontWeight.w600,
            color: AppColors.textEmeraldGreen,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showDate = constraints.maxWidth > 500;
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(bottom: AppSize.space8), // Refactored
                child: Row(
                  children: [
                    _headerCell('ORDER', flex: 2),
                    _headerCell('BUYER', flex: 3),
                    _headerCell('PRODUCT', flex: 4),
                    _headerCell('AMOUNT', flex: 2),
                    if (showDate) _headerCell('DATE', flex: 3),
                    _headerCell('STATUS', flex: 2),
                  ],
                ),
              ),
              const Divider(
                  height: AppSize.borderWidth1, color: AppColors.borderLight),
              const SizedBox(height: AppSize.space8),
              ...c.recentOrders.map((order) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSize.space12),
                    child: Row(
                      children: [
                        _OrderCell(
                          flex: 2,
                          child: AppText(
                            text: order.id,
                            fontSize: AppSize.font12, // Refactored
                            fontWeight: FontWeight.w700,
                            color: AppColors.textEmeraldGreen,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _OrderCell(
                          flex: 3,
                          child: AppText(
                            text: order.buyer,
                            fontSize: AppSize.font12, // Refactored
                            fontWeight: FontWeight.w500,
                            color: context.txtPrimary,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _OrderCell(
                          flex: 4,
                          child: AppText(
                            text: order.product,
                            fontSize: AppSize.font12, // Refactored
                            color: context.txtSecondary,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _OrderCell(
                          flex: 2,
                          child: AppText(
                            text: order.amount,
                            fontSize: AppSize.font12, // Refactored
                            fontWeight: FontWeight.w600,
                            color: context.txtPrimary,
                          ),
                        ),
                        if (showDate)
                          _OrderCell(
                            flex: 3,
                            child: AppText(
                              text: order.date,
                              fontSize: AppSize.font10, // Refactored
                              color: context.txtSecondary,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        _OrderCell(
                          flex: 2,
                          child: AppContainer(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.space8,
                                vertical: AppSize.space4),
                            backgroundColor: order.statusBg,
                            borderRadius: BorderRadius.circular(
                                AppSize.radius20), // Refactored
                            child: AppText(
                              text: order.status,
                              fontSize: AppSize.font10, // Refactored
                              fontWeight: FontWeight.w700,
                              color: order.statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }

  Widget _headerCell(String label, {required int flex}) {
    return Expanded(
      flex: flex,
      child: AppText(
        text: label,
        fontSize: AppSize.font10, // Refactored
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _OrderCell extends StatelessWidget {
  final Widget child;
  final int flex;
  const _OrderCell({required this.child, required this.flex});

  @override
  Widget build(BuildContext context) => Expanded(flex: flex, child: child);
}

// ── Quick Actions ─────────────────────────────────────────────────────────────

class DashQuickActionsCard extends StatelessWidget {
  const DashQuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _DashCard(
      title: 'Quick Actions',
      subtitle: 'Common shortcuts',
      child: Wrap(
        spacing: AppSize.space12, // Refactored
        runSpacing: AppSize.space12, // Refactored
        children: DashboardCon.quickActions
            .map((qa) => _DashQuickActionBtn(qa: qa))
            .toList(),
      ),
    );
  }
}

class _DashQuickActionBtn extends StatelessWidget {
  final DashQuickAction qa;
  _DashQuickActionBtn({required this.qa});

  final RxBool _hovered = false.obs;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _hovered.value = true,
      onExit: (_) => _hovered.value = false,
      child: GestureDetector(
        onTap: () {
          final route = qa.namedRoute;
          if (route != null && route.isNotEmpty) {
            Get.toNamed(route);
            return;
          }
          try {
            Get.find<SellerSideBarCon>().changeScreen(qa.screenIndex);
          } catch (_) {}
        },
        child: Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space12,
                  vertical: AppSize.space8), // Refactored
              decoration: BoxDecoration(
                color:
                    _hovered.value ? AppColors.badgeSuccessBg : context.appBg,
                borderRadius:
                    BorderRadius.circular(AppSize.radius12), // Refactored
                border: Border.all(
                  color: _hovered.value
                      ? AppColors.borderEmeraldGreen
                      : context.borderClr,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    qa.icon,
                    size: AppSize.icon16, // Refactored
                    color: _hovered.value
                        ? AppColors.iconEmeraldGreen
                        : AppColors.iconSecondary,
                  ),
                  const SizedBox(width: AppSize.space8),
                  AppText(
                    text: qa.label,
                    fontSize: AppSize.font12, // Refactored
                    fontWeight: FontWeight.w600,
                    color: _hovered.value
                        ? AppColors.textEmeraldGreen
                        : context.txtPrimary,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

// ── Activity Feed ─────────────────────────────────────────────────────────────

class _ActivityFeedCard extends StatelessWidget {
  final DashboardCon c;
  const _ActivityFeedCard({required this.c});

  @override
  Widget build(BuildContext context) {
    return _DashCard(
      title: 'Recent Activity',
      subtitle: 'Today\'s updates',
      child: Column(
        children: c.activities
            .asMap()
            .entries
            .map((e) => Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        e.key < c.activities.length - 1 ? AppSize.space12 : 0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppContainer(
                        width: AppSize.space32,
                        height: AppSize.space32,
                        backgroundColor: e.value.iconBg,
                        borderRadius: BorderRadius.circular(
                            AppSize.radius12), // Refactored
                        child: Icon(e.value.icon,
                            size: AppSize.icon16, // Refactored
                            color: e.value.iconColor),
                      ),
                      const SizedBox(width: AppSize.space12), // Refactored
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: e.value.title,
                              fontSize: AppSize.font12, // Refactored
                              fontWeight: FontWeight.w600,
                              color: context.txtPrimary,
                            ),
                            const SizedBox(height: AppSize.space2),
                            AppText(
                              text: e.value.subtitle,
                              fontSize: AppSize.font10, // Refactored
                              color: context.txtSecondary,
                              height: 1.3,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSize.space8),
                      AppText(
                        text: e.value.time,
                        fontSize: AppSize.font10, // Refactored
                        color: context.txtSecondary,
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

// ── Shared Card Wrapper ───────────────────────────────────────────────────────

class _DashCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  const _DashCard({
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(AppSize.space20),
      backgroundColor: context.cardBg,
      borderRadius: BorderRadius.circular(AppSize.radius20), // Refactored
      border: Border.all(color: context.borderClr),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: title,
                      fontSize: AppSize.font16, // Refactored
                      fontWeight: FontWeight.w700,
                      color: context.txtPrimary,
                    ),
                    const SizedBox(height: AppSize.space2),
                    AppText(
                      text: subtitle,
                      fontSize: AppSize.font12, // Refactored
                      color: context.txtSecondary,
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: AppSize.space16),
          const Divider(
              height: AppSize.borderWidth1, color: AppColors.borderLight),
          const SizedBox(height: AppSize.space16),
          child,
        ],
      ),
    );
  }
}
