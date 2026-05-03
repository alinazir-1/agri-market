// lib/features/seller/suppliers/suppliers_con.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/data/models/supplier_model.dart';

enum SupplierFilter { all, active, pending, inactive, blocked }

enum SupplierSort { latest, oldest, highestRating, mostOrders }

class SuppliersCon extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rx<SupplierFilter> activeFilter = SupplierFilter.all.obs;
  final Rx<SupplierSort> sort = SupplierSort.latest.obs;
  final Rx<SupplierModel?> selectedSupplier = Rx<SupplierModel?>(null);
  final RxBool isLoading = false.obs;

  // ── Sample Data ────────────────────────────────────────────────────────────

  final RxList<SupplierModel> suppliers = <SupplierModel>[
    SupplierModel(
      id: 'S1',
      name: 'Green Fields Co.',
      contactPerson: 'Tariq Mahmood',
      email: 'tariq@greenfields.pk',
      phone: '+92 300 1234567',
      location: 'Gujranwala, Punjab',
      category: SupplierCategory.grains,
      status: SupplierStatus.active,
      rating: 4.8,
      totalSupplied: 320.5,
      totalOrders: 24,
      joinDate: DateTime(2024, 5, 10),
      avatarHex: '#065F46', // ✅ Fixed: Removed UI Color from Model
    ),
    SupplierModel(
      id: 'S2',
      name: 'Fresh Valley Farms',
      contactPerson: 'Nasreen Bibi',
      email: 'nasreen@freshvalley.pk',
      phone: '+92 321 9876543',
      location: 'Hyderabad, Sindh',
      category: SupplierCategory.vegetables,
      status: SupplierStatus.active,
      rating: 4.5,
      totalSupplied: 180.0,
      totalOrders: 17,
      joinDate: DateTime(2024, 8, 22),
      avatarHex: '#0891B2',
    ),
    SupplierModel(
      id: 'S3',
      name: 'Mango King Export',
      contactPerson: 'Asif Raza',
      email: 'asif@mangokingpk.com',
      phone: '+92 333 4567890',
      location: 'Multan, Punjab',
      category: SupplierCategory.fruits,
      status: SupplierStatus.active,
      rating: 4.9,
      totalSupplied: 510.0,
      totalOrders: 38,
      joinDate: DateTime(2023, 12, 1),
      avatarHex: '#D97706',
    ),
    SupplierModel(
      id: 'S4',
      name: 'Dairy Fresh Ltd.',
      contactPerson: 'Khalid Hussain',
      email: 'khalid@dairyfresh.pk',
      phone: '+92 311 2345678',
      location: 'Lahore, Punjab',
      category: SupplierCategory.dairy,
      status: SupplierStatus.active,
      rating: 4.2,
      totalSupplied: 95.0,
      totalOrders: 12,
      joinDate: DateTime(2025, 1, 15),
      avatarHex: '#7C3AED',
    ),
    SupplierModel(
      id: 'S5',
      name: 'Livestock Hub',
      contactPerson: 'Bashir Ahmed',
      email: 'bashir@livestockhub.pk',
      phone: '+92 345 6789012',
      location: 'Quetta, Balochistan',
      category: SupplierCategory.livestock,
      status: SupplierStatus.pending,
      rating: 3.8,
      totalSupplied: 44.0,
      totalOrders: 6,
      joinDate: DateTime(2025, 11, 3),
      avatarHex: '#DC2626',
    ),
    SupplierModel(
      id: 'S6',
      name: 'Citrus Grove Sargodha',
      contactPerson: 'Amjad Ali',
      email: 'amjad@citrusgrove.pk',
      phone: '+92 302 3456789',
      location: 'Sargodha, Punjab',
      category: SupplierCategory.fruits,
      status: SupplierStatus.inactive,
      rating: 3.5,
      totalSupplied: 72.0,
      totalOrders: 9,
      joinDate: DateTime(2024, 3, 20),
      avatarHex: '#059669',
    ),
    SupplierModel(
      id: 'S7',
      name: 'Wheat Masters',
      contactPerson: 'Imran Akhtar',
      email: 'imran@wheatmasters.pk',
      phone: '+92 315 8901234',
      location: 'Rawalpindi, Punjab',
      category: SupplierCategory.grains,
      status: SupplierStatus.pending,
      rating: 4.1,
      totalSupplied: 0.0,
      totalOrders: 0,
      joinDate: DateTime(2026, 2, 28),
      avatarHex: '#1E40AF',
    ),
  ].obs;

  // ── Computed ───────────────────────────────────────────────────────────────

  int get totalCount => suppliers.length;
  int get activeCount =>
      suppliers.where((s) => s.status == SupplierStatus.active).length;
  int get pendingCount =>
      suppliers.where((s) => s.status == SupplierStatus.pending).length;

  double get avgRating {
    if (suppliers.isEmpty) return 0;
    return suppliers.fold(0.0, (sum, s) => sum + s.rating) / suppliers.length;
  }

  List<SupplierModel> get filteredSuppliers {
    List<SupplierModel> list = List.from(suppliers);

    switch (activeFilter.value) {
      case SupplierFilter.active:
        list = list.where((s) => s.status == SupplierStatus.active).toList();
        break;
      case SupplierFilter.pending:
        list = list.where((s) => s.status == SupplierStatus.pending).toList();
        break;
      case SupplierFilter.inactive:
        list = list.where((s) => s.status == SupplierStatus.inactive).toList();
        break;
      case SupplierFilter.blocked:
        list = list.where((s) => s.status == SupplierStatus.blocked).toList();
        break;
      case SupplierFilter.all:
        break;
    }

    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list
          .where((s) =>
              s.name.toLowerCase().contains(q) ||
              s.contactPerson.toLowerCase().contains(q) ||
              s.email.toLowerCase().contains(q) ||
              s.location.toLowerCase().contains(q))
          .toList();
    }

    switch (sort.value) {
      case SupplierSort.latest:
        list.sort((a, b) => b.joinDate.compareTo(a.joinDate));
        break;
      case SupplierSort.oldest:
        list.sort((a, b) => a.joinDate.compareTo(b.joinDate));
        break;
      case SupplierSort.highestRating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SupplierSort.mostOrders:
        list.sort((a, b) => b.totalOrders.compareTo(a.totalOrders));
        break;
    }

    return list;
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void setFilter(SupplierFilter f) => activeFilter.value = f;
  void setSort(SupplierSort s) => sort.value = s;
  void onSearch(String val) => searchQuery.value = val;

  void selectSupplier(SupplierModel s) {
    selectedSupplier.value = selectedSupplier.value?.id == s.id ? null : s;
  }

  void addSupplier(SupplierModel s) => suppliers.add(s);

  void removeSupplier(String id) {
    suppliers.removeWhere((s) => s.id == id);
    if (selectedSupplier.value?.id == id) selectedSupplier.value = null;
  }

  void approveSupplier(String id) {
    final idx = suppliers.indexWhere((s) => s.id == id);
    if (idx == -1) return;
    final updated = suppliers[idx].copyWith(status: SupplierStatus.active);
    suppliers[idx] = updated;
    if (selectedSupplier.value?.id == id) selectedSupplier.value = updated;
  }

  void blockSupplier(String id) {
    final idx = suppliers.indexWhere((s) => s.id == id);
    if (idx == -1) return;
    final updated = suppliers[idx].copyWith(status: SupplierStatus.blocked);
    suppliers[idx] = updated;
    if (selectedSupplier.value?.id == id) selectedSupplier.value = updated;
  }

  void unblockSupplier(String id) {
    final idx = suppliers.indexWhere((s) => s.id == id);
    if (idx == -1) return;
    final updated = suppliers[idx].copyWith(status: SupplierStatus.active);
    suppliers[idx] = updated;
    if (selectedSupplier.value?.id == id) selectedSupplier.value = updated;
  }

  String generateId() => 'S${DateTime.now().millisecondsSinceEpoch}';

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 180));
    isLoading.value = false;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
