// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agri_market/core/constants/colors.dart';
// import 'package:agri_market/core/theme/app_theme.dart';
// import 'package:agri_market/features/seller/settings/settings_con.dart';
//
// class MobileSettingsScr extends StatelessWidget {
//   const MobileSettingsScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<SettingsCon>();
//     return Scaffold(
//       backgroundColor: context.appBg,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _ThemeCard(c: c),
//             const SizedBox(height: 14),
//             _LanguageCard(c: c),
//             const SizedBox(height: 14),
//             _NotificationsCard(c: c),
//             const SizedBox(height: 14),
//             _SecurityCard(c: c),
//             const SizedBox(height: 14),
//             _PrivacyCard(c: c),
//             const SizedBox(height: 14),
//             _AboutCard(c: c),
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Settings Card Shell ────────────────────────────────────────────────────
//
// class _Card extends StatelessWidget {
//   const _Card({required this.title, required this.icon, required this.children});
//   final String title;
//   final IconData icon;
//   final List<Widget> children;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: context.cardBg,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: context.borderClr),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
//             child: Row(
//               children: [
//                 Container(
//                   width: 30,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: CColors.backgroundEmerald100,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(icon,
//                       size: 15, color: CColors.iconEmeraldGreen),
//                 ),
//                 const SizedBox(width: 10),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: context.txtPrimary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Divider(height: 1, color: context.borderClr),
//           ...children,
//         ],
//       ),
//     );
//   }
// }
//
// // ── Toggle Row ─────────────────────────────────────────────────────────────
//
// class _ToggleRow extends StatelessWidget {
//   const _ToggleRow({
//     required this.label,
//     required this.subtitle,
//     required this.value,
//     required this.onChanged,
//     this.last = false,
//   });
//   final String label, subtitle;
//   final bool value;
//   final ValueChanged<bool> onChanged;
//   final bool last;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(label,
//                         style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: context.txtPrimary)),
//                     const SizedBox(height: 2),
//                     Text(subtitle,
//                         style: TextStyle(
//                             fontSize: 11, color: context.txtSecondary)),
//                   ],
//                 ),
//               ),
//               Switch(
//                 value: value,
//                 onChanged: onChanged,
//                 activeColor: CColors.backGroundEmeraldGreen,
//               ),
//             ],
//           ),
//         ),
//         if (!last) Divider(height: 1, color: context.dividerClr),
//       ],
//     );
//   }
// }
//
// // ── Nav Row ────────────────────────────────────────────────────────────────
//
// class _NavRow extends StatelessWidget {
//   const _NavRow({
//     required this.label,
//     required this.subtitle,
//     required this.icon,
//     required this.onTap,
//     this.last = false,
//     this.destructive = false,
//   });
//   final String label, subtitle;
//   final IconData icon;
//   final VoidCallback onTap;
//   final bool last, destructive;
//
//   @override
//   Widget build(BuildContext context) {
//     final fg = destructive ? CColors.textError : context.txtPrimary;
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Row(
//               children: [
//                 Container(
//                   width: 30,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: destructive
//                         ? CColors.backgroundErrorLight
//                         : context.cardBg2,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(icon,
//                       size: 15,
//                       color: destructive
//                           ? CColors.iconError
//                           : CColors.iconEmeraldGreen),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(label,
//                           style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                               color: fg)),
//                       const SizedBox(height: 2),
//                       Text(subtitle,
//                           style: TextStyle(
//                               fontSize: 11, color: context.txtSecondary)),
//                     ],
//                   ),
//                 ),
//                 Icon(Icons.chevron_right_rounded,
//                     size: 18, color: context.txtSecondary),
//               ],
//             ),
//           ),
//         ),
//         if (!last) Divider(height: 1, color: context.dividerClr),
//       ],
//     );
//   }
// }
//
// // ── Theme Card ─────────────────────────────────────────────────────────────
//
// class _ThemeCard extends StatelessWidget {
//   final SettingsCon c;
//   const _ThemeCard({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _Card(
//       title: 'Appearance',
//       icon: Icons.palette_outlined,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Obx(() => Row(
//                 children: [
//                   _ThemeOption(
//                     label: 'Light',
//                     icon: Icons.light_mode_rounded,
//                     selected: c.currentTheme == ThemeMode.light,
//                     onTap: () => c.setTheme(ThemeMode.light),
//                   ),
//                   const SizedBox(width: 8),
//                   _ThemeOption(
//                     label: 'Dark',
//                     icon: Icons.dark_mode_rounded,
//                     selected: c.currentTheme == ThemeMode.dark,
//                     onTap: () => c.setTheme(ThemeMode.dark),
//                   ),
//                   const SizedBox(width: 8),
//                   _ThemeOption(
//                     label: 'System',
//                     icon: Icons.settings_suggest_rounded,
//                     selected: c.currentTheme == ThemeMode.system,
//                     onTap: () => c.setTheme(ThemeMode.system),
//                   ),
//                 ],
//               )),
//         ),
//       ],
//     );
//   }
// }
//
// class _ThemeOption extends StatelessWidget {
//   const _ThemeOption({
//     required this.label,
//     required this.icon,
//     required this.selected,
//     required this.onTap,
//   });
//   final String label;
//   final IconData icon;
//   final bool selected;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 150),
//           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
//           decoration: BoxDecoration(
//             color: selected
//                 ? CColors.backGroundEmeraldGreen.withOpacity(0.1)
//                 : context.cardBg2,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               color: selected ? CColors.borderEmeraldGreen : context.borderClr,
//               width: selected ? 1.5 : 1,
//             ),
//           ),
//           child: Column(
//             children: [
//               Icon(
//                 icon,
//                 size: 22,
//                 color: selected
//                     ? CColors.iconEmeraldGreen
//                     : context.txtSecondary,
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight:
//                       selected ? FontWeight.w700 : FontWeight.w500,
//                   color: selected
//                       ? CColors.textEmeraldGreen
//                       : context.txtPrimary,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 150),
//                 width: 7,
//                 height: 7,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: selected
//                       ? CColors.backGroundEmeraldGreen
//                       : Colors.transparent,
//                   border: Border.all(
//                     color: selected
//                         ? Colors.transparent
//                         : context.borderClr,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ── Language Card ──────────────────────────────────────────────────────────
//
// class _LanguageCard extends StatelessWidget {
//   final SettingsCon c;
//   const _LanguageCard({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _Card(
//       title: 'Language & Region',
//       icon: Icons.language_outlined,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Obx(() => DropdownButtonFormField<String>(
//                 value: c.selectedLanguage.value,
//                 onChanged: (v) => c.setLanguage(v!),
//                 style: TextStyle(
//                     fontSize: 13, color: context.txtPrimary),
//                 dropdownColor: context.cardBg,
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(Icons.translate_outlined,
//                       size: 16, color: CColors.iconEmeraldGreen),
//                   filled: true,
//                   fillColor: context.inputFill,
//                   isDense: true,
//                   contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 12, vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: context.borderClr),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: context.borderClr),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(
//                         color: CColors.borderEmeraldGreen, width: 1.5),
//                   ),
//                   labelText: 'Display Language',
//                   labelStyle: TextStyle(
//                       fontSize: 11, color: context.txtSecondary),
//                 ),
//                 items: c.languages
//                     .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                     .toList(),
//               )),
//         ),
//       ],
//     );
//   }
// }
//
// // ── Notifications Card ─────────────────────────────────────────────────────
//
// class _NotificationsCard extends StatelessWidget {
//   final SettingsCon c;
//   const _NotificationsCard({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _Card(
//       title: 'Notifications',
//       icon: Icons.notifications_none_outlined,
//       children: [
//         Obx(() => _ToggleRow(
//               label: 'Order Notifications',
//               subtitle: 'Get notified for order updates',
//               value: c.orderNotifs.value,
//               onChanged: (v) => c.orderNotifs.value = v,
//             )),
//         Obx(() => _ToggleRow(
//               label: 'Payment Alerts',
//               subtitle: 'Alerts for payment status changes',
//               value: c.paymentNotifs.value,
//               onChanged: (v) => c.paymentNotifs.value = v,
//             )),
//         Obx(() => _ToggleRow(
//               label: 'Customer Messages',
//               subtitle: 'Notify when customers message',
//               value: c.messageNotifs.value,
//               onChanged: (v) => c.messageNotifs.value = v,
//             )),
//         Obx(() => _ToggleRow(
//               label: 'Stock Alerts',
//               subtitle: 'Alert on low stock products',
//               value: c.stockAlerts.value,
//               onChanged: (v) => c.stockAlerts.value = v,
//             )),
//         Obx(() => _ToggleRow(
//               label: 'Review Notifications',
//               subtitle: 'When customers leave reviews',
//               value: c.reviewNotifs.value,
//               onChanged: (v) => c.reviewNotifs.value = v,
//             )),
//         Obx(() => _ToggleRow(
//               label: 'SMS Alerts',
//               subtitle: 'Critical alerts via SMS',
//               value: c.smsAlerts.value,
//               onChanged: (v) => c.smsAlerts.value = v,
//             )),
//         Obx(() => _ToggleRow(
//               label: 'Marketing Emails',
//               subtitle: 'Tips, offers, platform updates',
//               value: c.marketingEmails.value,
//               onChanged: (v) => c.marketingEmails.value = v,
//               last: true,
//             )),
//       ],
//     );
//   }
// }
//
// // ── Security Card ──────────────────────────────────────────────────────────
//
// class _SecurityCard extends StatelessWidget {
//   final SettingsCon c;
//   const _SecurityCard({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _Card(
//       title: 'Security',
//       icon: Icons.security_outlined,
//       children: [
//         _NavRow(
//           label: 'Change Password',
//           subtitle: 'Update your account password',
//           icon: Icons.lock_outline_rounded,
//           onTap: () {},
//         ),
//         Obx(() => _ToggleRow(
//               label: 'Two-Factor Authentication',
//               subtitle: 'Extra layer of account security',
//               value: c.twoFactorEnabled.value,
//               onChanged: (v) => c.twoFactorEnabled.value = v,
//             )),
//         Obx(() => _ToggleRow(
//               label: 'Login Alerts',
//               subtitle: 'Notify on new sign-ins',
//               value: c.loginAlerts.value,
//               onChanged: (v) => c.loginAlerts.value = v,
//             )),
//         _NavRow(
//           label: 'Active Sessions',
//           subtitle: 'View and manage devices',
//           icon: Icons.devices_outlined,
//           onTap: () {},
//           last: true,
//         ),
//       ],
//     );
//   }
// }
//
// // ── Privacy Card ───────────────────────────────────────────────────────────
//
// class _PrivacyCard extends StatelessWidget {
//   final SettingsCon c;
//   const _PrivacyCard({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _Card(
//       title: 'Privacy',
//       icon: Icons.privacy_tip_outlined,
//       children: [
//         Obx(() => _ToggleRow(
//               label: 'Public Profile',
//               subtitle: 'Allow buyers to view your profile',
//               value: c.publicProfile.value,
//               onChanged: (v) => c.publicProfile.value = v,
//             )),
//         Obx(() => _ToggleRow(
//               label: 'Show Online Status',
//               subtitle: 'Let customers see when active',
//               value: c.showOnlineStatus.value,
//               onChanged: (v) => c.showOnlineStatus.value = v,
//             )),
//         Obx(() => _ToggleRow(
//               label: 'Show Sales Statistics',
//               subtitle: 'Display total sales on profile',
//               value: c.showSalesStats.value,
//               onChanged: (v) => c.showSalesStats.value = v,
//               last: true,
//             )),
//       ],
//     );
//   }
// }
//
// // ── About Card ─────────────────────────────────────────────────────────────
//
// class _AboutCard extends StatelessWidget {
//   final SettingsCon c;
//   const _AboutCard({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _Card(
//       title: 'About',
//       icon: Icons.info_outline_rounded,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('App Version',
//                         style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: context.txtPrimary)),
//                     const SizedBox(height: 2),
//                     Text(c.appVersion,
//                         style: TextStyle(
//                             fontSize: 11, color: context.txtSecondary)),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: CColors.backgroundEmerald100,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text('Up to date',
//                     style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w700,
//                         color: CColors.textEmeraldGreen)),
//               ),
//             ],
//           ),
//         ),
//         Divider(height: 1, color: context.dividerClr),
//         _NavRow(
//           label: 'Terms of Service',
//           subtitle: 'Read our terms and conditions',
//           icon: Icons.article_outlined,
//           onTap: () {},
//         ),
//         _NavRow(
//           label: 'Privacy Policy',
//           subtitle: 'How we handle your data',
//           icon: Icons.policy_outlined,
//           onTap: () {},
//         ),
//         _NavRow(
//           label: 'Delete Account',
//           subtitle: 'Permanently remove your account',
//           icon: Icons.delete_forever_outlined,
//           onTap: () {},
//           destructive: true,
//           last: true,
//         ),
//       ],
//     );
//   }
// }
