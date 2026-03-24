import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Data/Models/supplier_model.dart';
import '../../../../Shared/Screens Common Widgets/screen_filter_chip.dart';
import '../../../../Shared/Screens Common Widgets/screen_stat_card.dart';
import '../suppliers_con.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  STAT ROW
// ─────────────────────────────────────────────────────────────────────────────

class SuppStatRow extends StatelessWidget {
  final SuppliersCon c;
  const SuppStatRow({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(() => Container(
        color: CColors.backGroundWhite,
        padding: const EdgeInsets.fromLTRB(
            CSize.space20, CSize.space12, CSize.space20, CSize.space12),
        child: Row(
          children: [
            Expanded(
              child: ScreenStatCard(
                label: 'TOTAL SUPPLIERS',
                value: '${c.totalCount}',
                badge: 'All Time',
                icon: Icons.store_outlined,
                iconBg: const Color(0xFFD1FAE5),
                iconColor: const Color(0xFF065F46),
                badgeBg: const Color(0xFFD1FAE5),
                badgeTextColor: const Color(0xFF065F46),
              ),
            ),
            const SizedBox(width: CSize.space12),
            Expanded(
              child: ScreenStatCard(
                label: 'ACTIVE',
                value: '${c.activeCount}',
                badge: 'Supplying Now',
                icon: Icons.check_circle_outline_rounded,
                iconBg: const Color(0xFFDBEAFE),
                iconColor: const Color(0xFF1E40AF),
                badgeBg: const Color(0xFFDBEAFE),
                badgeTextColor: const Color(0xFF1E40AF),
              ),
            ),
            const SizedBox(width: CSize.space12),
            Expanded(
              child: ScreenStatCard(
                label: 'PENDING REVIEW',
                value: '${c.pendingCount}',
                badge: 'Needs Approval',
                icon: Icons.hourglass_empty_rounded,
                iconBg: const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFD97706),
                badgeBg: const Color(0xFFFEF3C7),
                badgeTextColor: const Color(0xFFD97706),
              ),
            ),
            const SizedBox(width: CSize.space12),
            Expanded(
              child: ScreenStatCard(
                label: 'AVG RATING',
                value: c.avgRating.toStringAsFixed(1),
                badge: '★  Out of 5.0',
                icon: Icons.star_outline_rounded,
                iconBg: const Color(0xFFFCE7F3),
                iconColor: const Color(0xFF9D174D),
                badgeBg: const Color(0xFFFCE7F3),
                badgeTextColor: const Color(0xFF9D174D),
              ),
            ),
          ],
        ),
      ));
}

// ─────────────────────────────────────────────────────────────────────────────
//  FILTER BAR
// ─────────────────────────────────────────────────────────────────────────────

class SuppFilterBar extends StatelessWidget {
  final SuppliersCon c;
  const SuppFilterBar({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: CColors.backGroundWhite,
          border: Border(
            bottom: BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: CSize.space20, vertical: CSize.space10),
        child: Obx(() => Row(
              children: [
                // ── Filter Chips ─────────────────────────────────────────────
                _chip('All', SupplierFilter.all, c),
                const SizedBox(width: CSize.space8),
                _chip('Active', SupplierFilter.active, c),
                const SizedBox(width: CSize.space8),
                _chip('Pending', SupplierFilter.pending, c),
                const SizedBox(width: CSize.space8),
                _chip('Inactive', SupplierFilter.inactive, c),
                const SizedBox(width: CSize.space8),
                _chip('Blocked', SupplierFilter.blocked, c),

                const Spacer(),

                // ── Sort Dropdown ────────────────────────────────────────────
                Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(
                      horizontal: CSize.space12, vertical: 0),
                  decoration: BoxDecoration(
                    color: CColors.backGroundWhite,
                    borderRadius: BorderRadius.circular(CSize.radius20Large),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<SupplierSort>(
                      value: c.sort.value,
                      isDense: true,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: CColors.textPrimary),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          size: 14, color: CColors.textSecondary),
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

                const SizedBox(width: CSize.space12),

                // ── Add Supplier Button ──────────────────────────────────────
                GestureDetector(
                  onTap: () => showAddSupplierDialog(context, c),
                  child: Container(
                    height: 32,
                    padding:
                        const EdgeInsets.symmetric(horizontal: CSize.space16),
                    decoration: BoxDecoration(
                      color: CColors.backGroundEmeraldGreen,
                      borderRadius: BorderRadius.circular(CSize.radius20Large),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_rounded,
                            size: 14, color: CColors.iconWhite),
                        SizedBox(width: CSize.space4),
                        Text(
                          'Add Supplier',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: CColors.textWhite),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      );

  Widget _chip(String label, SupplierFilter filter, SuppliersCon c) =>
      ScreenFilterChip(
        label: label,
        isActive: c.activeFilter.value == filter,
        onTap: () => c.setFilter(filter),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
//  SUPPLIER TABLE
// ─────────────────────────────────────────────────────────────────────────────

class SuppTable extends StatelessWidget {
  final SuppliersCon c;
  const SuppTable({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(() {
        final list = c.filteredSuppliers;
        if (list.isEmpty) return _emptyState();
        return Column(
          children: [
            _tableHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                    CSize.space20, CSize.space8, CSize.space20, CSize.space20),
                itemCount: list.length,
                itemBuilder: (_, i) => _SupplierRow(
                    supplier: list[i],
                    c: c,
                    isSelected: c.selectedSupplier.value?.id == list[i].id),
              ),
            ),
          ],
        );
      });

  Widget _tableHeader() => Container(
        color: const Color(0xFFF1F5F9),
        padding: const EdgeInsets.symmetric(
            horizontal: CSize.space20, vertical: CSize.space8),
        child: const Row(
          children: [
            Expanded(flex: 4, child: _HeaderCell('SUPPLIER')),
            Expanded(flex: 3, child: _HeaderCell('CONTACT')),
            Expanded(flex: 2, child: _HeaderCell('LOCATION')),
            SizedBox(width: 60, child: _HeaderCell('RATING')),
            SizedBox(width: 80, child: _HeaderCell('SUPPLIED')),
            SizedBox(width: 72, child: _HeaderCell('STATUS')),
            SizedBox(width: 72, child: _HeaderCell('ACTIONS')),
          ],
        ),
      );

  Widget _emptyState() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(CSize.radius20Large),
              ),
              child: const Icon(Icons.store_outlined,
                  size: 28, color: Color(0xFF065F46)),
            ),
            const SizedBox(height: CSize.space12),
            const Text('No suppliers found',
                style: TextStyle(
                    fontSize: CSize.font16Medium,
                    fontWeight: FontWeight.w700,
                    color: CColors.textPrimary)),
            const SizedBox(height: CSize.space4),
            const Text('Try adjusting your filters or add a new supplier',
                style: TextStyle(
                    fontSize: CSize.font13Small, color: CColors.textSecondary)),
          ],
        ),
      );
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: CColors.textSecondary,
            letterSpacing: 0.5),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
//  SUPPLIER ROW CARD
// ─────────────────────────────────────────────────────────────────────────────

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
          margin: const EdgeInsets.only(bottom: CSize.space8),
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space12, vertical: CSize.space12),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFFECFDF5) : CColors.backGroundWhite,
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
            border: Border.all(
              color: isSelected
                  ? CColors.borderEmeraldGreen
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              // ── Avatar + Name + Category ───────────────────────────────────
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: supplier.avatarColor,
                      child: Text(
                        supplier.initials,
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: CSize.space8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(supplier.name,
                              style: const TextStyle(
                                  fontSize: CSize.font13Small,
                                  fontWeight: FontWeight.w700,
                                  color: CColors.textPrimary),
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          _CategoryBadge(supplier.category),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Contact ────────────────────────────────────────────────────
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(supplier.contactPerson,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: CColors.textPrimary),
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(supplier.email,
                        style: const TextStyle(
                            fontSize: 9, color: CColors.textSecondary),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),

              // ── Location ───────────────────────────────────────────────────
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 10, color: CColors.textSecondary),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(supplier.location,
                          style: const TextStyle(
                              fontSize: 10, color: CColors.textSecondary),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),

              // ── Rating ─────────────────────────────────────────────────────
              SizedBox(
                width: 60,
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 11, color: Color(0xFFD97706)),
                    const SizedBox(width: 2),
                    Text(supplier.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: CColors.textPrimary)),
                  ],
                ),
              ),

              // ── Supplied ───────────────────────────────────────────────────
              SizedBox(
                width: 80,
                child: Text(
                  '${supplier.totalSupplied.toStringAsFixed(0)} T\n${supplier.totalOrders} orders',
                  style: const TextStyle(
                      fontSize: 10, color: CColors.textPrimary, height: 1.4),
                ),
              ),

              // ── Status Badge ───────────────────────────────────────────────
              SizedBox(
                width: 72,
                child: _StatusBadge(supplier.status),
              ),

              // ── Actions ────────────────────────────────────────────────────
              SizedBox(
                width: 72,
                child: Row(
                  children: [
                    _ActionBtn(
                      icon: Icons.visibility_outlined,
                      color: CColors.iconEmeraldGreen,
                      tooltip: 'View',
                      onTap: () => c.selectSupplier(supplier),
                    ),
                    const SizedBox(width: CSize.space4),
                    _ActionBtn(
                      icon: Icons.delete_outline_rounded,
                      color: CColors.iconError,
                      tooltip: 'Remove',
                      onTap: () => _confirmRemove(context, supplier, c),
                    ),
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
            borderRadius: BorderRadius.circular(CSize.radius20Large)),
        title: const Text('Remove Supplier',
            style: TextStyle(
                fontSize: CSize.font16Medium,
                fontWeight: FontWeight.w800,
                color: CColors.textPrimary)),
        content: Text(
          'Are you sure you want to remove "${s.name}"? This action cannot be undone.',
          style: const TextStyle(
              fontSize: CSize.font13Small, color: CColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel',
                style: TextStyle(color: CColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CColors.iconError,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CSize.radius10Medium)),
            ),
            onPressed: () {
              c.removeSupplier(s.id);
              Get.back();
            },
            child: const Text('Remove',
                style: TextStyle(color: CColors.textWhite, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SUPPLIER DETAIL PANEL
// ─────────────────────────────────────────────────────────────────────────────

class SuppDetailPanel extends StatelessWidget {
  final SuppliersCon c;
  const SuppDetailPanel({super.key, required this.c});

  @override
  Widget build(BuildContext context) => Obx(() {
        final s = c.selectedSupplier.value;
        if (s == null) return const SizedBox.shrink();

        return Container(
          width: 260,
          decoration: const BoxDecoration(
            color: CColors.backGroundWhite,
            border: Border(left: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(CSize.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ───────────────────────────────────────────────────
                Row(
                  children: [
                    const Text('Supplier Profile',
                        style: TextStyle(
                            fontSize: CSize.font13Small,
                            fontWeight: FontWeight.w800,
                            color: CColors.textPrimary)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => c.selectedSupplier.value = null,
                      child: const Icon(Icons.close_rounded,
                          size: 16, color: CColors.textSecondary),
                    ),
                  ],
                ),

                const SizedBox(height: CSize.space16),

                // ── Avatar + Name ─────────────────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: s.avatarColor,
                        child: Text(
                          s.initials,
                          style: const TextStyle(
                              fontSize: CSize.font16Medium,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: CSize.space8),
                      Text(s.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: CSize.font13Small,
                              fontWeight: FontWeight.w800,
                              color: CColors.textPrimary)),
                      const SizedBox(height: CSize.space4),
                      _StatusBadge(s.status),
                      const SizedBox(height: CSize.space4),
                      _CategoryBadge(s.category),
                    ],
                  ),
                ),

                const SizedBox(height: CSize.space16),
                const Divider(color: Color(0xFFE2E8F0), height: 1),
                const SizedBox(height: CSize.space12),

                // ── Contact Info ──────────────────────────────────────────────
                const _PanelSectionTitle('CONTACT INFO'),
                const SizedBox(height: CSize.space8),
                _InfoRow(Icons.person_outline_rounded, s.contactPerson),
                const SizedBox(height: CSize.space5),
                _InfoRow(Icons.email_outlined, s.email),
                const SizedBox(height: CSize.space5),
                _InfoRow(Icons.phone_outlined, s.phone),
                const SizedBox(height: CSize.space5),
                _InfoRow(Icons.location_on_outlined, s.location),

                const SizedBox(height: CSize.space12),
                const Divider(color: Color(0xFFE2E8F0), height: 1),
                const SizedBox(height: CSize.space12),

                // ── Performance Stats ─────────────────────────────────────────
                const _PanelSectionTitle('PERFORMANCE'),
                const SizedBox(height: CSize.space8),
                Row(
                  children: [
                    Expanded(
                        child: _MiniStat(
                            'Rating',
                            '${s.rating.toStringAsFixed(1)} ★',
                            const Color(0xFFFEF3C7),
                            const Color(0xFFD97706))),
                    const SizedBox(width: CSize.space8),
                    Expanded(
                        child: _MiniStat('Orders', '${s.totalOrders}',
                            const Color(0xFFDBEAFE), const Color(0xFF1E40AF))),
                  ],
                ),
                const SizedBox(height: CSize.space8),
                _MiniStat(
                    'Total Supplied',
                    '${s.totalSupplied.toStringAsFixed(1)} Tons',
                    const Color(0xFFD1FAE5),
                    const Color(0xFF065F46)),

                const SizedBox(height: CSize.space8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 10, color: CColors.textSecondary),
                    const SizedBox(width: CSize.space4),
                    Text(
                      'Member since ${_formatDate(s.joinDate)}',
                      style: const TextStyle(
                          fontSize: 10, color: CColors.textSecondary),
                    ),
                  ],
                ),

                const SizedBox(height: CSize.space16),
                const Divider(color: Color(0xFFE2E8F0), height: 1),
                const SizedBox(height: CSize.space12),

                // ── Action Buttons ────────────────────────────────────────────
                const _PanelSectionTitle('ACTIONS'),
                const SizedBox(height: CSize.space8),

                if (s.status == SupplierStatus.pending)
                  _PanelActionBtn(
                    label: 'Approve Supplier',
                    icon: Icons.check_circle_outline_rounded,
                    color: const Color(0xFF065F46),
                    bgColor: const Color(0xFFD1FAE5),
                    onTap: () => c.approveSupplier(s.id),
                  ),

                if (s.status == SupplierStatus.pending)
                  const SizedBox(height: CSize.space8),

                if (s.status != SupplierStatus.blocked)
                  _PanelActionBtn(
                    label: 'Block Supplier',
                    icon: Icons.block_rounded,
                    color: const Color(0xFFDC2626),
                    bgColor: const Color(0xFFFEE2E2),
                    onTap: () => c.blockSupplier(s.id),
                  ),

                if (s.status == SupplierStatus.blocked)
                  _PanelActionBtn(
                    label: 'Unblock Supplier',
                    icon: Icons.lock_open_outlined,
                    color: const Color(0xFF059669),
                    bgColor: const Color(0xFFD1FAE5),
                    onTap: () => c.unblockSupplier(s.id),
                  ),

                const SizedBox(height: CSize.space8),

                _PanelActionBtn(
                  label: 'Remove Supplier',
                  icon: Icons.delete_outline_rounded,
                  color: CColors.textSecondary,
                  bgColor: const Color(0xFFF3F4F6),
                  onTap: () {
                    c.removeSupplier(s.id);
                  },
                ),
              ],
            ),
          ),
        );
      });

  String _formatDate(DateTime d) => '${_month(d.month)} ${d.year}';

  String _month(int m) => [
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

// ─────────────────────────────────────────────────────────────────────────────
//  ADD SUPPLIER DIALOG
// ─────────────────────────────────────────────────────────────────────────────

void showAddSupplierDialog(BuildContext context, SuppliersCon c) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => _AddSupplierDialog(c: c),
  );
}

class _AddSupplierDialog extends StatefulWidget {
  final SuppliersCon c;
  const _AddSupplierDialog({required this.c});

  @override
  State<_AddSupplierDialog> createState() => _AddSupplierDialogState();
}

class _AddSupplierDialogState extends State<_AddSupplierDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _contact = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _location = TextEditingController();
  SupplierCategory _category = SupplierCategory.grains;
  SupplierStatus _status = SupplierStatus.pending;

  static const _avatarColors = [
    Color(0xFF065F46),
    Color(0xFF0891B2),
    Color(0xFFD97706),
    Color(0xFF7C3AED),
    Color(0xFFDC2626),
    Color(0xFF059669),
    Color(0xFF1E40AF),
    Color(0xFF9D174D),
  ];

  @override
  void dispose() {
    _name.dispose();
    _contact.dispose();
    _email.dispose();
    _phone.dispose();
    _location.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final color =
        _avatarColors[widget.c.suppliers.length % _avatarColors.length];
    widget.c.addSupplier(SupplierModel(
      id: widget.c.generateId(),
      name: _name.text.trim(),
      contactPerson: _contact.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      location: _location.text.trim(),
      category: _category,
      status: _status,
      rating: 0.0,
      totalSupplied: 0.0,
      totalOrders: 0,
      joinDate: DateTime.now(),
      avatarColor: color,
    ));
    Get.back();
  }

  @override
  Widget build(BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CSize.radius20Large)),
        child: SizedBox(
          width: 480,
          child: Padding(
            padding: const EdgeInsets.all(CSize.space24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title ─────────────────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1FAE5),
                          borderRadius:
                              BorderRadius.circular(CSize.radius10Medium),
                        ),
                        child: const Icon(Icons.store_outlined,
                            size: 18, color: Color(0xFF065F46)),
                      ),
                      const SizedBox(width: CSize.space12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Add New Supplier',
                              style: TextStyle(
                                  fontSize: CSize.font16Medium,
                                  fontWeight: FontWeight.w800,
                                  color: CColors.textPrimary)),
                          Text('Fill in the supplier details below',
                              style: TextStyle(
                                  fontSize: 10, color: CColors.textSecondary)),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.close_rounded,
                            size: 18, color: CColors.textSecondary),
                      ),
                    ],
                  ),

                  const SizedBox(height: CSize.space20),

                  // ── Row 1: Company + Contact ──────────────────────────────
                  Row(children: [
                    Expanded(
                        child: _Field(
                            controller: _name,
                            label: 'Company Name',
                            hint: 'e.g. Green Fields Co.',
                            validator: _required)),
                    const SizedBox(width: CSize.space12),
                    Expanded(
                        child: _Field(
                            controller: _contact,
                            label: 'Contact Person',
                            hint: 'e.g. Tariq Mahmood',
                            validator: _required)),
                  ]),

                  const SizedBox(height: CSize.space12),

                  // ── Row 2: Email + Phone ──────────────────────────────────
                  Row(children: [
                    Expanded(
                        child: _Field(
                            controller: _email,
                            label: 'Email',
                            hint: 'supplier@example.com',
                            validator: _required)),
                    const SizedBox(width: CSize.space12),
                    Expanded(
                        child: _Field(
                            controller: _phone,
                            label: 'Phone',
                            hint: '+92 300 0000000',
                            validator: _required)),
                  ]),

                  const SizedBox(height: CSize.space12),

                  // ── Row 3: Location ───────────────────────────────────────
                  _Field(
                      controller: _location,
                      label: 'Location',
                      hint: 'City, Province',
                      validator: _required),

                  const SizedBox(height: CSize.space12),

                  // ── Row 4: Category + Status ──────────────────────────────
                  Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Category',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: CColors.textSecondary)),
                          const SizedBox(height: CSize.space4),
                          _DropdownField<SupplierCategory>(
                            value: _category,
                            items: SupplierCategory.values
                                .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.label,
                                        style: const TextStyle(fontSize: 11))))
                                .toList(),
                            onChanged: (v) => setState(() => _category = v!),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: CSize.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Initial Status',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: CColors.textSecondary)),
                          const SizedBox(height: CSize.space4),
                          _DropdownField<SupplierStatus>(
                            value: _status,
                            items: [
                              SupplierStatus.active,
                              SupplierStatus.pending,
                            ]
                                .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.label,
                                        style: const TextStyle(fontSize: 11))))
                                .toList(),
                            onChanged: (v) => setState(() => _status = v!),
                          ),
                        ],
                      ),
                    ),
                  ]),

                  const SizedBox(height: CSize.space20),

                  // ── Buttons ───────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel',
                            style: TextStyle(
                                color: CColors.textSecondary, fontSize: 12)),
                      ),
                      const SizedBox(width: CSize.space8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CColors.backGroundEmeraldGreen,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(CSize.radius10Medium)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: CSize.space20,
                              vertical: CSize.space10),
                        ),
                        onPressed: _submit,
                        child: const Text('Add Supplier',
                            style: TextStyle(
                                color: CColors.textWhite,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;
}

// ─────────────────────────────────────────────────────────────────────────────
//  SMALL REUSABLE WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final SupplierStatus status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: CSize.space8, vertical: 2),
        decoration: BoxDecoration(
          color: status.bgColor,
          borderRadius: BorderRadius.circular(CSize.radius20Large),
        ),
        child: Text(status.label,
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w700, color: status.color)),
      );
}

class _CategoryBadge extends StatelessWidget {
  final SupplierCategory category;
  const _CategoryBadge(this.category);

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: CSize.space8, vertical: 2),
        decoration: BoxDecoration(
          color: category.bgColor,
          borderRadius: BorderRadius.circular(CSize.radius20Large),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(category.icon, size: 9, color: category.color),
            const SizedBox(width: 3),
            Text(category.label,
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: category.color)),
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
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(CSize.radius5Small),
            ),
            child: Icon(icon, size: 13, color: color),
          ),
        ),
      );
}

class _PanelSectionTitle extends StatelessWidget {
  final String text;
  const _PanelSectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: CColors.textSecondary,
            letterSpacing: 0.5),
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 11, color: CColors.textSecondary),
          const SizedBox(width: CSize.space5),
          Expanded(
            child: Text(text,
                style:
                    const TextStyle(fontSize: 11, color: CColors.textPrimary),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      );
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color bg;
  final Color textColor;

  const _MiniStat(this.label, this.value, this.bg, this.textColor);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: CSize.space10, vertical: CSize.space8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(CSize.radius10Medium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: CSize.font13Small,
                    fontWeight: FontWeight.w800,
                    color: textColor)),
            const SizedBox(height: 2),
            Text(label,
                style:
                    const TextStyle(fontSize: 9, color: CColors.textSecondary)),
          ],
        ),
      );
}

class _PanelActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
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
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space12, vertical: CSize.space10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(CSize.radius10Medium),
          ),
          child: Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: CSize.space8),
              Text(label,
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700, color: color)),
            ],
          ),
        ),
      );
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
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
          Text(label,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: CColors.textSecondary)),
          const SizedBox(height: CSize.space4),
          TextFormField(
            controller: controller,
            validator: validator,
            style: const TextStyle(fontSize: 11, color: CColors.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(fontSize: 11, color: CColors.textSecondary),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: CSize.space12, vertical: CSize.space10),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                borderSide: const BorderSide(color: CColors.borderEmeraldGreen),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                borderSide: const BorderSide(color: CColors.borderError),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                borderSide: const BorderSide(color: CColors.borderError),
              ),
            ),
          ),
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
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: CSize.space12, vertical: 0),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(CSize.radius10Medium),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            isDense: true,
            items: items,
            onChanged: onChanged,
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                size: 14, color: CColors.textSecondary),
          ),
        ),
      );
}
