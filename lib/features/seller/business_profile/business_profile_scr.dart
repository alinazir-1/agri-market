import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/shared/widgets/seller/screen_top_bar.dart';
import 'package:agri_market/features/seller/business_profile/business_profile_con.dart';
import '../../../shared/widgets/common/app_container.dart';
import '../../../shared/widgets/common/app_text.dart';
import '../../../shared/widgets/common/app_text_field.dart';
import '../../../shared/widgets/common/app_elevated_button.dart';
import '../../../shared/widgets/common/app_outlined_button.dart';

class BusinessProfileScr extends StatelessWidget {
  final BusinessProfileCon ctrlBusinessProfile =
      Get.put(BusinessProfileCon(), permanent: true);

  BusinessProfileScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: Column(
          children: [
            const ScreenTopBar(
              title: 'Business Profile',
              subtitle: 'Manage your business information & identity',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSize.space24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxWidth: AppSize
                            .breakpointTablet), // mapped 880 to 860 breakpoint
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfileHeaderCard(
                            ctrlBusinessProfile: ctrlBusinessProfile),
                        const SizedBox(height: AppSize.space20),
                        LayoutBuilder(builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 600;
                          if (isWide) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(children: [
                                    _SectionCard(
                                      title: 'Business Information',
                                      icon: Icons.storefront_outlined,
                                      child: _BusinessInfoFields(
                                          ctrlBusinessProfile:
                                              ctrlBusinessProfile),
                                    ),
                                    const SizedBox(height: AppSize.space20),
                                    _SectionCard(
                                      title: 'Address',
                                      icon: Icons.location_on_outlined,
                                      child: _AddressFields(
                                          ctrlBusinessProfile:
                                              ctrlBusinessProfile),
                                    ),
                                  ]),
                                ),
                                const SizedBox(width: AppSize.space20),
                                Expanded(
                                  child: Column(children: [
                                    _SectionCard(
                                      title: 'Contact Information',
                                      icon: Icons.contact_phone_outlined,
                                      child: _ContactFields(
                                          ctrlBusinessProfile:
                                              ctrlBusinessProfile),
                                    ),
                                    const SizedBox(height: AppSize.space20),
                                    _SectionCard(
                                      title: 'Banking Details',
                                      icon: Icons.account_balance_outlined,
                                      child: _BankingFields(
                                          ctrlBusinessProfile:
                                              ctrlBusinessProfile),
                                    ),
                                  ]),
                                ),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              _SectionCard(
                                title: 'Business Information',
                                icon: Icons.storefront_outlined,
                                child: _BusinessInfoFields(
                                    ctrlBusinessProfile: ctrlBusinessProfile),
                              ),
                              const SizedBox(height: AppSize.space20),
                              _SectionCard(
                                title: 'Contact Information',
                                icon: Icons.contact_phone_outlined,
                                child: _ContactFields(
                                    ctrlBusinessProfile: ctrlBusinessProfile),
                              ),
                              const SizedBox(height: AppSize.space20),
                              _SectionCard(
                                title: 'Address',
                                icon: Icons.location_on_outlined,
                                child: _AddressFields(
                                    ctrlBusinessProfile: ctrlBusinessProfile),
                              ),
                              const SizedBox(height: AppSize.space20),
                              _SectionCard(
                                title: 'Banking Details',
                                icon: Icons.account_balance_outlined,
                                child: _BankingFields(
                                    ctrlBusinessProfile: ctrlBusinessProfile),
                              ),
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

// ── Profile Header ─────────────────────────────────────────────────────────

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({required this.ctrlBusinessProfile});
  final BusinessProfileCon ctrlBusinessProfile;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      backgroundColor: context.cardBg,
      borderRadius: BorderRadius.circular(AppSize.radius20),
      border: Border.all(color: context.borderClr),
      boxShadows: [
        BoxShadow(
          color: AppColors.shadowBase.withValues(alpha: 0.04),
          blurRadius: AppSize.space12,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        children: [
          // ── Gradient Banner ──────────────────────────────────────────────
          AppContainer(
            height: 80,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSize.radius20),
            ),
            gradient: const LinearGradient(
              colors: [AppColors.emeraldGreen, AppColors.freshGreen],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),

          // ── Avatar + Info ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSize.space24, 0, AppSize.space24, AppSize.space20),
            child: Column(
              children: [
                // Avatar (overlaps banner)
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Stack(
                    children: [
                      AppContainer(
                        width: 80,
                        height: 80,
                        shape: BoxShape.circle,
                        backgroundColor: AppColors.emeraldGreen,
                        border: Border.all(
                            color: context.cardBg, width: AppSize.borderWidth3),
                        child: const Center(
                          child: AppText(
                            text: 'AS',
                            fontSize: AppSize.font24, // mapped 28 to 24
                            fontWeight: FontWeight.w800,
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Obx(() => ctrlBusinessProfile.isEditing.value
                            ? GestureDetector(
                                onTap: () {},
                                child: AppContainer(
                                  width: 26, // mapped 24 to 26
                                  height: 26,
                                  backgroundColor: AppColors.emeraldGreen,
                                  shape: BoxShape.circle,
                                  child: const Center(
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      size: AppSize.icon12, // mapped 13 to 12
                                      color: AppColors.iconWhite,
                                    ),
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
                      AppText(
                        text: ctrlBusinessProfile.businessName.text,
                        fontSize: AppSize.font20,
                        fontWeight: FontWeight.w800,
                        color: context.txtPrimary,
                      ),
                      const SizedBox(height: AppSize.space4),
                      Obx(() => AppText(
                            text: ctrlBusinessProfile.selectedCategory.value,
                            fontSize: AppSize.font12, // mapped 13 to 12
                            color: context.txtSecondary,
                          )),
                      const SizedBox(
                          height: AppSize.space12), // mapped 10 to 12
                      const Wrap(
                        spacing: AppSize.space8,
                        runSpacing: AppSize.space8,
                        children: [
                          _Badge(
                              label: 'Verified',
                              icon: Icons.verified_rounded,
                              bg: AppColors.badgeSuccessBg, // 0xFFD1FAE5 mapped
                              fg: AppColors.textEmeraldGreen),
                          _Badge(
                              label: 'Active Seller',
                              icon: Icons.circle,
                              bg: AppColors.badgeInfoBg, // 0xFFDBEAFE mapped
                              fg: AppColors.textInfo), // 0xFF1D4ED8 mapped
                        ],
                      ),
                      const SizedBox(height: AppSize.space16),

                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const _StatItem(label: 'Products', value: '24'),
                          _StatDivider(context),
                          const _StatItem(label: 'Orders', value: '1,842'),
                          _StatDivider(context),
                          const _StatItem(label: 'Rating', value: '4.8 ★'),
                          _StatDivider(context),
                          const _StatItem(
                              label: 'Member Since', value: 'Mar 2021'),
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
                          if (ctrlBusinessProfile.isEditing.value) ...[
                            AppOutlinedButton(
                              onPressed: ctrlBusinessProfile.cancelEdit,
                              text: 'Cancel',
                              fontSize: AppSize.font12,
                              fontWeight: FontWeight.w600,
                              textColor: context.txtSecondary,
                              border: BorderSide(color: context.borderClr),
                              borderRadius: AppSize.radius12, // mapped 10 to 12
                            ),
                            const SizedBox(
                                width: AppSize.space12), // mapped 10 to 12
                            AppElevatedButton(
                              onPressed: ctrlBusinessProfile.isSaving.value
                                  ? null
                                  : ctrlBusinessProfile.saveProfile,
                              text: ctrlBusinessProfile.isSaving.value
                                  ? 'Saving...'
                                  : 'Save Changes',
                              icon: Icons.check_rounded,
                              iconSize: AppSize.icon16,
                              isLoading: ctrlBusinessProfile.isSaving.value,
                              fontSize: AppSize.font12,
                              fontWeight: FontWeight.w700,
                              textColor: AppColors.textWhite,
                              backgroundColor: AppColors.emeraldGreen,
                              borderRadius: AppSize.radius12,
                            ),
                          ] else
                            AppElevatedButton(
                              onPressed: ctrlBusinessProfile.toggleEdit,
                              text: 'Edit Profile',
                              icon: Icons.edit_outlined,
                              iconSize: AppSize.icon16,
                              fontSize: AppSize.font12,
                              fontWeight: FontWeight.w700,
                              textColor: AppColors.textWhite,
                              backgroundColor: AppColors.emeraldGreen,
                              borderRadius: AppSize.radius12,
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
    return AppContainer(
      width: double.infinity,
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
                  backgroundColor: AppColors.badgeSuccessBg,
                  borderRadius: BorderRadius.circular(
                      AppSize.radius12), // mapped 10 to 12
                  child: Center(
                    child: Icon(icon,
                        size: AppSize.icon16,
                        color: AppColors.iconEmeraldGreen),
                  ),
                ),
                const SizedBox(width: AppSize.space12), // mapped 10 to 12
                AppText(
                  text: title,
                  fontSize: AppSize.font12, // mapped 13 to 12
                  fontWeight: FontWeight.w700,
                  color: context.txtPrimary,
                ),
              ],
            ),
          ),
          Divider(height: AppSize.borderWidth1, color: context.borderClr),
          Padding(
            padding: const EdgeInsets.all(AppSize.space20),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ── Field Sections ─────────────────────────────────────────────────────────

class _BusinessInfoFields extends StatelessWidget {
  const _BusinessInfoFields({required this.ctrlBusinessProfile});
  final BusinessProfileCon ctrlBusinessProfile;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            _Field(
                label: 'Business Name',
                ctrl: ctrlBusinessProfile.businessName,
                icon: Icons.business_outlined,
                enabled: ctrlBusinessProfile.isEditing.value),
            const SizedBox(height: AppSize.space16), // mapped 14 to 16
            _Field(
                label: 'Owner / Contact Name',
                ctrl: ctrlBusinessProfile.ownerName,
                icon: Icons.person_outline_rounded,
                enabled: ctrlBusinessProfile.isEditing.value),
            const SizedBox(height: AppSize.space16),
            _DropdownField(
              label: 'Business Category',
              icon: Icons.category_outlined,
              value: ctrlBusinessProfile.selectedCategory.value,
              items: ctrlBusinessProfile.categories,
              enabled: ctrlBusinessProfile.isEditing.value,
              onChanged: (v) => ctrlBusinessProfile.selectedCategory.value = v!,
            ),
            const SizedBox(height: AppSize.space16),
            _Field(
                label: 'Registration Number',
                ctrl: ctrlBusinessProfile.regNumber,
                icon: Icons.badge_outlined,
                enabled: ctrlBusinessProfile.isEditing.value),
            const SizedBox(height: AppSize.space16),
            _Field(
                label: 'Tax / NTN Number',
                ctrl: ctrlBusinessProfile.taxNumber,
                icon: Icons.receipt_long_outlined,
                enabled: ctrlBusinessProfile.isEditing.value),
          ],
        ));
  }
}

class _ContactFields extends StatelessWidget {
  const _ContactFields({required this.ctrlBusinessProfile});
  final BusinessProfileCon ctrlBusinessProfile;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            _Field(
                label: 'Email Address',
                ctrl: ctrlBusinessProfile.email,
                icon: Icons.email_outlined,
                enabled: ctrlBusinessProfile.isEditing.value),
            const SizedBox(height: AppSize.space16),
            _Field(
                label: 'Phone Number',
                ctrl: ctrlBusinessProfile.phone,
                icon: Icons.phone_outlined,
                enabled: ctrlBusinessProfile.isEditing.value),
            const SizedBox(height: AppSize.space16),
            _Field(
                label: 'WhatsApp Number',
                ctrl: ctrlBusinessProfile.whatsapp,
                icon: Icons.chat_outlined,
                enabled: ctrlBusinessProfile.isEditing.value),
            const SizedBox(height: AppSize.space16),
            _Field(
                label: 'Website',
                ctrl: ctrlBusinessProfile.website,
                icon: Icons.language_outlined,
                enabled: ctrlBusinessProfile.isEditing.value),
          ],
        ));
  }
}

class _AddressFields extends StatelessWidget {
  const _AddressFields({required this.ctrlBusinessProfile});
  final BusinessProfileCon ctrlBusinessProfile;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            _Field(
                label: 'Address Line 1',
                ctrl: ctrlBusinessProfile.addressLine1,
                icon: Icons.home_outlined,
                enabled: ctrlBusinessProfile.isEditing.value),
            const SizedBox(height: AppSize.space16),
            _Field(
                label: 'Address Line 2',
                ctrl: ctrlBusinessProfile.addressLine2,
                icon: Icons.location_city_outlined,
                enabled: ctrlBusinessProfile.isEditing.value),
            const SizedBox(height: AppSize.space16),
            Row(
              children: [
                Expanded(
                  child: _Field(
                      label: 'City',
                      ctrl: ctrlBusinessProfile.city,
                      icon: Icons.apartment_outlined,
                      enabled: ctrlBusinessProfile.isEditing.value),
                ),
                const SizedBox(width: AppSize.space12),
                Expanded(
                  child: _Field(
                      label: 'State / Province',
                      ctrl: ctrlBusinessProfile.state,
                      icon: Icons.map_outlined,
                      enabled: ctrlBusinessProfile.isEditing.value),
                ),
              ],
            ),
            const SizedBox(height: AppSize.space16),
            Row(
              children: [
                Expanded(
                  child: _Field(
                      label: 'Postal Code',
                      ctrl: ctrlBusinessProfile.pincode,
                      icon: Icons.pin_drop_outlined,
                      enabled: ctrlBusinessProfile.isEditing.value),
                ),
                const SizedBox(width: AppSize.space12),
                Expanded(
                  child: _Field(
                      label: 'Country',
                      ctrl: ctrlBusinessProfile.country,
                      icon: Icons.flag_outlined,
                      enabled: ctrlBusinessProfile.isEditing.value),
                ),
              ],
            ),
          ],
        ));
  }
}

class _BankingFields extends StatelessWidget {
  const _BankingFields({required this.ctrlBusinessProfile});
  final BusinessProfileCon ctrlBusinessProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sensitive warning
        AppContainer(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space12, vertical: AppSize.space8),
          backgroundColor: AppColors.badgeWarningBg, // mapped 0xFFFEF9C3
          borderRadius:
              BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
          border: Border.all(
              color: AppColors.textWarning
                  .withValues(alpha: 0.3)), // mapped 0xFFFDE68A
          child: Row(
            children: [
              const Icon(Icons.lock_outline_rounded,
                  size: AppSize.icon12,
                  color:
                      AppColors.textWarning), // mapped 14 to 12, 0xFFA16207
              const SizedBox(width: AppSize.space8),
              Expanded(
                child: AppText(
                  text:
                      'Banking information is encrypted and stored securely.',
                  fontSize: AppSize.font10,
                  color: AppColors.textWarning, // mapped 0xFF92400E
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSize.space16), // mapped 14 to 16
        Obx(
          () => Column(
            children: [
              _Field(
                  label: 'Bank Name',
                  ctrl: ctrlBusinessProfile.bankName,
                  icon: Icons.account_balance_outlined,
                  enabled: ctrlBusinessProfile.isEditing.value),
              const SizedBox(height: AppSize.space16),
              _Field(
                  label: 'Account Title',
                  ctrl: ctrlBusinessProfile.accountTitle,
                  icon: Icons.person_outline_rounded,
                  enabled: ctrlBusinessProfile.isEditing.value),
              const SizedBox(height: AppSize.space16),
              _Field(
                  label: 'Account Number',
                  ctrl: ctrlBusinessProfile.accountNumber,
                  icon: Icons.credit_card_outlined,
                  enabled: ctrlBusinessProfile.isEditing.value),
              const SizedBox(height: AppSize.space16),
              Row(
                children: [
                  Expanded(
                    child: _Field(
                        label: 'IBAN / IFSC Code',
                        ctrl: ctrlBusinessProfile.ifscCode,
                        icon: Icons.tag_outlined,
                        enabled: ctrlBusinessProfile.isEditing.value),
                  ),
                  const SizedBox(width: AppSize.space12),
                  Expanded(
                    child: _Field(
                        label: 'UPI / Easypaisa ID',
                        ctrl: ctrlBusinessProfile.upiId,
                        icon: Icons.qr_code_outlined,
                        enabled: ctrlBusinessProfile.isEditing.value),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
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
        AppText(
          text: label,
          fontSize: AppSize.font10, // mapped 11 to 10
          fontWeight: FontWeight.w600,
          color: context.txtSecondary,
        ),
        const SizedBox(height: AppSize.space4), // mapped 5 to 4
        AppTextField(
          controller: ctrl,
          enabled: enabled,
          prefixIcon: icon,
          prefixIconColor: AppColors.iconEmeraldGreen,
          iconSize: AppSize.icon16,
          fillColor: enabled ? context.inputFill : context.cardBg2,
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSize.space12, vertical: AppSize.space12),
          customBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
            borderSide: BorderSide(color: context.borderClr),
          ),
          customFocusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.radius12),
            borderSide: const BorderSide(
                color: AppColors.borderEmeraldGreen,
                width: AppSize.borderWidth2), // mapped 1.5 to 2
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
        AppText(
          text: label,
          fontSize: AppSize.font10, // mapped 11 to 10
          fontWeight: FontWeight.w600,
          color: context.txtSecondary,
        ),
        const SizedBox(height: AppSize.space4), // mapped 5 to 4
        DropdownButtonFormField<String>(
          value: value,
          onChanged: enabled ? onChanged : null,
          style: TextStyle(
              fontSize: AppSize.font12,
              color: context.txtPrimary), // mapped 13 to 12
          dropdownColor: context.cardBg,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              size: AppSize.icon16, color: AppColors.textSecondary),
          decoration: InputDecoration(
            prefixIcon: Icon(icon,
                size: AppSize.icon16, color: AppColors.iconEmeraldGreen),
            filled: true,
            fillColor: enabled ? context.inputFill : context.cardBg2,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSize.space12, vertical: AppSize.space12),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppSize.radius12), // mapped 10 to 12
              borderSide: BorderSide(color: context.borderClr),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.radius12),
              borderSide: BorderSide(color: context.borderClr),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.radius12),
              borderSide: BorderSide(color: context.borderClr),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.radius12),
              borderSide: const BorderSide(
                  color: AppColors.borderEmeraldGreen,
                  width: AppSize.borderWidth2),
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: AppText(text: e)))
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
    return AppContainer(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSize.space8, vertical: AppSize.space4),
      backgroundColor: bg,
      borderRadius: BorderRadius.circular(AppSize.radiusCircular),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSize.icon12, color: fg),
          const SizedBox(width: AppSize.space4),
          AppText(
              text: label,
              fontSize: AppSize.font10,
              fontWeight: FontWeight.w700,
              color: fg),
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
      padding: const EdgeInsets.symmetric(horizontal: AppSize.space16),
      child: Column(
        children: [
          AppText(
              text: value,
              fontSize: AppSize.font16,
              fontWeight: FontWeight.w800,
              color: context.txtPrimary),
          const SizedBox(height: AppSize.space2),
          AppText(
              text: label,
              fontSize: AppSize.font10,
              color: context.txtSecondary),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider(this.context);
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
        height: 28,
        width: AppSize.borderWidth1,
        backgroundColor: context.borderClr);
  }
}
