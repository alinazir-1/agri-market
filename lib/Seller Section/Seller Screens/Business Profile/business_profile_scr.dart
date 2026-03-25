import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Core/Theme/app_theme.dart';
import '../../../Shared/Screens Common Widgets/screen_top_bar.dart';
import 'business_profile_con.dart';

class BusinessProfileScr extends StatelessWidget {
  BusinessProfileScr({super.key});
  BusinessProfileCon get c => Get.find<BusinessProfileCon>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: SafeArea(
        child: Column(
          children: [
            ScreenTopBar(
              title: 'Business Profile',
              subtitle: 'Manage your business information & identity',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(CSize.space24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 880),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfileHeaderCard(c: c),
                        const SizedBox(height: CSize.space20),
                        LayoutBuilder(builder: (context, constraints) {
                          final wide = constraints.maxWidth > 560;
                          if (wide) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(children: [
                                    _SectionCard(
                                      title: 'Business Information',
                                      icon: Icons.storefront_outlined,
                                      child: _BusinessInfoFields(c: c),
                                    ),
                                    const SizedBox(height: CSize.space20),
                                    _SectionCard(
                                      title: 'Address',
                                      icon: Icons.location_on_outlined,
                                      child: _AddressFields(c: c),
                                    ),
                                  ]),
                                ),
                                const SizedBox(width: CSize.space20),
                                Expanded(
                                  child: Column(children: [
                                    _SectionCard(
                                      title: 'Contact Information',
                                      icon: Icons.contact_phone_outlined,
                                      child: _ContactFields(c: c),
                                    ),
                                    const SizedBox(height: CSize.space20),
                                    _SectionCard(
                                      title: 'Banking Details',
                                      icon: Icons.account_balance_outlined,
                                      child: _BankingFields(c: c),
                                    ),
                                  ]),
                                ),
                              ],
                            );
                          }
                          return Column(children: [
                            _SectionCard(
                              title: 'Business Information',
                              icon: Icons.storefront_outlined,
                              child: _BusinessInfoFields(c: c),
                            ),
                            const SizedBox(height: CSize.space20),
                            _SectionCard(
                              title: 'Contact Information',
                              icon: Icons.contact_phone_outlined,
                              child: _ContactFields(c: c),
                            ),
                            const SizedBox(height: CSize.space20),
                            _SectionCard(
                              title: 'Address',
                              icon: Icons.location_on_outlined,
                              child: _AddressFields(c: c),
                            ),
                            const SizedBox(height: CSize.space20),
                            _SectionCard(
                              title: 'Banking Details',
                              icon: Icons.account_balance_outlined,
                              child: _BankingFields(c: c),
                            ),
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

// ── Profile Header ─────────────────────────────────────────────────────────

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({required this.c});
  final BusinessProfileCon c;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(CSize.radius20Large),
        border: Border.all(color: context.borderClr),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Gradient Banner ──────────────────────────────────────────────
          Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(CSize.radius20Large),
              ),
              gradient: const LinearGradient(
                colors: [Color(0xFF0E7C66), Color(0xFF2ED47A)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),

          // ── Avatar + Info ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
                CSize.space24, 0, CSize.space24, CSize.space20),
            child: Column(
              children: [
                // Avatar (overlaps banner)
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CColors.backGroundEmeraldGreen,
                          border: Border.all(
                              color: context.cardBg, width: 3),
                        ),
                        child: const Center(
                          child: Text(
                            'AS',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: CColors.textWhite,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Obx(() => c.isEditing.value
                            ? GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: CColors.backGroundEmeraldGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()),
                      ),
                    ],
                  ),
                ),

                // Name + category + badges
                Transform.translate(
                  offset: const Offset(0, -28),
                  child: Column(
                    children: [
                      Text(
                        c.businessName.text,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: context.txtPrimary,
                        ),
                      ),
                      const SizedBox(height: CSize.space4),
                      Obx(() => Text(
                            c.selectedCategory.value,
                            style: TextStyle(
                              fontSize: CSize.font13Small,
                              color: context.txtSecondary,
                            ),
                          )),
                      const SizedBox(height: CSize.space10),
                      Wrap(
                        spacing: CSize.space8,
                        children: [
                          _Badge(
                              label: 'Verified',
                              icon: Icons.verified_rounded,
                              bg: const Color(0xFFD1FAE5),
                              fg: CColors.textEmeraldGreen),
                          _Badge(
                              label: 'Active Seller',
                              icon: Icons.circle,
                              bg: const Color(0xFFDBEAFE),
                              fg: const Color(0xFF1D4ED8)),
                        ],
                      ),
                      const SizedBox(height: CSize.space16),

                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _StatItem(label: 'Products', value: '24'),
                          _StatDivider(),
                          _StatItem(label: 'Orders', value: '1,842'),
                          _StatDivider(),
                          _StatItem(label: 'Rating', value: '4.8 ★'),
                          _StatDivider(),
                          _StatItem(label: 'Member Since', value: 'Mar 2021'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Edit / Save buttons
                Transform.translate(
                  offset: const Offset(0, -16),
                  child: Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (c.isEditing.value) ...[
                            OutlinedButton(
                              onPressed: c.cancelEdit,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: context.txtSecondary,
                                side: BorderSide(color: context.borderClr),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      CSize.radius10Medium),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: CSize.space20,
                                    vertical: CSize.space10),
                              ),
                              child: const Text('Cancel',
                                  style: TextStyle(
                                      fontSize: CSize.font13Small,
                                      fontWeight: FontWeight.w600)),
                            ),
                            const SizedBox(width: CSize.space10),
                            ElevatedButton.icon(
                              onPressed: c.isSaving.value ? null : c.saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    CColors.backGroundEmeraldGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      CSize.radius10Medium),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: CSize.space20,
                                    vertical: CSize.space10),
                              ),
                              icon: c.isSaving.value
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white),
                                    )
                                  : const Icon(Icons.check_rounded, size: 16),
                              label: Text(
                                  c.isSaving.value ? 'Saving...' : 'Save Changes',
                                  style: const TextStyle(
                                      fontSize: CSize.font13Small,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ] else
                            ElevatedButton.icon(
                              onPressed: c.toggleEdit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    CColors.backGroundEmeraldGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      CSize.radius10Medium),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: CSize.space20,
                                    vertical: CSize.space10),
                              ),
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              label: const Text('Edit Profile',
                                  style: TextStyle(
                                      fontSize: CSize.font13Small,
                                      fontWeight: FontWeight.w700)),
                            ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Card ──────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });
  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
                    borderRadius:
                        BorderRadius.circular(CSize.radius10Medium),
                  ),
                  child: Icon(icon,
                      size: CSize.icon16Small,
                      color: CColors.iconEmeraldGreen),
                ),
                const SizedBox(width: CSize.space10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: CSize.font13Small,
                    fontWeight: FontWeight.w700,
                    color: context.txtPrimary,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderClr),
          Padding(
            padding: const EdgeInsets.all(CSize.space20),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ── Field Sections ─────────────────────────────────────────────────────────

class _BusinessInfoFields extends StatelessWidget {
  const _BusinessInfoFields({required this.c});
  final BusinessProfileCon c;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            _Field(
                label: 'Business Name',
                ctrl: c.businessName,
                icon: Icons.business_outlined,
                enabled: c.isEditing.value),
            const SizedBox(height: CSize.space14),
            _Field(
                label: 'Owner / Contact Name',
                ctrl: c.ownerName,
                icon: Icons.person_outline_rounded,
                enabled: c.isEditing.value),
            const SizedBox(height: CSize.space14),
            _DropdownField(
              label: 'Business Category',
              icon: Icons.category_outlined,
              value: c.selectedCategory.value,
              items: c.categories,
              enabled: c.isEditing.value,
              onChanged: (v) => c.selectedCategory.value = v!,
            ),
            const SizedBox(height: CSize.space14),
            _Field(
                label: 'Registration Number',
                ctrl: c.regNumber,
                icon: Icons.badge_outlined,
                enabled: c.isEditing.value),
            const SizedBox(height: CSize.space14),
            _Field(
                label: 'Tax / NTN Number',
                ctrl: c.taxNumber,
                icon: Icons.receipt_long_outlined,
                enabled: c.isEditing.value),
          ],
        ));
  }
}

class _ContactFields extends StatelessWidget {
  const _ContactFields({required this.c});
  final BusinessProfileCon c;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            _Field(
                label: 'Email Address',
                ctrl: c.email,
                icon: Icons.email_outlined,
                enabled: c.isEditing.value),
            const SizedBox(height: CSize.space14),
            _Field(
                label: 'Phone Number',
                ctrl: c.phone,
                icon: Icons.phone_outlined,
                enabled: c.isEditing.value),
            const SizedBox(height: CSize.space14),
            _Field(
                label: 'WhatsApp Number',
                ctrl: c.whatsapp,
                icon: Icons.chat_outlined,
                enabled: c.isEditing.value),
            const SizedBox(height: CSize.space14),
            _Field(
                label: 'Website',
                ctrl: c.website,
                icon: Icons.language_outlined,
                enabled: c.isEditing.value),
          ],
        ));
  }
}

class _AddressFields extends StatelessWidget {
  const _AddressFields({required this.c});
  final BusinessProfileCon c;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            _Field(
                label: 'Address Line 1',
                ctrl: c.addressLine1,
                icon: Icons.home_outlined,
                enabled: c.isEditing.value),
            const SizedBox(height: CSize.space14),
            _Field(
                label: 'Address Line 2',
                ctrl: c.addressLine2,
                icon: Icons.location_city_outlined,
                enabled: c.isEditing.value),
            const SizedBox(height: CSize.space14),
            Row(
              children: [
                Expanded(
                  child: _Field(
                      label: 'City',
                      ctrl: c.city,
                      icon: Icons.apartment_outlined,
                      enabled: c.isEditing.value),
                ),
                const SizedBox(width: CSize.space12),
                Expanded(
                  child: _Field(
                      label: 'State / Province',
                      ctrl: c.state,
                      icon: Icons.map_outlined,
                      enabled: c.isEditing.value),
                ),
              ],
            ),
            const SizedBox(height: CSize.space14),
            Row(
              children: [
                Expanded(
                  child: _Field(
                      label: 'Postal Code',
                      ctrl: c.pincode,
                      icon: Icons.pin_drop_outlined,
                      enabled: c.isEditing.value),
                ),
                const SizedBox(width: CSize.space12),
                Expanded(
                  child: _Field(
                      label: 'Country',
                      ctrl: c.country,
                      icon: Icons.flag_outlined,
                      enabled: c.isEditing.value),
                ),
              ],
            ),
          ],
        ));
  }
}

class _BankingFields extends StatelessWidget {
  const _BankingFields({required this.c});
  final BusinessProfileCon c;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            // Sensitive warning
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: CSize.space12, vertical: CSize.space8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF9C3),
                borderRadius: BorderRadius.circular(CSize.radius10Medium),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline_rounded,
                      size: 14, color: Color(0xFFA16207)),
                  const SizedBox(width: CSize.space8),
                  Expanded(
                    child: Text(
                      'Banking information is encrypted and stored securely.',
                      style: TextStyle(
                          fontSize: 10,
                          color: const Color(0xFF92400E)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: CSize.space14),
            _Field(
                label: 'Bank Name',
                ctrl: c.bankName,
                icon: Icons.account_balance_outlined,
                enabled: c.isEditing.value),
            const SizedBox(height: CSize.space14),
            _Field(
                label: 'Account Title',
                ctrl: c.accountTitle,
                icon: Icons.person_outline_rounded,
                enabled: c.isEditing.value),
            const SizedBox(height: CSize.space14),
            _Field(
                label: 'Account Number',
                ctrl: c.accountNumber,
                icon: Icons.credit_card_outlined,
                enabled: c.isEditing.value),
            const SizedBox(height: CSize.space14),
            Row(
              children: [
                Expanded(
                  child: _Field(
                      label: 'IBAN / IFSC Code',
                      ctrl: c.ifscCode,
                      icon: Icons.tag_outlined,
                      enabled: c.isEditing.value),
                ),
                const SizedBox(width: CSize.space12),
                Expanded(
                  child: _Field(
                      label: 'UPI / Easypaisa ID',
                      ctrl: c.upiId,
                      icon: Icons.qr_code_outlined,
                      enabled: c.isEditing.value),
                ),
              ],
            ),
          ],
        ));
  }
}

// ── Shared Field Widgets ───────────────────────────────────────────────────

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.ctrl,
    required this.icon,
    required this.enabled,
  });
  final String label;
  final TextEditingController ctrl;
  final IconData icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: context.txtSecondary,
          ),
        ),
        const SizedBox(height: CSize.space5),
        TextField(
          controller: ctrl,
          enabled: enabled,
          style: TextStyle(
              fontSize: CSize.font13Small, color: context.txtPrimary),
          decoration: InputDecoration(
            prefixIcon: Icon(icon,
                size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
            filled: true,
            fillColor: enabled ? context.inputFill : context.cardBg2,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: CSize.space12, vertical: CSize.space12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
              borderSide: BorderSide(color: context.borderClr),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
              borderSide: BorderSide(color: context.borderClr),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
              borderSide: BorderSide(color: context.borderClr),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
              borderSide: const BorderSide(
                  color: CColors.borderEmeraldGreen, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.enabled,
    required this.onChanged,
  });
  final String label;
  final IconData icon;
  final String value;
  final List<String> items;
  final bool enabled;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: context.txtSecondary,
          ),
        ),
        const SizedBox(height: CSize.space5),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: enabled ? onChanged : null,
          style: TextStyle(
              fontSize: CSize.font13Small, color: context.txtPrimary),
          dropdownColor: context.cardBg,
          decoration: InputDecoration(
            prefixIcon: Icon(icon,
                size: CSize.icon16Small, color: CColors.iconEmeraldGreen),
            filled: true,
            fillColor: enabled ? context.inputFill : context.cardBg2,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: CSize.space12, vertical: CSize.space12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
              borderSide: BorderSide(color: context.borderClr),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
              borderSide: BorderSide(color: context.borderClr),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
              borderSide: BorderSide(color: context.borderClr),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
              borderSide: const BorderSide(
                  color: CColors.borderEmeraldGreen, width: 1.5),
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
        ),
      ],
    );
  }
}

// ── Small helpers ──────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  const _Badge(
      {required this.label,
      required this.icon,
      required this.bg,
      required this.fg});
  final String label;
  final IconData icon;
  final Color bg, fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: CSize.space8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(CSize.radius50Circular),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: fg),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w700, color: fg)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CSize.space16),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: CSize.font16Medium,
                  fontWeight: FontWeight.w800,
                  color: context.txtPrimary)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 10, color: context.txtSecondary)),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 28,
        width: 1,
        color: context.borderClr);
  }
}
