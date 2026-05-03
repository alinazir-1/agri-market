import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/theme/app_theme.dart';
import 'package:agri_market/shared/widgets/seller/screen_top_bar.dart';
import 'package:agri_market/features/seller/settings/settings_con.dart';
import '../../../shared/widgets/common/app_container.dart';
import '../../../shared/widgets/common/app_text.dart';

class SettingsScr extends StatelessWidget {
  final SettingsCon ctrlSettings = Get.put(SettingsCon(), permanent: true);

  SettingsScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: Column(
          children: [
            const ScreenTopBar(
              title: 'Settings',
              subtitle: 'Customize your app experience & preferences',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSize.space24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxWidth: AppSize
                            .breakpointTablet), // mapped 700 to 860 breakpoint standard
                    child: Column(
                      children: [
                        _ThemeSection(ctrlSettings: ctrlSettings),
                        const SizedBox(height: AppSize.space20),
                        _LanguageSection(ctrlSettings: ctrlSettings),
                        const SizedBox(height: AppSize.space20),
                        _NotificationsSection(ctrlSettings: ctrlSettings),
                        const SizedBox(height: AppSize.space20),
                        _SecuritySection(ctrlSettings: ctrlSettings),
                        const SizedBox(height: AppSize.space20),
                        _PrivacySection(ctrlSettings: ctrlSettings),
                        const SizedBox(height: AppSize.space20),
                        _AboutSection(ctrlSettings: ctrlSettings),
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

// ── Settings Card ─────────────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

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
                  backgroundColor:
                      AppColors.badgeSuccessBg, // mapped 0xFFD1FAE5
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
          ...children,
        ],
      ),
    );
  }
}

// ── Toggle Row ────────────────────────────────────────────────────────────

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.last = false,
  });

  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space20, vertical: AppSize.space12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                        text: label,
                        fontSize: AppSize.font12, // mapped 13 to 12
                        fontWeight: FontWeight.w600,
                        color: context.txtPrimary),
                    const SizedBox(height: AppSize.space4), // mapped 2 to 4
                    AppText(
                        text: subtitle,
                        fontSize: AppSize.font10, // mapped 11 to 10
                        color: context.txtSecondary),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.emeraldGreen,
              ),
            ],
          ),
        ),
        if (!last)
          Divider(height: AppSize.borderWidth1, color: context.dividerClr),
      ],
    );
  }
}

// ── Navigation Row ────────────────────────────────────────────────────────

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.ctrl,
    required this.hoverId,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.last = false,
    this.destructive = false,
  });

  final SettingsCon ctrl;
  final String hoverId;
  final String label, subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool last, destructive;

  @override
  Widget build(BuildContext context) {
    final fg = destructive ? AppColors.textError : context.txtPrimary;

    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => ctrl.hoveredNavId.value = hoverId,
          onExit: (_) {
            if (ctrl.hoveredNavId.value == hoverId) {
              ctrl.hoveredNavId.value = null;
            }
          },
          child: GestureDetector(
            onTap: onTap,
            child: Obx(() {
              final hover = ctrl.hoveredNavId.value == hoverId;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                color:
                    hover ? context.hoverBg : AppColors.backGroundTransparent,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.space20, vertical: AppSize.space12),
                child: Row(
                  children: [
                    AppContainer(
                      width: AppSize.icon32,
                      height: AppSize.icon32,
                      backgroundColor: destructive
                          ? AppColors.badgeErrorBg
                          : context.cardBg2,
                      borderRadius: BorderRadius.circular(AppSize.radius8),
                      child: Center(
                        child: Icon(icon,
                            size: AppSize.icon16,
                            color: destructive
                                ? AppColors.iconError
                                : AppColors.iconEmeraldGreen),
                      ),
                    ),
                    const SizedBox(width: AppSize.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                              text: label,
                              fontSize: AppSize.font12,
                              fontWeight: FontWeight.w600,
                              color: fg),
                          const SizedBox(height: AppSize.space4),
                          AppText(
                              text: subtitle,
                              fontSize: AppSize.font10,
                              color: context.txtSecondary),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        size: AppSize.icon20, color: context.txtSecondary),
                  ],
                ),
              );
            }),
          ),
        ),
        if (!last)
          Divider(height: AppSize.borderWidth1, color: context.dividerClr),
      ],
    );
  }
}

// ── Theme Section ─────────────────────────────────────────────────────────

class _ThemeSection extends StatelessWidget {
  const _ThemeSection({required this.ctrlSettings});
  final SettingsCon ctrlSettings;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSize.space20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                  text: 'Theme Mode',
                  fontSize: AppSize.font10, // mapped 11 to 10
                  fontWeight: FontWeight.w600,
                  color: context.txtSecondary),
              const SizedBox(height: AppSize.space12),
              Obx(() {
                final mode = ctrlSettings.themeMode.value;
                final hid = ctrlSettings.hoveredThemeOptionId.value;
                return Row(
                  children: [
                    _ThemeOption(
                      ctrl: ctrlSettings,
                      optionId: 'light',
                      label: 'Light',
                      icon: Icons.light_mode_rounded,
                      selected: mode == ThemeMode.light,
                      hover: hid == 'light',
                      onTap: () => ctrlSettings.setTheme(ThemeMode.light),
                    ),
                    const SizedBox(width: AppSize.space12),
                    _ThemeOption(
                      ctrl: ctrlSettings,
                      optionId: 'dark',
                      label: 'Dark',
                      icon: Icons.dark_mode_rounded,
                      selected: mode == ThemeMode.dark,
                      hover: hid == 'dark',
                      onTap: () => ctrlSettings.setTheme(ThemeMode.dark),
                    ),
                    const SizedBox(width: AppSize.space12),
                    _ThemeOption(
                      ctrl: ctrlSettings,
                      optionId: 'system',
                      label: 'System',
                      icon: Icons.settings_suggest_rounded,
                      selected: mode == ThemeMode.system,
                      hover: hid == 'system',
                      onTap: () => ctrlSettings.setTheme(ThemeMode.system),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.ctrl,
    required this.optionId,
    required this.label,
    required this.icon,
    required this.selected,
    required this.hover,
    required this.onTap,
  });

  final SettingsCon ctrl;
  final String optionId;
  final String label;
  final IconData icon;
  final bool selected;
  final bool hover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => ctrl.hoveredThemeOptionId.value = optionId,
        onExit: (_) {
          if (ctrl.hoveredThemeOptionId.value == optionId) {
            ctrl.hoveredThemeOptionId.value = null;
          }
        },
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(
                vertical: AppSize.space16, horizontal: AppSize.space8),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.badgeSuccessBg.withValues(alpha: 0.3)
                  : hover
                      ? context.hoverBg
                      : context.cardBg2,
              borderRadius: BorderRadius.circular(AppSize.radius8),
              border: Border.all(
                color: selected
                    ? AppColors.borderEmeraldGreen
                    : context.borderClr,
                width: selected
                    ? AppSize.borderWidth2
                    : AppSize.borderWidth1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: AppSize.icon24,
                  color: selected
                      ? AppColors.iconEmeraldGreen
                      : context.txtSecondary,
                ),
                const SizedBox(height: AppSize.space8),
                AppText(
                  text: label,
                  fontSize: AppSize.font12,
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? AppColors.textEmeraldGreen
                      : context.txtPrimary,
                ),
                const SizedBox(height: AppSize.space4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: AppSize.space8,
                  height: AppSize.space8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? AppColors.emeraldGreen
                        : AppColors.backGroundTransparent,
                    border: Border.all(
                      color: selected
                          ? AppColors.backGroundTransparent
                          : context.borderClr,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Language Section ──────────────────────────────────────────────────────

class _LanguageSection extends StatelessWidget {
  const _LanguageSection({required this.ctrlSettings});
  final SettingsCon ctrlSettings;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      title: 'Language & Region',
      icon: Icons.language_outlined,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSize.space20),
          child: Obx(() => DropdownButtonFormField<String>(
                value: ctrlSettings.selectedLanguage.value,
                onChanged: (v) => ctrlSettings.setLanguage(v!),
                style: TextStyle(
                    fontSize: AppSize.font12, // mapped 13 to 12
                    color: context.txtPrimary),
                dropdownColor: context.cardBg,
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    size: AppSize.icon16, color: AppColors.textSecondary),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.translate_outlined,
                      size: AppSize.icon16, color: AppColors.iconEmeraldGreen),
                  filled: true,
                  fillColor: context.inputFill,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSize.space12, vertical: AppSize.space12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        AppSize.radius12), // mapped 10 to 12
                    borderSide: BorderSide(color: context.borderClr),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.radius12),
                    borderSide: BorderSide(color: context.borderClr),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.radius12),
                    borderSide: const BorderSide(
                        color: AppColors.borderEmeraldGreen,
                        width: AppSize.borderWidth2), // mapped 1.5 to 2
                  ),
                  labelText: 'Display Language',
                  labelStyle: TextStyle(
                      fontSize: AppSize.font10,
                      color: context.txtSecondary), // mapped 11 to 10
                ),
                items: ctrlSettings.languages
                    .map((e) =>
                        DropdownMenuItem(value: e, child: AppText(text: e)))
                    .toList(),
              )),
        ),
      ],
    );
  }
}

// ── Notifications Section ─────────────────────────────────────────────────

class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection({required this.ctrlSettings});
  final SettingsCon ctrlSettings;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      title: 'Notifications',
      icon: Icons.notifications_none_outlined,
      children: [
        Obx(() => _ToggleRow(
              label: 'Order Notifications',
              subtitle: 'Get notified when orders are placed or updated',
              value: ctrlSettings.orderNotifs.value,
              onChanged: (v) => ctrlSettings.orderNotifs.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'Payment Alerts',
              subtitle: 'Receive alerts for payment status changes',
              value: ctrlSettings.paymentNotifs.value,
              onChanged: (v) => ctrlSettings.paymentNotifs.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'Customer Messages',
              subtitle: 'Notify me when customers send messages',
              value: ctrlSettings.messageNotifs.value,
              onChanged: (v) => ctrlSettings.messageNotifs.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'Stock Alerts',
              subtitle: 'Alert when products reach low stock threshold',
              value: ctrlSettings.stockAlerts.value,
              onChanged: (v) => ctrlSettings.stockAlerts.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'Review Notifications',
              subtitle: 'Know when customers leave reviews',
              value: ctrlSettings.reviewNotifs.value,
              onChanged: (v) => ctrlSettings.reviewNotifs.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'SMS Alerts',
              subtitle: 'Receive critical alerts via SMS',
              value: ctrlSettings.smsAlerts.value,
              onChanged: (v) => ctrlSettings.smsAlerts.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'Marketing Emails',
              subtitle: 'Tips, offers, and platform updates',
              value: ctrlSettings.marketingEmails.value,
              onChanged: (v) => ctrlSettings.marketingEmails.value = v,
              last: true,
            )),
      ],
    );
  }
}

// ── Security Section ──────────────────────────────────────────────────────

class _SecuritySection extends StatelessWidget {
  const _SecuritySection({required this.ctrlSettings});
  final SettingsCon ctrlSettings;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      title: 'Security',
      icon: Icons.security_outlined,
      children: [
        _NavRow(
          ctrl: ctrlSettings,
          hoverId: 'nav_change_password',
          label: 'Change Password',
          subtitle: 'Update your account password',
          icon: Icons.lock_outline_rounded,
          onTap: () {},
        ),
        Obx(() => _ToggleRow(
              label: 'Two-Factor Authentication',
              subtitle: 'Add an extra layer of security to your account',
              value: ctrlSettings.twoFactorEnabled.value,
              onChanged: (v) => ctrlSettings.twoFactorEnabled.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'Login Alerts',
              subtitle: 'Get notified of new sign-ins on your account',
              value: ctrlSettings.loginAlerts.value,
              onChanged: (v) => ctrlSettings.loginAlerts.value = v,
            )),
        _NavRow(
          ctrl: ctrlSettings,
          hoverId: 'nav_active_sessions',
          label: 'Active Sessions',
          subtitle: 'View and manage logged-in devices',
          icon: Icons.devices_outlined,
          onTap: () {},
          last: true,
        ),
      ],
    );
  }
}

// ── Privacy Section ───────────────────────────────────────────────────────

class _PrivacySection extends StatelessWidget {
  const _PrivacySection({required this.ctrlSettings});
  final SettingsCon ctrlSettings;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      title: 'Privacy',
      icon: Icons.privacy_tip_outlined,
      children: [
        Obx(() => _ToggleRow(
              label: 'Public Profile',
              subtitle: 'Allow buyers to view your seller profile',
              value: ctrlSettings.publicProfile.value,
              onChanged: (v) => ctrlSettings.publicProfile.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'Show Online Status',
              subtitle: 'Let customers see when you are active',
              value: ctrlSettings.showOnlineStatus.value,
              onChanged: (v) => ctrlSettings.showOnlineStatus.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'Show Sales Statistics',
              subtitle: 'Display your total sales on your public profile',
              value: ctrlSettings.showSalesStats.value,
              onChanged: (v) => ctrlSettings.showSalesStats.value = v,
              last: true,
            )),
      ],
    );
  }
}

// ── About Section ─────────────────────────────────────────────────────────

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.ctrlSettings});
  final SettingsCon ctrlSettings;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      title: 'About',
      icon: Icons.info_outline_rounded,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.space20,
              vertical: AppSize.space12), // mapped 14 to 12
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                        text: 'App Version',
                        fontSize: AppSize.font12, // mapped 13 to 12
                        fontWeight: FontWeight.w600,
                        color: context.txtPrimary),
                    const SizedBox(height: AppSize.space4), // mapped 2 to 4
                    AppText(
                        text: ctrlSettings.appVersion,
                        fontSize: AppSize.font10, // mapped 11 to 10
                        color: context.txtSecondary),
                  ],
                ),
              ),
              AppContainer(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.space8,
                    vertical: AppSize.space4), // mapped 4 to 4
                backgroundColor:
                    AppColors.badgeSuccessBg, // mapped backgroundEmerald100
                borderRadius: BorderRadius.circular(AppSize.radiusCircular),
                child: const AppText(
                    text: 'Up to date',
                    fontSize: AppSize.font10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textEmeraldGreen),
              ),
            ],
          ),
        ),
        Divider(height: AppSize.borderWidth1, color: context.dividerClr),
        _NavRow(
          ctrl: ctrlSettings,
          hoverId: 'nav_terms',
          label: 'Terms of Service',
          subtitle: 'Read our terms and conditions',
          icon: Icons.article_outlined,
          onTap: () {},
        ),
        _NavRow(
          ctrl: ctrlSettings,
          hoverId: 'nav_privacy',
          label: 'Privacy Policy',
          subtitle: 'Understand how we handle your data',
          icon: Icons.policy_outlined,
          onTap: () {},
        ),
        _NavRow(
          ctrl: ctrlSettings,
          hoverId: 'nav_delete_account',
          label: 'Delete Account',
          subtitle: 'Permanently remove your account and data',
          icon: Icons.delete_forever_outlined,
          onTap: () {},
          destructive: true,
          last: true,
        ),
      ],
    );
  }
}
