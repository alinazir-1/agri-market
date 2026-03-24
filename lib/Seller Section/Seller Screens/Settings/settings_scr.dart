import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Core/Constant/colors.dart';
import '../../../Core/Constant/sizes.dart';
import '../../../Core/Theme/app_theme.dart';
import '../../../Shared/Screens Common Widgets/screen_top_bar.dart';
import 'settings_con.dart';

class SettingsScr extends StatelessWidget {
  final SettingsCon c = Get.put(SettingsCon());
  SettingsScr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      body: SafeArea(
        child: Column(
          children: [
            ScreenTopBar(
              title: 'Settings',
              subtitle: 'Customize your app experience & preferences',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(CSize.space24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Column(
                      children: [
                        _ThemeSection(c: c),
                        const SizedBox(height: CSize.space20),
                        _LanguageSection(c: c),
                        const SizedBox(height: CSize.space20),
                        _NotificationsSection(c: c),
                        const SizedBox(height: CSize.space20),
                        _SecuritySection(c: c),
                        const SizedBox(height: CSize.space20),
                        _PrivacySection(c: c),
                        const SizedBox(height: CSize.space20),
                        _AboutSection(c: c),
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

// ── Settings Card ─────────────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.title, required this.icon, required this.children});
  final String title;
  final IconData icon;
  final List<Widget> children;

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
                    borderRadius: BorderRadius.circular(CSize.radius10Medium),
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
              horizontal: CSize.space20, vertical: CSize.space12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: CSize.font13Small,
                            fontWeight: FontWeight.w600,
                            color: context.txtPrimary)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 11, color: context.txtSecondary)),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: CColors.backGroundEmeraldGreen,
              ),
            ],
          ),
        ),
        if (!last) Divider(height: 1, color: context.dividerClr),
      ],
    );
  }
}

// ── Navigation Row ────────────────────────────────────────────────────────

class _NavRow extends StatefulWidget {
  const _NavRow({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.last = false,
    this.destructive = false,
  });
  final String label, subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool last, destructive;

  @override
  State<_NavRow> createState() => _NavRowState();
}

class _NavRowState extends State<_NavRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final fg = widget.destructive ? CColors.textError : context.txtPrimary;
    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              color: _hovered ? context.hoverBg : Colors.transparent,
              padding: const EdgeInsets.symmetric(
                  horizontal: CSize.space20, vertical: CSize.space12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: widget.destructive
                          ? CColors.backgroundErrorLight
                          : context.cardBg2,
                      borderRadius:
                          BorderRadius.circular(CSize.radius10Medium),
                    ),
                    child: Icon(widget.icon,
                        size: CSize.icon16Small,
                        color: widget.destructive
                            ? CColors.iconError
                            : CColors.iconEmeraldGreen),
                  ),
                  const SizedBox(width: CSize.space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.label,
                            style: TextStyle(
                                fontSize: CSize.font13Small,
                                fontWeight: FontWeight.w600,
                                color: fg)),
                        const SizedBox(height: 2),
                        Text(widget.subtitle,
                            style: TextStyle(
                                fontSize: 11, color: context.txtSecondary)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      size: CSize.icon20Medium, color: context.txtSecondary),
                ],
              ),
            ),
          ),
        ),
        if (!widget.last) Divider(height: 1, color: context.dividerClr),
      ],
    );
  }
}

// ── Theme Section ─────────────────────────────────────────────────────────

class _ThemeSection extends StatelessWidget {
  const _ThemeSection({required this.c});
  final SettingsCon c;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        Padding(
          padding: const EdgeInsets.all(CSize.space20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Theme Mode',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: context.txtSecondary)),
              const SizedBox(height: CSize.space12),
              Obx(() => Row(
                    children: [
                      _ThemeOption(
                        label: 'Light',
                        icon: Icons.light_mode_rounded,
                        selected: c.currentTheme == ThemeMode.light,
                        onTap: () => c.setTheme(ThemeMode.light),
                      ),
                      const SizedBox(width: CSize.space10),
                      _ThemeOption(
                        label: 'Dark',
                        icon: Icons.dark_mode_rounded,
                        selected: c.currentTheme == ThemeMode.dark,
                        onTap: () => c.setTheme(ThemeMode.dark),
                      ),
                      const SizedBox(width: CSize.space10),
                      _ThemeOption(
                        label: 'System',
                        icon: Icons.settings_suggest_rounded,
                        selected: c.currentTheme == ThemeMode.system,
                        onTap: () => c.setTheme(ThemeMode.system),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThemeOption extends StatefulWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_ThemeOption> createState() => _ThemeOptionState();
}

class _ThemeOptionState extends State<_ThemeOption> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(
                vertical: CSize.space16, horizontal: CSize.space8),
            decoration: BoxDecoration(
              color: widget.selected
                  ? CColors.backGroundEmeraldGreen.withOpacity(0.1)
                  : _hovered
                      ? context.hoverBg
                      : context.cardBg2,
              borderRadius: BorderRadius.circular(CSize.radius10Medium),
              border: Border.all(
                color: widget.selected
                    ? CColors.borderEmeraldGreen
                    : context.borderClr,
                width: widget.selected ? 1.5 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  widget.icon,
                  size: CSize.icon24Large,
                  color: widget.selected
                      ? CColors.iconEmeraldGreen
                      : context.txtSecondary,
                ),
                const SizedBox(height: CSize.space8),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: widget.selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: widget.selected
                        ? CColors.textEmeraldGreen
                        : context.txtPrimary,
                  ),
                ),
                const SizedBox(height: CSize.space5),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.selected
                        ? CColors.backGroundEmeraldGreen
                        : Colors.transparent,
                    border: Border.all(
                      color: widget.selected
                          ? Colors.transparent
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
  const _LanguageSection({required this.c});
  final SettingsCon c;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      title: 'Language & Region',
      icon: Icons.language_outlined,
      children: [
        Padding(
          padding: const EdgeInsets.all(CSize.space20),
          child: Obx(() => DropdownButtonFormField<String>(
                value: c.selectedLanguage.value,
                onChanged: (v) => c.setLanguage(v!),
                style: TextStyle(
                    fontSize: CSize.font13Small, color: context.txtPrimary),
                dropdownColor: context.cardBg,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.translate_outlined,
                      size: CSize.icon16Small,
                      color: CColors.iconEmeraldGreen),
                  filled: true,
                  fillColor: context.inputFill,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: CSize.space12, vertical: CSize.space12),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(CSize.radius10Medium),
                    borderSide: BorderSide(color: context.borderClr),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(CSize.radius10Medium),
                    borderSide: BorderSide(color: context.borderClr),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(CSize.radius10Medium),
                    borderSide: const BorderSide(
                        color: CColors.borderEmeraldGreen, width: 1.5),
                  ),
                  labelText: 'Display Language',
                  labelStyle: TextStyle(
                      fontSize: 11, color: context.txtSecondary),
                ),
                items: c.languages
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              )),
        ),
      ],
    );
  }
}

// ── Notifications Section ─────────────────────────────────────────────────

class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection({required this.c});
  final SettingsCon c;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      title: 'Notifications',
      icon: Icons.notifications_none_outlined,
      children: [
        Obx(() => _ToggleRow(
              label: 'Order Notifications',
              subtitle: 'Get notified when orders are placed or updated',
              value: c.orderNotifs.value,
              onChanged: (v) => c.orderNotifs.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'Payment Alerts',
              subtitle: 'Receive alerts for payment status changes',
              value: c.paymentNotifs.value,
              onChanged: (v) => c.paymentNotifs.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'Customer Messages',
              subtitle: 'Notify me when customers send messages',
              value: c.messageNotifs.value,
              onChanged: (v) => c.messageNotifs.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'Stock Alerts',
              subtitle: 'Alert when products reach low stock threshold',
              value: c.stockAlerts.value,
              onChanged: (v) => c.stockAlerts.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'Review Notifications',
              subtitle: 'Know when customers leave reviews',
              value: c.reviewNotifs.value,
              onChanged: (v) => c.reviewNotifs.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'SMS Alerts',
              subtitle: 'Receive critical alerts via SMS',
              value: c.smsAlerts.value,
              onChanged: (v) => c.smsAlerts.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'Marketing Emails',
              subtitle: 'Tips, offers, and platform updates',
              value: c.marketingEmails.value,
              onChanged: (v) => c.marketingEmails.value = v,
              last: true,
            )),
      ],
    );
  }
}

// ── Security Section ──────────────────────────────────────────────────────

class _SecuritySection extends StatelessWidget {
  const _SecuritySection({required this.c});
  final SettingsCon c;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      title: 'Security',
      icon: Icons.security_outlined,
      children: [
        _NavRow(
          label: 'Change Password',
          subtitle: 'Update your account password',
          icon: Icons.lock_outline_rounded,
          onTap: () {},
        ),
        Obx(() => _ToggleRow(
              label: 'Two-Factor Authentication',
              subtitle: 'Add an extra layer of security to your account',
              value: c.twoFactorEnabled.value,
              onChanged: (v) => c.twoFactorEnabled.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'Login Alerts',
              subtitle: 'Get notified of new sign-ins on your account',
              value: c.loginAlerts.value,
              onChanged: (v) => c.loginAlerts.value = v,
            )),
        _NavRow(
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
  const _PrivacySection({required this.c});
  final SettingsCon c;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      title: 'Privacy',
      icon: Icons.privacy_tip_outlined,
      children: [
        Obx(() => _ToggleRow(
              label: 'Public Profile',
              subtitle: 'Allow buyers to view your seller profile',
              value: c.publicProfile.value,
              onChanged: (v) => c.publicProfile.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'Show Online Status',
              subtitle: 'Let customers see when you are active',
              value: c.showOnlineStatus.value,
              onChanged: (v) => c.showOnlineStatus.value = v,
            )),
        Obx(() => _ToggleRow(
              label: 'Show Sales Statistics',
              subtitle: 'Display your total sales on your public profile',
              value: c.showSalesStats.value,
              onChanged: (v) => c.showSalesStats.value = v,
              last: true,
            )),
      ],
    );
  }
}

// ── About Section ─────────────────────────────────────────────────────────

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.c});
  final SettingsCon c;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      title: 'About',
      icon: Icons.info_outline_rounded,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CSize.space20, vertical: CSize.space14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('App Version',
                        style: TextStyle(
                            fontSize: CSize.font13Small,
                            fontWeight: FontWeight.w600,
                            color: context.txtPrimary)),
                    const SizedBox(height: 2),
                    Text(c.appVersion,
                        style: TextStyle(
                            fontSize: 11, color: context.txtSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: CSize.space8, vertical: 4),
                decoration: BoxDecoration(
                  color: CColors.backgroundEmerald100,
                  borderRadius:
                      BorderRadius.circular(CSize.radius50Circular),
                ),
                child: Text('Up to date',
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: CColors.textEmeraldGreen)),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: context.dividerClr),
        _NavRow(
          label: 'Terms of Service',
          subtitle: 'Read our terms and conditions',
          icon: Icons.article_outlined,
          onTap: () {},
        ),
        _NavRow(
          label: 'Privacy Policy',
          subtitle: 'Understand how we handle your data',
          icon: Icons.policy_outlined,
          onTap: () {},
        ),
        _NavRow(
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
