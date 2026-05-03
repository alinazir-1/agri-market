// lib/features/seller/suppliers/widgets/supplier_components.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/data/models/supplier_model.dart';
import 'package:agri_market/common/loading/app_feature_loading_widgets.dart';
import 'package:agri_market/features/seller/suppliers/suppliers_con.dart';
import 'package:agri_market/shared/widgets/seller/screen_filter_chip.dart';
import 'package:agri_market/shared/widgets/seller/seller_metric_stat_row.dart';
import '../../../../shared/widgets/common/app_container.dart';
import '../../../../shared/widgets/common/app_elevated_button.dart';
import '../../../../shared/widgets/common/app_outlined_button.dart';
import '../../../../shared/widgets/common/app_text.dart';
import '../../../../shared/widgets/common/app_text_field.dart';

// ─── EXTENSIONS ───────────────────────────────────────────────────────────────
extension SupplierStatusUI on SupplierStatus {
  String get label => name.capitalizeFirst ?? name;

  Color get color => switch (this) {
        SupplierStatus.active => AppColors.badgeInfoText,
        SupplierStatus.pending => AppColors.badgeWarningText,
        SupplierStatus.inactive => AppColors.textSecondary,
        SupplierStatus.blocked => AppColors.badgeErrorText,
      };

  Color get bgColor => switch (this) {
        SupplierStatus.active => AppColors.badgeInfoBg,
        SupplierStatus.pending => AppColors.badgeWarningBg,
        SupplierStatus.inactive => AppColors.backgroundDivider,
        SupplierStatus.blocked => AppColors.badgeErrorBg,
      };
}

extension SupplierCategoryUI on SupplierCategory {
  String get label => name.capitalizeFirst ?? name;

  IconData get icon => switch (this) {
        SupplierCategory.grains => Icons.grass_rounded,
        SupplierCategory.vegetables => Icons.eco_rounded,
        SupplierCategory.fruits => Icons.apple_rounded,
        SupplierCategory.livestock => Icons.pets_rounded,
        SupplierCategory.dairy => Icons.water_drop_rounded,
      };

  Color get color => switch (this) {
        SupplierCategory.grains => AppColors.badgeWarningText,
        SupplierCategory.vegetables => AppColors.badgeSuccessText,
        SupplierCategory.fruits => AppColors.badgeErrorText,
        SupplierCategory.livestock => AppColors.badgePurpleText,
        SupplierCategory.dairy => AppColors.badgeInfoText,
      };

  Color get bgColor => switch (this) {
        SupplierCategory.grains => AppColors.badgeWarningBg,
        SupplierCategory.vegetables => AppColors.badgeSuccessBg,
        SupplierCategory.fruits => AppColors.badgeErrorBg,
        SupplierCategory.livestock => AppColors.badgePurpleBg,
        SupplierCategory.dairy => AppColors.badgeInfoBg,
      };
}

// ─── STAT ROW ─────────────────────────────────────────────────────────────────
class SuppStatRow extends StatelessWidget {
  final SuppliersCon c;
  const SuppStatRow({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(
        () => SellerMetricStatRow(
          items: [
            SellerMetricStatItem(
              label: 'TOTAL SUPPLIERS',
              value: '${c.totalCount}',
              badge: 'All time',
              icon: Icons.store_outlined,
              iconBg: AppColors.badgeSuccessBg,
              iconColor: AppColors.badgeSuccessText,
            ),
            SellerMetricStatItem(
              label: 'ACTIVE',
              value: '${c.activeCount}',
              badge: 'Supplying now',
              icon: Icons.check_circle_outline_rounded,
              iconBg: AppColors.badgeInfoBg,
              iconColor: AppColors.badgeInfoText,
            ),
            SellerMetricStatItem(
              label: 'PENDING REVIEW',
              value: '${c.pendingCount}',
              badge: 'Needs approval',
              icon: Icons.hourglass_empty_rounded,
              iconBg: AppColors.badgeWarningBg,
              iconColor: AppColors.badgeWarningText,
            ),
            SellerMetricStatItem(
              label: 'AVG RATING',
              value: c.avgRating.toStringAsFixed(1),
              badge: 'Out of 5.0',
              icon: Icons.star_outline_rounded,
              iconBg: AppColors.badgePurpleBg,
              iconColor: AppColors.badgePurpleText,
              valueColor: AppColors.badgePurpleText,
            ),
          ],
        ),
      );
}

// ─── FILTER BAR ───────────────────────────────────────────────────────────────
class SuppFilterBar extends StatelessWidget {
  final SuppliersCon c;
  const SuppFilterBar({super.key, required this.c});

  @override
  Widget build(BuildContext context) => AppContainer(
        backgroundColor: AppColors.backGroundWhite,
        border: const Border(bottom: BorderSide(color: AppColors.borderLight)),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space20, vertical: AppSize.space8),
        child: Obx(() => Row(
              children: [
                _chip('All', SupplierFilter.all),
                const SizedBox(width: AppSize.space8),
                _chip('Active', SupplierFilter.active),
                const SizedBox(width: AppSize.space8),
                _chip('Pending', SupplierFilter.pending),
                const SizedBox(width: AppSize.space8),
                _chip('Inactive', SupplierFilter.inactive),
                const SizedBox(width: AppSize.space8),
                _chip('Blocked', SupplierFilter.blocked),
                const Spacer(),
                /// 💀🔥 ---------------- Supplier Sort Dropdown ----------------
                AppContainer(
                  height: 32,
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSize.space12),
                  backgroundColor: AppColors.backGroundWhite,
                  borderRadius: BorderRadius.circular(AppSize.radius8),
                  border: Border.all(color: AppColors.borderLight),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<SupplierSort>(
                      value: c.sort.value,
                      isDense: true,
                      style: const TextStyle(
                          fontSize: AppSize.font10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          size: AppSize.icon16, color: AppColors.textSecondary),
                      items: const [
                        DropdownMenuItem(
                            value: SupplierSort.latest, child: Text('Latest')),
                        DropdownMenuItem(
                            value: SupplierSort.oldest, child: Text('Oldest')),
                        DropdownMenuItem(
                            value: SupplierSort.highestRating,
                            child: Text('Highest Rating')),
                        DropdownMenuItem(
                            value: SupplierSort.mostOrders,
                            child: Text('Most Orders')),
                      ],
                      onChanged: (v) {
                        if (v != null) c.setSort(v);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.space12),
                /// 💀🔥 ---------------- Add Supplier Button ----------------
                _SupplierActionButton(
                    onTap: () => showAddSupplierDialog(context, c)),
              ],
            )),
      );

  Widget _chip(String label, SupplierFilter filter) => ScreenFilterChip(
        label: label,
        isActive: c.activeFilter.value == filter,
        onTap: () => c.setFilter(filter),
      );
}

// ─── SUPPLIER TABLE ───────────────────────────────────────────────────────────
class SuppTable extends StatelessWidget {
  final SuppliersCon c;
  const SuppTable({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(() {
        if (c.isLoading.value) {
          return const AppSkeletonListColumn();
        }
        final list = c.filteredSuppliers;
        if (list.isEmpty) {
          return const AppEmptyListState(
            message: 'No suppliers found',
            icon: Icons.store_outlined,
          );
        }
        return Column(
          children: [
            _tableHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(AppSize.space20,
                    AppSize.space8, AppSize.space20, AppSize.space20),
                itemCount: list.length,
                itemBuilder: (_, i) => _SupplierRow(
                  supplier: list[i],
                  c: c,
                  isSelected: c.selectedSupplier.value?.id == list[i].id,
                ),
              ),
            ),
          ],
        );
      });

  Widget _tableHeader() => AppContainer(
        backgroundColor: AppColors.backgroundDivider,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space20, vertical: AppSize.space8),
        child: const Row(
          children: [
            Expanded(flex: 4, child: _H('SUPPLIER')),
            Expanded(flex: 3, child: _H('CONTACT')),
            Expanded(flex: 2, child: _H('LOCATION')),
            SizedBox(width: 60, child: _H('RATING')),
            SizedBox(width: 80, child: _H('SUPPLIED')),
            SizedBox(width: 72, child: _H('STATUS')),
            SizedBox(width: 72, child: _H('ACTIONS')),
          ],
        ),
      );

}

class _H extends StatelessWidget {
  final String text;
  const _H(this.text);

  @override
  Widget build(BuildContext context) => AppText(
      text: text,
      fontSize: AppSize.font8,
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
      letterSpacing: 0.5);
}

// ─── SUPPLIER ROW ─────────────────────────────────────────────────────────────
class _SupplierRow extends StatelessWidget {
  final SupplierModel supplier;
  final SuppliersCon c;
  final bool isSelected;

  const _SupplierRow(
      {required this.supplier, required this.c, required this.isSelected});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => c.selectSupplier(supplier),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: AppSize.space8),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space12, vertical: AppSize.space12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.badgeSuccessBg
                : AppColors.backGroundWhite,
            borderRadius: BorderRadius.circular(AppSize.radius8),
            border: Border.all(
                color: isSelected
                    ? AppColors.borderEmeraldGreen
                    : AppColors.borderLight),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    AppContainer(
                      width: 36,
                      height: 36,
                      backgroundColor: AppColors.emeraldGreen,
                      shape: BoxShape.circle,
                      child: Center(
                        child: AppText(
                            text: supplier.initials,
                            fontSize: AppSize.font10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textWhite),
                      ),
                    ),
                    const SizedBox(width: AppSize.space8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                              text: supplier.name,
                              fontSize: AppSize.font12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: AppSize.space2),
                          _CategoryBadge(supplier.category),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                        text: supplier.contactPerson,
                        fontSize: AppSize.font12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: AppSize.space2),
                    AppText(
                        text: supplier.email,
                        fontSize: AppSize.font8,
                        color: AppColors.textSecondary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: AppSize.icon12, color: AppColors.textSecondary),
                    const SizedBox(width: AppSize.space2),
                    Expanded(
                      child: AppText(
                          text: supplier.location,
                          fontSize: AppSize.font10,
                          color: AppColors.textSecondary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 60,
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: AppSize.icon12,
                        color: AppColors.badgeWarningText),
                    const SizedBox(width: AppSize.space2),
                    AppText(
                        text: supplier.rating.toStringAsFixed(1),
                        fontSize: AppSize.font12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary),
                  ],
                ),
              ),
              SizedBox(
                width: 80,
                child: AppText(
                    text:
                        '${supplier.totalSupplied.toStringAsFixed(0)} T\n${supplier.totalOrders} orders',
                    fontSize: AppSize.font10,
                    color: AppColors.textPrimary,
                    height: 1.4),
              ),
              SizedBox(width: 72, child: _StatusBadge(supplier.status)),
              SizedBox(
                width: 72,
                child: Row(
                  children: [
                    _ActionBtn(
                        icon: Icons.visibility_outlined,
                        color: AppColors.iconEmeraldGreen,
                        tooltip: 'View',
                        onTap: () => c.selectSupplier(supplier)),
                    const SizedBox(width: AppSize.space4),
                    _ActionBtn(
                        icon: Icons.delete_outline_rounded,
                        color: AppColors.iconError,
                        tooltip: 'Remove',
                        onTap: () => _confirmRemove(context, supplier, c)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  void _confirmRemove(BuildContext context, SupplierModel s, SuppliersCon c) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.radius20)),
        title: const AppText(
            text: 'Remove Supplier',
            fontSize: AppSize.font16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary),
        content: AppText(
            text:
                'Are you sure you want to remove "${s.name}"? This action cannot be undone.',
            fontSize: AppSize.font12,
            color: AppColors.textSecondary),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: const AppText(
                  text: 'Cancel', color: AppColors.textSecondary)),
          AppElevatedButton(
              backgroundColor: AppColors.iconError,
              borderRadius: AppSize.radius8,
              onPressed: () {
                c.removeSupplier(s.id);
                Get.back();
              },
              text: 'Remove',
              textColor: AppColors.textWhite,
              fontSize: AppSize.font12),
        ],
      ),
    );
  }
}

// ─── DETAIL PANEL ─────────────────────────────────────────────────────────────
class SuppDetailPanel extends StatelessWidget {
  final SuppliersCon c;
  const SuppDetailPanel({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(() {
        final s = c.selectedSupplier.value;
        if (s == null) return const SizedBox.shrink();

        return AppContainer(
          width: 260,
          backgroundColor: AppColors.backGroundWhite,
          border: const Border(left: BorderSide(color: AppColors.borderLight)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSize.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const AppText(
                        text: 'Supplier Profile',
                        fontSize: AppSize.font12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary),
                    const Spacer(),
                    GestureDetector(
                        onTap: () => c.selectedSupplier.value = null,
                        child: const Icon(Icons.close_rounded,
                            size: AppSize.icon16,
                            color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: AppSize.space16),
                Center(
                  child: Column(
                    children: [
                      AppContainer(
                        width: AppSize.space64,
                        height: AppSize.space64,
                        shape: BoxShape.circle,
                        backgroundColor: AppColors.emeraldGreen,
                        child: Center(
                          child: AppText(
                              text: s.initials,
                              fontSize: AppSize.font16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textWhite),
                        ),
                      ),
                      const SizedBox(height: AppSize.space8),
                      AppText(
                          text: s.name,
                          textAlign: TextAlign.center,
                          fontSize: AppSize.font12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary),
                      const SizedBox(height: AppSize.space4),
                      _StatusBadge(s.status),
                      const SizedBox(height: AppSize.space4),
                      _CategoryBadge(s.category),
                    ],
                  ),
                ),
                const SizedBox(height: AppSize.space16),
                const Divider(color: AppColors.borderLight, height: 1),
                const SizedBox(height: AppSize.space12),
                const _SectionTitle('CONTACT INFO'),
                const SizedBox(height: AppSize.space8),
                _InfoRow(Icons.person_outline_rounded, s.contactPerson),
                const SizedBox(height: AppSize.space4),
                _InfoRow(Icons.email_outlined, s.email),
                const SizedBox(height: AppSize.space4),
                _InfoRow(Icons.phone_outlined, s.phone),
                const SizedBox(height: AppSize.space4),
                _InfoRow(Icons.location_on_outlined, s.location),
                const SizedBox(height: AppSize.space12),
                const Divider(color: AppColors.borderLight, height: 1),
                const SizedBox(height: AppSize.space12),
                const _SectionTitle('PERFORMANCE'),
                const SizedBox(height: AppSize.space8),
                Row(
                  children: [
                    Expanded(
                        child: _MiniStat(
                            'Rating',
                            '${s.rating.toStringAsFixed(1)} ★',
                            AppColors.badgeWarningBg,
                            AppColors.badgeWarningText)),
                    const SizedBox(width: AppSize.space8),
                    Expanded(
                        child: _MiniStat('Orders', '${s.totalOrders}',
                            AppColors.badgeInfoBg, AppColors.badgeInfoText)),
                  ],
                ),
                const SizedBox(height: AppSize.space8),
                _MiniStat(
                    'Total Supplied',
                    '${s.totalSupplied.toStringAsFixed(1)} Tons',
                    AppColors.badgeSuccessBg,
                    AppColors.badgeSuccessText),
                const SizedBox(height: AppSize.space8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: AppSize.icon12, color: AppColors.textSecondary),
                    const SizedBox(width: AppSize.space4),
                    AppText(
                        text: 'Member since ${_formatDate(s.joinDate)}',
                        fontSize: AppSize.font10,
                        color: AppColors.textSecondary),
                  ],
                ),
                const SizedBox(height: AppSize.space16),
                const Divider(color: AppColors.borderLight, height: 1),
                const SizedBox(height: AppSize.space12),
                const _SectionTitle('ACTIONS'),
                const SizedBox(height: AppSize.space8),
                if (s.status == SupplierStatus.pending) ...[
                  _PanelActionBtn(
                      label: 'Approve Supplier',
                      icon: Icons.check_circle_outline_rounded,
                      color: AppColors.badgeSuccessText,
                      bgColor: AppColors.badgeSuccessBg,
                      onTap: () => c.approveSupplier(s.id)),
                  const SizedBox(height: AppSize.space8),
                ],
                if (s.status != SupplierStatus.blocked)
                  _PanelActionBtn(
                      label: 'Block Supplier',
                      icon: Icons.block_rounded,
                      color: AppColors.badgeErrorText,
                      bgColor: AppColors.badgeErrorBg,
                      onTap: () => c.blockSupplier(s.id)),
                if (s.status == SupplierStatus.blocked)
                  _PanelActionBtn(
                      label: 'Unblock Supplier',
                      icon: Icons.lock_open_outlined,
                      color: AppColors.badgeSuccessText,
                      bgColor: AppColors.badgeSuccessBg,
                      onTap: () => c.unblockSupplier(s.id)),
                const SizedBox(height: AppSize.space8),
                _PanelActionBtn(
                    label: 'Remove Supplier',
                    icon: Icons.delete_outline_rounded,
                    color: AppColors.textSecondary,
                    bgColor: AppColors.backgroundDivider,
                    onTap: () => c.removeSupplier(s.id)),
              ],
            ),
          ),
        );
      });

  String _formatDate(DateTime d) => '${_month(d.month)} ${d.year}';
  String _month(int m) => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][m - 1];
}

// ─── ADD SUPPLIER DIALOG ──────────────────────────────────────────────────────
class AddSupplierCon extends GetxController {
  final SuppliersCon parentCon;
  AddSupplierCon(this.parentCon);

  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final contact = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final location = TextEditingController();
  final Rx<SupplierCategory> category = SupplierCategory.grains.obs;
  final Rx<SupplierStatus> status = SupplierStatus.pending.obs;
  final RxBool isSubmitting = false.obs;

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 120));
    parentCon.addSupplier(SupplierModel(
      id: parentCon.generateId(),
      name: name.text.trim(),
      contactPerson: contact.text.trim(),
      email: email.text.trim(),
      phone: phone.text.trim(),
      location: location.text.trim(),
      category: category.value,
      status: status.value,
      rating: 0.0,
      totalSupplied: 0.0,
      totalOrders: 0,
      joinDate: DateTime.now(),
      avatarHex: '#065F46',
    ));
    isSubmitting.value = false;
    Get.back();
  }

  @override
  void onClose() {
    name.dispose();
    contact.dispose();
    email.dispose();
    phone.dispose();
    location.dispose();
    super.onClose();
  }
}

void showAddSupplierDialog(BuildContext context, SuppliersCon parentCon) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => _AddSupplierDialog(parentCon: parentCon),
  );
}

class _AddSupplierDialog extends StatelessWidget {
  final SuppliersCon parentCon;
  const _AddSupplierDialog({required this.parentCon});

  @override
  Widget build(BuildContext context) {
    final con = Get.put(AddSupplierCon(parentCon));
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.radius8)),
      backgroundColor: AppColors.backgroundSurface,
      child: SizedBox(
        width: 480,
        child: Padding(
          padding: const EdgeInsets.all(AppSize.space24),
          child: Form(
            key: con.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppContainer(
                      width: 36,
                      height: 36,
                      backgroundColor: AppColors.badgeSuccessBg,
                      borderRadius: BorderRadius.circular(AppSize.radius8),
                      child: const Icon(Icons.store_outlined,
                          size: AppSize.icon20,
                          color: AppColors.badgeSuccessText),
                    ),
                    const SizedBox(width: AppSize.space12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                              text: 'Add New Supplier',
                              fontSize: AppSize.font16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary),
                          AppText(
                              text: 'Fill in the supplier details below',
                              fontSize: AppSize.font10,
                              color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                    GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.close_rounded,
                            size: AppSize.icon20,
                            color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: AppSize.space20),
                Row(children: [
                  Expanded(
                      child: _Field(
                          controller: con.name,
                          label: 'Company Name',
                          hint: 'e.g. Green Fields Co.',
                          validator: (v) => v!.isEmpty ? 'Required' : null)),
                  const SizedBox(width: AppSize.space12),
                  Expanded(
                      child: _Field(
                          controller: con.contact,
                          label: 'Contact Person',
                          hint: 'e.g. Tariq Mahmood',
                          validator: (v) => v!.isEmpty ? 'Required' : null)),
                ]),
                const SizedBox(height: AppSize.space12),
                Row(children: [
                  Expanded(
                      child: _Field(
                          controller: con.email,
                          label: 'Email',
                          hint: 'supplier@example.com',
                          validator: (v) => v!.isEmpty ? 'Required' : null)),
                  const SizedBox(width: AppSize.space12),
                  Expanded(
                      child: _Field(
                          controller: con.phone,
                          label: 'Phone',
                          hint: '+92 300 0000000',
                          validator: (v) => v!.isEmpty ? 'Required' : null)),
                ]),
                const SizedBox(height: AppSize.space12),
                _Field(
                    controller: con.location,
                    label: 'Location',
                    hint: 'City, Province',
                    validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: AppSize.space12),
                Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                            text: 'Category',
                            fontSize: AppSize.font10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary),
                        const SizedBox(height: AppSize.space4),
                        Obx(() => _DropdownField<SupplierCategory>(
                            value: con.category.value,
                            items: SupplierCategory.values
                                .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: AppText(
                                        text: SupplierCategoryUI(e).label,
                                        fontSize: AppSize.font12)))
                                .toList(),
                            onChanged: (v) => con.category.value = v!)),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSize.space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                            text: 'Initial Status',
                            fontSize: AppSize.font10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary),
                        const SizedBox(height: AppSize.space4),
                        Obx(() => _DropdownField<SupplierStatus>(
                            value: con.status.value,
                            items: [
                              SupplierStatus.active,
                              SupplierStatus.pending
                            ]
                                .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: AppText(
                                        text: SupplierStatusUI(e).label,
                                        fontSize: AppSize.font12)))
                                .toList(),
                            onChanged: (v) => con.status.value = v!)),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: AppSize.space20),
                /// 💀🔥 ---------------- Add Supplier Dialog Actions ----------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppOutlinedButton(
                      onPressed: () => Get.back(),
                      text: 'Cancel',
                      height: 32,
                      width: 96,
                      borderRadius: AppSize.radius8,
                      textColor: AppColors.textSecondary,
                      border: const BorderSide(color: AppColors.borderLight),
                    ),
                    const SizedBox(width: AppSize.space8),
                    Obx(
                      () => AppElevatedButton(
                        backgroundColor: AppColors.emeraldGreen,
                        borderRadius: AppSize.radius8,
                        onPressed: con.submit,
                        isLoading: con.isSubmitting.value,
                        text: 'Add Supplier',
                        textColor: AppColors.textWhite,
                        fontSize: AppSize.font12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── SMALL SHARED WIDGETS ─────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final SupplierStatus status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) => AppContainer(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space8, vertical: AppSize.space2),
        backgroundColor: status.bgColor,
        borderRadius: BorderRadius.circular(AppSize.radius20),
        child: AppText(
            text: SupplierStatusUI(status).label,
            fontSize: AppSize.font8,
            fontWeight: FontWeight.w700,
            color: status.color),
      );
}

/// 💀🔥 ---------------- Supplier Action Hover Button ----------------
class _SupplierActionButton extends StatelessWidget {
  final VoidCallback onTap;
  _SupplierActionButton({required this.onTap});

  final RxBool _isHovered = false.obs;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Obx(() => AppContainer(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: AppSize.space16),
              backgroundColor: _isHovered.value
                  ? AppColors.textEmeraldGreen
                  : AppColors.emeraldGreen,
              borderRadius: BorderRadius.circular(AppSize.radius8),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded,
                      size: AppSize.icon16, color: AppColors.iconWhite),
                  SizedBox(width: AppSize.space4),
                  AppText(
                      text: 'Add Supplier',
                      fontSize: AppSize.font10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite),
                ],
              ),
            )),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final SupplierCategory category;
  const _CategoryBadge(this.category);

  @override
  Widget build(BuildContext context) => AppContainer(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space8, vertical: AppSize.space2),
        backgroundColor: category.bgColor,
        borderRadius: BorderRadius.circular(AppSize.radius20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(category.icon, size: AppSize.font8, color: category.color),
            const SizedBox(width: AppSize.space2),
            AppText(
                text: SupplierCategoryUI(category).label,
                fontSize: AppSize.font8,
                fontWeight: FontWeight.w700,
                color: category.color),
          ],
        ),
      );
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionBtn(
      {required this.icon,
      required this.color,
      required this.tooltip,
      required this.onTap});

  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip,
        child: GestureDetector(
          onTap: onTap,
          child: AppContainer(
            width: 28,
            height: 28,
            backgroundColor: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSize.radius4),
            child: Icon(icon, size: AppSize.icon12, color: color),
          ),
        ),
      );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => AppText(
      text: text,
      fontSize: AppSize.font8,
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
      letterSpacing: 0.5);
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: AppSize.icon12, color: AppColors.textSecondary),
          const SizedBox(width: AppSize.space4),
          Expanded(
              child: AppText(
                  text: text,
                  fontSize: AppSize.font12,
                  color: AppColors.textPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis)),
        ],
      );
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final Color bg, textColor;
  const _MiniStat(this.label, this.value, this.bg, this.textColor);

  @override
  Widget build(BuildContext context) => AppContainer(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.space8, vertical: AppSize.space8),
        backgroundColor: bg,
        borderRadius: BorderRadius.circular(AppSize.radius8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
                text: value,
                fontSize: AppSize.font12,
                fontWeight: FontWeight.w800,
                color: textColor),
            const SizedBox(height: AppSize.space2),
            AppText(
                text: label,
                fontSize: AppSize.font8,
                color: AppColors.textSecondary),
          ],
        ),
      );
}

class _PanelActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color, bgColor;
  final VoidCallback onTap;

  const _PanelActionBtn(
      {required this.label,
      required this.icon,
      required this.color,
      required this.bgColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AppContainer(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space12, vertical: AppSize.space8),
          backgroundColor: bgColor,
          borderRadius: BorderRadius.circular(AppSize.radius8),
          child: Row(
            children: [
              Icon(icon, size: AppSize.icon12, color: color),
              const SizedBox(width: AppSize.space8),
              AppText(
                  text: label,
                  fontSize: AppSize.font12,
                  fontWeight: FontWeight.w700,
                  color: color),
            ],
          ),
        ),
      );
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label, hint;
  final String? Function(String?)? validator;

  const _Field(
      {required this.controller,
      required this.label,
      required this.hint,
      this.validator});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
              text: label,
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary),
          const SizedBox(height: AppSize.space4),
          AppTextField(
              controller: controller,
              validator: validator,
              hintText: hint,
              filled: true,
              fillColor: AppColors.backgroundSurface,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space12, vertical: AppSize.space8)),
        ],
      );
}

class _DropdownField<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _DropdownField(
      {required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) => AppContainer(
        padding: const EdgeInsets.symmetric(horizontal: AppSize.space12),
        backgroundColor: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(AppSize.radius8),
        border: Border.all(color: AppColors.borderLight),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              isDense: true,
              items: items,
              onChanged: onChanged,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  size: AppSize.icon16, color: AppColors.textSecondary)),
        ),
      );
}
