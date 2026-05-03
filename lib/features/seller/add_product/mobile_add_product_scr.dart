// // lib/features/seller/add_product/mobile_add_product_scr.dart
// import 'package:csc_picker_plus/csc_picker_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:agri_market/core/constants/colors.dart';
// import 'package:agri_market/core/constants/sizes.dart';
// import 'package:agri_market/core/theme/app_theme.dart';
// import 'package:agri_market/features/seller/add_product/add_new_product_con.dart';
//
// import '../../../shared/widgets/common/app_container.dart';
// import '../../../shared/widgets/common/app_elevated_button.dart';
// import '../../../shared/widgets/common/app_outlined_button.dart';
// import '../../../shared/widgets/common/app_text.dart';
//
// // ── Static Option Lists ────────────────────────────────────────────────────────
// const _kCategories = ['Grains & Cereals', 'Fruits', 'Vegetables', 'Spices'];
// const _kGrades = ['Grade A+', 'Grade A', 'Grade B+', 'Grade B'];
// const _kStorage = ['Room Temperature', 'Cold Storage', 'Refrigerated'];
// const _kUnits = ['Ton', 'Kg', 'Box', 'Bag', 'Quintal'];
// const _kCurrencies = ['USD (\$)', 'PKR (₨)', 'INR (₹)'];
// const _kDelivery = ['Seller Delivers', 'Buyer Picks Up', 'Both Available'];
// const _kSampleUnits = ['kg', 'g', 'box', 'pack', 'Ton'];
// const _kDispatch = [
//   'Within 24 hours',
//   '2–3 business days',
//   'Within 1 week',
//   'Custom'
// ];
// const _kDeliveryCost = ['Seller pays delivery', 'Buyer pays delivery'];
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  MAIN SCREEN
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class MobileAddProductScr extends StatelessWidget {
//   const MobileAddProductScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<AddNewProductCon>();
//     return Scaffold(
//       backgroundColor: context.appBg,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(
//           AppSize.space16,
//           AppSize.space12,
//           AppSize.space16,
//           AppSize.space16,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _ListingTypeSelector(c: c),
//             const SizedBox(height: AppSize.space12),
//             Obx(() => c.selectedListingType.value == null
//                 ? const _NoSelectionBanner()
//                 : _AllFormSections(c: c)),
//             const SizedBox(height: 80),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _BottomActionBar(c: c),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  LISTING TYPE SELECTOR
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _ListingTypeSelector extends StatelessWidget {
//   final AddNewProductCon c;
//   const _ListingTypeSelector({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _FormCard(
//       icon: Icons.category_outlined,
//       iconBg: AppColors.backgroundEmerald100,
//       iconColor: AppColors.iconEmeraldGreen,
//       title: 'Select Listing Type',
//       badge: 'Required',
//       subtitle: 'You must choose a listing type before filling in details',
//       child: Column(
//         children: [
//           _TypeCard(
//             c: c,
//             type: AddListingType.marketplace,
//             icon: Icons.storefront_outlined,
//             title: 'Marketplace',
//             subtitle: 'Direct sale with fixed pricing',
//             color: const Color(0xFF059669),
//             bgColor: const Color(0xFFECFDF5),
//             borderColor: const Color(0xFF6EE7B7),
//           ),
//           const SizedBox(height: AppSize.space8),
//           _TypeCard(
//             c: c,
//             type: AddListingType.advanceBooking,
//             icon: Icons.calendar_month_outlined,
//             title: 'Advance Booking',
//             subtitle: 'Pre-orders for upcoming harvest or stock',
//             color: const Color(0xFF2563EB),
//             bgColor: const Color(0xFFEFF6FF),
//             borderColor: const Color(0xFF93C5FD),
//           ),
//           const SizedBox(height: AppSize.space8),
//           _TypeCard(
//             c: c,
//             type: AddListingType.liveAuctions,
//             icon: Icons.show_chart_rounded,
//             title: 'Live Auctions',
//             subtitle: 'Starting bid — buyers compete in real-time',
//             color: const Color(0xFFD97706),
//             bgColor: AppColors.backgroundAmberLight,
//             borderColor: const Color(0xFFFCD34D),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Type Card ─────────────────────────────────────────────────────────────────
//
// class _TypeCard extends StatelessWidget {
//   final AddNewProductCon c;
//   final AddListingType type;
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final Color color;
//   final Color bgColor;
//   final Color borderColor;
//
//   const _TypeCard({
//     required this.c,
//     required this.type,
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.color,
//     required this.bgColor,
//     required this.borderColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final isSelected = c.selectedListingType.value == type;
//       return GestureDetector(
//         onTap: () => c.selectListingType(type),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           padding: const EdgeInsets.all(AppSize.space12),
//           decoration: BoxDecoration(
//             color: isSelected ? bgColor : context.cardBg2,
//             borderRadius: BorderRadius.circular(AppSize.radius10Medium),
//             border: Border.all(
//               color: isSelected ? borderColor : context.borderClr,
//               width: isSelected ? AppSize.borderWidth2 : AppSize.borderWidth1,
//             ),
//           ),
//           child: Row(
//             children: [
//               AppContainer(
//                 width: 38,
//                 height: 38,
//                 backgroundColor: isSelected
//                     ? color.withValues(alpha: 0.15) // ✅ Fixed
//                     : context.appBg,
//                 borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//                 child: Icon(
//                   icon,
//                   size: AppSize.icon20Medium - 2,
//                   color: isSelected ? color : context.txtSecondary,
//                 ),
//               ),
//               const SizedBox(width: AppSize.space12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppText(
//                       text: title,
//                       fontSize: AppSize.font13Small,
//                       fontWeight: FontWeight.w700,
//                       color: isSelected ? color : context.txtPrimary,
//                     ),
//                     const SizedBox(height: AppSize.space2),
//                     AppText(
//                       text: subtitle,
//                       fontSize: 11,
//                       color: context.txtSecondary,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: AppSize.space10),
//               // Check indicator
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 width: 22,
//                 height: 22,
//                 decoration: BoxDecoration(
//                   color: isSelected ? color : Colors.transparent,
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: isSelected ? color : context.borderClr,
//                     width: AppSize.borderWidth2,
//                   ),
//                 ),
//                 child: isSelected
//                     ? const Icon(Icons.check, size: 13, color: Colors.white)
//                     : null,
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  NO SELECTION BANNER
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _NoSelectionBanner extends StatelessWidget {
//   const _NoSelectionBanner();
//
//   @override
//   Widget build(BuildContext context) {
//     return AppContainer(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(
//         vertical: AppSize.space40,
//         horizontal: AppSize.space20,
//       ),
//       backgroundColor: context.cardBg,
//       borderRadius: BorderRadius.circular(AppSize.radius12Medium2),
//       border: Border.all(color: context.borderClr),
//       child: Column(
//         children: [
//           AppContainer(
//             width: 56,
//             height: 56,
//             backgroundColor: AppColors.backgroundEmerald100,
//             borderRadius: BorderRadius.circular(28),
//             child: const Icon(
//               Icons.touch_app_outlined,
//               size: 28,
//               color: AppColors.iconEmeraldGreen,
//             ),
//           ),
//           const SizedBox(height: AppSize.space14),
//           AppText(
//             text: 'Select a Listing Type to Continue',
//             fontSize: AppSize.font16Medium - 1,
//             fontWeight: FontWeight.w700,
//             color: context.txtPrimary,
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: AppSize.space6),
//           AppText(
//             text:
//                 'Choose Marketplace, Advance Booking, or Live Auctions\nto unlock the product listing form.',
//             fontSize: AppSize.font12Small2,
//             color: context.txtSecondary,
//             textAlign: TextAlign.center,
//             height: 1.5,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  ALL FORM SECTIONS
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _AllFormSections extends StatelessWidget {
//   final AddNewProductCon c;
//   const _AllFormSections({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final type = c.selectedListingType.value;
//       return Column(
//         children: [
//           _ImagesSection(c: c),
//           const SizedBox(height: AppSize.space12),
//           _BasicInfoSection(c: c),
//           const SizedBox(height: AppSize.space12),
//           if (type == AddListingType.marketplace) ...[
//             _MarketplaceExtraSection(c: c),
//             const SizedBox(height: AppSize.space12),
//           ],
//           _QualityHarvestSection(
//             c: c,
//             showHarvestDate: type != AddListingType.liveAuctions,
//             harvestRequired: type == AddListingType.advanceBooking,
//           ),
//           const SizedBox(height: AppSize.space12),
//           if (type == AddListingType.marketplace) ...[
//             _SpecificationsSection(c: c),
//             const SizedBox(height: AppSize.space12),
//             _SampleSection(c: c),
//             const SizedBox(height: AppSize.space12),
//           ],
//           if (type == AddListingType.marketplace) _MpPricingSection(c: c),
//           if (type == AddListingType.advanceBooking) _AbPricingSection(c: c),
//           if (type == AddListingType.liveAuctions) _LaPricingSection(c: c),
//           const SizedBox(height: AppSize.space12),
//           if (type == AddListingType.liveAuctions) ...[
//             _AuctionDetailsSection(c: c),
//             const SizedBox(height: AppSize.space12),
//           ],
//           _LocationSection(
//             c: c,
//             showDelivery: type != AddListingType.liveAuctions,
//           ),
//           const SizedBox(height: AppSize.space12),
//           _TagsSection(c: c),
//         ],
//       );
//     });
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  REUSABLE CARD SHELL
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _FormCard extends StatelessWidget {
//   final IconData icon;
//   final Color iconBg;
//   final Color iconColor;
//   final String title;
//   final String? badge;
//   final String? subtitle;
//   final Widget child;
//
//   const _FormCard({
//     required this.icon,
//     required this.iconBg,
//     required this.iconColor,
//     required this.title,
//     required this.child,
//     this.badge,
//     this.subtitle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AppContainer(
//       width: double.infinity,
//       backgroundColor: context.cardBg,
//       borderRadius: BorderRadius.circular(AppSize.radius12Medium2),
//       border: Border.all(color: context.borderClr),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Padding(
//             padding: const EdgeInsets.fromLTRB(
//               AppSize.space14,
//               AppSize.space12,
//               AppSize.space14,
//               AppSize.space10,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     AppContainer(
//                       width: 28,
//                       height: 28,
//                       backgroundColor: iconBg,
//                       borderRadius: BorderRadius.circular(AppSize.space6),
//                       child: Icon(icon, size: 15, color: iconColor),
//                     ),
//                     const SizedBox(width: AppSize.space8),
//                     Expanded(
//                       child: AppText(
//                         text: title,
//                         fontSize: AppSize.font13Small,
//                         fontWeight: FontWeight.w800,
//                         color: context.txtPrimary,
//                       ),
//                     ),
//                     if (badge != null)
//                       AppContainer(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: AppSize.space6,
//                           vertical: AppSize.space2,
//                         ),
//                         backgroundColor: AppColors.badgeLightRed,
//                         borderRadius:
//                             BorderRadius.circular(AppSize.radius20Large),
//                         child: AppText(
//                           text: badge!,
//                           fontSize: 9,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.textRichRed,
//                         ),
//                       ),
//                   ],
//                 ),
//                 if (subtitle != null) ...[
//                   const SizedBox(height: 3),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 36),
//                     child: AppText(
//                       text: subtitle!,
//                       fontSize: AppSize.font10XSmall,
//                       color: context.txtSecondary,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//           Divider(height: 1, color: context.borderClr),
//           // Body
//           Padding(
//             padding: const EdgeInsets.all(AppSize.space14),
//             child: child,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  SHARED FIELD HELPERS (top-level functions for mobile screen)
// // ═══════════════════════════════════════════════════════════════════════════════
//
// Widget _label(BuildContext ctx, String text,
//     {bool required = false, String? hint}) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: AppSize.space5),
//     child: Row(
//       children: [
//         AppText(
//           text: text,
//           fontSize: 11,
//           fontWeight: FontWeight.w700,
//           color: ctx.txtPrimary,
//         ),
//         if (required)
//           const AppText(text: ' *', fontSize: 11, color: AppColors.textError),
//         if (hint != null)
//           AppText(
//               text: '  $hint',
//               fontSize: AppSize.font10XSmall,
//               color: ctx.txtSecondary),
//       ],
//     ),
//   );
// }
//
// InputDecoration _inputDeco(BuildContext ctx, String hintText) {
//   return InputDecoration(
//     hintText: hintText,
//     hintStyle:
//         TextStyle(fontSize: AppSize.font12Small2, color: ctx.txtSecondary),
//     filled: true,
//     fillColor: ctx.appBg,
//     contentPadding: const EdgeInsets.symmetric(
//       horizontal: AppSize.space12,
//       vertical: AppSize.space10,
//     ),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//       borderSide: BorderSide(color: ctx.borderClr),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//       borderSide: BorderSide(color: ctx.borderClr),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//       borderSide: const BorderSide(
//         color: AppColors.backGroundEmeraldGreen,
//         width: AppSize.borderWidth1 + 0.5,
//       ),
//     ),
//   );
// }
//
// Widget _mTextField(
//   BuildContext ctx,
//   TextEditingController controller,
//   String hint, {
//   int maxLines = 1,
//   TextInputType? keyboardType,
// }) {
//   return TextField(
//     controller: controller,
//     maxLines: maxLines,
//     keyboardType: keyboardType,
//     style: TextStyle(fontSize: AppSize.font13Small, color: ctx.txtPrimary),
//     decoration: _inputDeco(ctx, hint),
//   );
// }
//
// Widget _mDropdown<T>(
//   BuildContext ctx,
//   String hint,
//   T? value,
//   List<T> items,
//   void Function(T?) onChanged,
// ) {
//   return DropdownButtonFormField<T>(
//     value: value,
//     hint: Text(hint,
//         style:
//             TextStyle(fontSize: AppSize.font12Small2, color: ctx.txtSecondary)),
//     items: items
//         .map((e) => DropdownMenuItem<T>(
//               value: e,
//               child: AppText(
//                 text: e.toString(),
//                 fontSize: AppSize.font13Small,
//                 color: ctx.txtPrimary,
//               ),
//             ))
//         .toList(),
//     onChanged: onChanged,
//     dropdownColor: ctx.cardBg,
//     style: TextStyle(fontSize: AppSize.font13Small, color: ctx.txtPrimary),
//     decoration: InputDecoration(
//       filled: true,
//       fillColor: ctx.appBg,
//       contentPadding: const EdgeInsets.symmetric(
//         horizontal: AppSize.space12,
//         vertical: AppSize.space10,
//       ),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//         borderSide: BorderSide(color: ctx.borderClr),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//         borderSide: BorderSide(color: ctx.borderClr),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//         borderSide: const BorderSide(
//           color: AppColors.backGroundEmeraldGreen,
//           width: AppSize.borderWidth1 + 0.5,
//         ),
//       ),
//     ),
//   );
// }
//
// Widget _twoCol(Widget left, Widget right) {
//   return Row(
//     children: [
//       Expanded(child: left),
//       const SizedBox(width: AppSize.space10),
//       Expanded(child: right),
//     ],
//   );
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  SECTION 1: IMAGES
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _ImagesSection extends StatelessWidget {
//   final AddNewProductCon c;
//   const _ImagesSection({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _FormCard(
//       icon: Icons.image_outlined,
//       iconBg: const Color(0xFFEDE9FE),
//       iconColor: const Color(0xFF7C3AED),
//       title: 'Product Images',
//       subtitle: 'Add up to 6 photos. First image is the cover.',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 90,
//             child: Obx(() {
//               final imgs = c.images;
//               final total = imgs.length < 6 ? imgs.length + 1 : 6;
//               return ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: total,
//                 itemBuilder: (_, i) {
//                   if (i < imgs.length) return _ImageThumb(index: i, c: c);
//                   // Add button
//                   return GestureDetector(
//                     onTap: () {},
//                     child: AppContainer(
//                       width: 90,
//                       height: 90,
//                       margin: EdgeInsets.only(
//                           right: i < total - 1 ? AppSize.space8 : 0),
//                       backgroundColor: context.appBg,
//                       borderRadius:
//                           BorderRadius.circular(AppSize.radius8Small2),
//                       border: Border.all(color: context.borderClr),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.add_photo_alternate_outlined,
//                             size: 24,
//                             color: context.txtSecondary,
//                           ),
//                           const SizedBox(height: AppSize.space4),
//                           AppText(
//                             text: 'Add Photo',
//                             fontSize: AppSize.font10XSmall,
//                             color: context.txtSecondary,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//           const SizedBox(height: AppSize.space8),
//           AppText(
//             text: 'Supported: JPG, PNG, WEBP  •  Max 5MB each',
//             fontSize: AppSize.font10XSmall,
//             color: context.txtSecondary,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ImageThumb extends StatelessWidget {
//   final int index;
//   final AddNewProductCon c;
//   const _ImageThumb({required this.index, required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         AppContainer(
//           width: 90,
//           height: 90,
//           margin: const EdgeInsets.only(right: AppSize.space8),
//           backgroundColor: AppColors.backgroundEmerald100,
//           borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//           border: index == 0
//               ? Border.all(
//                   color: AppColors.backGroundEmeraldGreen,
//                   width: AppSize.borderWidth2,
//                 )
//               : null,
//           child: const Icon(
//             Icons.image_outlined,
//             color: AppColors.backGroundEmeraldGreen,
//           ),
//         ),
//         if (index == 0)
//           Positioned(
//             bottom: 4,
//             left: 4,
//             child: AppContainer(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: AppSize.space4,
//                 vertical: 1,
//               ),
//               backgroundColor: AppColors.backGroundEmeraldGreen,
//               borderRadius: BorderRadius.circular(AppSize.space4),
//               child: const AppText(
//                 text: 'Cover',
//                 fontSize: 8,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.textWhite,
//               ),
//             ),
//           ),
//         Positioned(
//           top: 2,
//           right: 10,
//           child: GestureDetector(
//             onTap: () => c.images.removeAt(index),
//             child: AppContainer(
//               width: 18,
//               height: 18,
//               backgroundColor: AppColors.borderError,
//               borderRadius: BorderRadius.circular(9),
//               child: const Icon(Icons.close, size: 11, color: Colors.white),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  SECTION 2: BASIC INFO
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _BasicInfoSection extends StatelessWidget {
//   final AddNewProductCon c;
//   const _BasicInfoSection({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _FormCard(
//       icon: Icons.info_outline_rounded,
//       iconBg: AppColors.backgroundEmerald100,
//       iconColor: AppColors.iconEmeraldGreen,
//       title: 'Basic Information',
//       subtitle: 'Core details about your product',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Product Name with Autocomplete
//           _label(context, 'Product Name', required: true),
//           RawAutocomplete<String>(
//             textEditingController: c.productNameController,
//             focusNode: c.productNameFocusNode,
//             optionsBuilder: (tv) {
//               if (tv.text.trim().isEmpty) return const Iterable.empty();
//               final q = tv.text.toLowerCase();
//               return AddNewProductCon.productKeywords
//                   .where((k) => k.toLowerCase().contains(q))
//                   .take(7);
//             },
//             displayStringForOption: (o) => o,
//             fieldViewBuilder: (_, ctl, fn, __) => TextField(
//               controller: ctl,
//               focusNode: fn,
//               style: TextStyle(
//                   fontSize: AppSize.font13Small, color: context.txtPrimary),
//               decoration: _inputDeco(context, 'e.g. Premium Basmati Rice'),
//             ),
//             optionsViewBuilder: (_, onSel, options) => Align(
//               alignment: Alignment.topLeft,
//               child: Material(
//                 elevation: AppSize.elevation4,
//                 borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxHeight: 200),
//                   child: ListView.builder(
//                     padding: EdgeInsets.zero,
//                     shrinkWrap: true,
//                     itemCount: options.length,
//                     itemBuilder: (_, i) {
//                       final opt = options.elementAt(i);
//                       return InkWell(
//                         onTap: () => onSel(opt),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: AppSize.space14,
//                             vertical: AppSize.space10,
//                           ),
//                           child: AppText(
//                             text: opt,
//                             fontSize: AppSize.font13Small,
//                             color: context.txtPrimary,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: AppSize.space12),
//
//           // Description
//           _label(context, 'Description', required: true),
//           _mTextField(
//             context,
//             c.descriptionController,
//             'Describe quality, origin, and key features…',
//             maxLines: 3,
//           ),
//           const SizedBox(height: AppSize.space12),
//
//           // Category
//           _label(context, 'Category', required: true),
//           Obx(() => _mDropdown<String>(
//                 context,
//                 'Select category',
//                 c.selectedCategory.value.isEmpty
//                     ? null
//                     : c.selectedCategory.value,
//                 _kCategories,
//                 (v) {
//                   if (v != null) c.onCategoryChanged(v);
//                 },
//               )),
//           const SizedBox(height: AppSize.space12),
//
//           // Sub-Category
//           Obx(() {
//             final subs = c.currentSubCategories;
//             if (subs.isEmpty) return const SizedBox.shrink();
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _label(context, 'Sub-Category'),
//                 _mDropdown<String>(
//                   context,
//                   'Select sub-category',
//                   c.selectedSubCategory.value.isEmpty
//                       ? null
//                       : c.selectedSubCategory.value,
//                   subs,
//                   (v) {
//                     if (v != null) c.selectedSubCategory.value = v;
//                   },
//                 ),
//                 const SizedBox(height: AppSize.space12),
//               ],
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  SECTION 3: MARKETPLACE EXTRA (Variety / SKU)
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _MarketplaceExtraSection extends StatelessWidget {
//   final AddNewProductCon c;
//   const _MarketplaceExtraSection({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _FormCard(
//       icon: Icons.storefront_outlined,
//       iconBg: const Color(0xFFECFDF5),
//       iconColor: const Color(0xFF059669),
//       title: 'Marketplace Details',
//       subtitle: 'Optional identifiers for your listing',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _twoCol(
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Variety / Type'),
//               _mTextField(context, c.varietyController, 'e.g. Sella'),
//             ]),
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'SKU / Product Code'),
//               _mTextField(context, c.skuController, 'e.g. GVF-001'),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  SECTION 4: QUALITY & HARVEST
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _QualityHarvestSection extends StatelessWidget {
//   final AddNewProductCon c;
//   final bool showHarvestDate;
//   final bool harvestRequired;
//
//   const _QualityHarvestSection({
//     required this.c,
//     required this.showHarvestDate,
//     this.harvestRequired = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return _FormCard(
//       icon: Icons.eco_outlined,
//       iconBg: AppColors.backgroundEmerald100,
//       iconColor: AppColors.iconEmeraldGreen,
//       title: 'Quality & Harvest',
//       subtitle: 'Grade, storage, and harvest information',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Grade + Storage
//           _twoCol(
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Grade'),
//               Obx(() => _mDropdown<String>(
//                     context,
//                     'Select grade',
//                     c.selectedGrade.value.isEmpty
//                         ? null
//                         : c.selectedGrade.value,
//                     _kGrades,
//                     (v) {
//                       if (v != null) c.selectedGrade.value = v;
//                     },
//                   )),
//             ]),
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Storage Condition'),
//               Obx(() => _mDropdown<String>(
//                     context,
//                     'Select storage',
//                     c.selectedStorageCondition.value.isEmpty
//                         ? null
//                         : c.selectedStorageCondition.value,
//                     _kStorage,
//                     (v) {
//                       if (v != null) c.selectedStorageCondition.value = v;
//                     },
//                   )),
//             ]),
//           ),
//           const SizedBox(height: AppSize.space12),
//
//           // Harvest Date
//           if (showHarvestDate) ...[
//             _label(context, 'Harvest Date', required: harvestRequired),
//             Obx(() {
//               final dt = c.harvestDate.value;
//               return GestureDetector(
//                 onTap: () async {
//                   final picked = await showDatePicker(
//                     context: context,
//                     initialDate: dt ?? DateTime.now(),
//                     firstDate: DateTime(2020),
//                     lastDate: DateTime(2030),
//                     builder: (ctx, child) => Theme(
//                       data: Theme.of(ctx).copyWith(
//                         colorScheme: const ColorScheme.light(
//                           primary: AppColors.backGroundEmeraldGreen,
//                         ),
//                       ),
//                       child: child!,
//                     ),
//                   );
//                   if (picked != null) c.harvestDate.value = picked;
//                 },
//                 child: AppContainer(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: AppSize.space12,
//                     vertical: 11,
//                   ),
//                   backgroundColor: context.appBg,
//                   borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//                   border: Border.all(color: context.borderClr),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.calendar_today_outlined,
//                         size: AppSize.icon16Small,
//                         color: dt != null
//                             ? AppColors.backGroundEmeraldGreen
//                             : context.txtSecondary,
//                       ),
//                       const SizedBox(width: AppSize.space8),
//                       AppText(
//                         text: dt != null
//                             ? '${dt.day}/${dt.month}/${dt.year}'
//                             : 'Select harvest date',
//                         fontSize: AppSize.font13Small,
//                         color: dt != null
//                             ? context.txtPrimary
//                             : context.txtSecondary,
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//             const SizedBox(height: AppSize.space12),
//           ],
//
//           // Certifications + Crop Year
//           _twoCol(
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Certifications', hint: '(optional)'),
//               _mTextField(
//                   context, c.certificationsController, 'e.g. Organic, ISO'),
//             ]),
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Crop Year'),
//               _mTextField(context, c.cropYearController, 'e.g. 2025',
//                   keyboardType: TextInputType.number),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  SECTION 5: SPECIFICATIONS (Marketplace only)
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _SpecificationsSection extends StatelessWidget {
//   final AddNewProductCon c;
//   const _SpecificationsSection({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _FormCard(
//       icon: Icons.science_outlined,
//       iconBg: const Color(0xFFEFF6FF),
//       iconColor: const Color(0xFF2563EB),
//       title: 'Specifications',
//       subtitle: 'Chemical / nutritional details',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Quick-add chips
//           AppText(
//             text: 'Quick Add:',
//             fontSize: 11,
//             fontWeight: FontWeight.w600,
//             color: context.txtSecondary,
//           ),
//           const SizedBox(height: AppSize.space6),
//           Wrap(
//             spacing: AppSize.space6,
//             runSpacing: AppSize.space6,
//             children: c.quickSpecChips
//                 .map((chip) => GestureDetector(
//                       onTap: () => c.addSpecFromChip(chip),
//                       child: AppContainer(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: AppSize.space10,
//                           vertical: AppSize.space5,
//                         ),
//                         backgroundColor: context.appBg,
//                         borderRadius:
//                             BorderRadius.circular(AppSize.radius20Large),
//                         border: Border.all(color: context.borderClr),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.add,
//                                 size: 12,
//                                 color: AppColors.backGroundEmeraldGreen),
//                             const SizedBox(width: 3),
//                             AppText(
//                               text: chip,
//                               fontSize: 11,
//                               color: context.txtPrimary,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ))
//                 .toList(),
//           ),
//           const SizedBox(height: AppSize.space14),
//           Divider(height: 1, color: context.borderClr),
//           const SizedBox(height: AppSize.space12),
//
//           // Spec rows
//           Obx(() => Column(
//                 children: List.generate(
//                   c.specifications.length,
//                   (i) => _SpecRow(c: c, index: i),
//                 ),
//               )),
//           const SizedBox(height: AppSize.space8),
//
//           // Add row button
//           GestureDetector(
//             onTap: c.addEmptySpec,
//             child: AppContainer(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: AppSize.space10),
//               backgroundColor: context.appBg,
//               borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//               border: Border.all(color: context.borderClr),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.add_circle_outline,
//                     size: AppSize.icon16Small,
//                     color: AppColors.backGroundEmeraldGreen,
//                   ),
//                   const SizedBox(width: AppSize.space6),
//                   const AppText(
//                     text: 'Add Specification',
//                     fontSize: AppSize.font12Small2,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.backGroundEmeraldGreen,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _SpecRow extends StatelessWidget {
//   final AddNewProductCon c;
//   final int index;
//   const _SpecRow({required this.c, required this.index});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: AppSize.space8),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 4,
//             child: TextField(
//               controller: c.specNameControllers[index],
//               style: TextStyle(
//                   fontSize: AppSize.font12Small2, color: context.txtPrimary),
//               decoration: _inputDeco(context, 'e.g. Moisture').copyWith(
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
//             ),
//           ),
//           const SizedBox(width: AppSize.space6),
//           Expanded(
//             flex: 3,
//             child: TextField(
//               controller: c.specValueControllers[index],
//               keyboardType: TextInputType.number,
//               style: TextStyle(
//                   fontSize: AppSize.font12Small2, color: context.txtPrimary),
//               decoration: _inputDeco(context, 'e.g. 12').copyWith(
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
//             ),
//           ),
//           const SizedBox(width: AppSize.space6),
//           Expanded(
//             flex: 3,
//             child: Obx(() => DropdownButtonFormField<String>(
//                   value: c.specUnits[index],
//                   isDense: true,
//                   items: c.unitOptions
//                       .map((u) => DropdownMenuItem(
//                             value: u,
//                             child: AppText(
//                               text: u,
//                               fontSize: 11,
//                               color: context.txtPrimary,
//                             ),
//                           ))
//                       .toList(),
//                   onChanged: (v) {
//                     if (v != null) c.updateSpecUnit(index, v);
//                   },
//                   dropdownColor: context.cardBg,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: context.appBg,
//                     contentPadding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                     border: OutlineInputBorder(
//                         borderRadius:
//                             BorderRadius.circular(AppSize.radius8Small2),
//                         borderSide: BorderSide(color: context.borderClr)),
//                     enabledBorder: OutlineInputBorder(
//                         borderRadius:
//                             BorderRadius.circular(AppSize.radius8Small2),
//                         borderSide: BorderSide(color: context.borderClr)),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius:
//                           BorderRadius.circular(AppSize.radius8Small2),
//                       borderSide: const BorderSide(
//                           color: AppColors.backGroundEmeraldGreen,
//                           width: AppSize.borderWidth1 + 0.5),
//                     ),
//                   ),
//                 )),
//           ),
//           const SizedBox(width: AppSize.space6),
//           GestureDetector(
//             onTap: () => c.removeSpec(index),
//             child: const Icon(
//               Icons.remove_circle_outline,
//               size: 20,
//               color: AppColors.borderError,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  SECTION 6: SAMPLE AVAILABILITY (Marketplace only)
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _SampleSection extends StatelessWidget {
//   final AddNewProductCon c;
//   const _SampleSection({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _FormCard(
//       icon: Icons.science_outlined,
//       iconBg: AppColors.backgroundEmerald100,
//       iconColor: AppColors.iconEmeraldGreen,
//       title: 'Sample Availability',
//       subtitle: 'Offer a sample before bulk purchase',
//       child: Obx(() => Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Toggle row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText(
//                         text: 'Sample Available',
//                         fontSize: AppSize.font13Small,
//                         fontWeight: FontWeight.w600,
//                         color: context.txtPrimary,
//                       ),
//                       AppText(
//                         text: 'Buyers can request a sample',
//                         fontSize: 11,
//                         color: context.txtSecondary,
//                       ),
//                     ],
//                   ),
//                   Switch.adaptive(
//                     value: c.sampleAvailable.value,
//                     onChanged: (v) => c.sampleAvailable.value = v,
//                     activeThumbColor: Colors.white,
//                     activeTrackColor: AppColors.backGroundEmeraldGreen,
//                   ),
//                 ],
//               ),
//
//               if (c.sampleAvailable.value) ...[
//                 const SizedBox(height: AppSize.space14),
//                 Divider(height: 1, color: context.borderClr),
//                 const SizedBox(height: AppSize.space14),
//
//                 // Qty + Unit + Price
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _label(context, 'Sample Qty'),
//                             _mTextField(context, c.sampleQtyController, '0',
//                                 keyboardType: TextInputType.number),
//                           ]),
//                     ),
//                     const SizedBox(width: AppSize.space8),
//                     Expanded(
//                       flex: 2,
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _label(context, 'Unit'),
//                             _mDropdown<String>(
//                               context,
//                               'Unit',
//                               c.selectedSampleUnit.value.isEmpty
//                                   ? null
//                                   : c.selectedSampleUnit.value,
//                               _kSampleUnits,
//                               (v) {
//                                 if (v != null) c.selectedSampleUnit.value = v;
//                               },
//                             ),
//                           ]),
//                     ),
//                     const SizedBox(width: AppSize.space8),
//                     Expanded(
//                       flex: 3,
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _label(context, 'Sample Price'),
//                             _mTextField(
//                                 context, c.samplePriceController, '\$0.00',
//                                 keyboardType: TextInputType.number),
//                           ]),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: AppSize.space12),
//
//                 _label(context, 'Dispatch Time'),
//                 _mDropdown<String>(
//                   context,
//                   'When can you dispatch?',
//                   c.selectedDispatchTime.value.isEmpty
//                       ? null
//                       : c.selectedDispatchTime.value,
//                   _kDispatch,
//                   (v) {
//                     if (v != null) c.selectedDispatchTime.value = v;
//                   },
//                 ),
//                 const SizedBox(height: AppSize.space12),
//
//                 _label(context, 'Delivery Cost'),
//                 _mDropdown<String>(
//                   context,
//                   'Who pays delivery?',
//                   c.selectedDeliveryCoveredBy.value.isEmpty
//                       ? null
//                       : c.selectedDeliveryCoveredBy.value,
//                   _kDeliveryCost,
//                   (v) {
//                     if (v != null) c.selectedDeliveryCoveredBy.value = v;
//                   },
//                 ),
//               ],
//             ],
//           )),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  SECTION 7a: MARKETPLACE PRICING
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _MpPricingSection extends StatelessWidget {
//   final AddNewProductCon c;
//   const _MpPricingSection({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _FormCard(
//       icon: Icons.attach_money_rounded,
//       iconBg: const Color(0xFFECFDF5),
//       iconColor: const Color(0xFF059669),
//       title: 'Pricing & Quantity',
//       subtitle: 'Set your price, available stock, and minimum order',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Currency + Price
//           _twoCol(
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Currency'),
//               Obx(() => _mDropdown<String>(
//                     context,
//                     'Currency',
//                     c.selectedCurrency.value.isEmpty
//                         ? null
//                         : c.selectedCurrency.value,
//                     _kCurrencies,
//                     (v) {
//                       if (v != null) c.selectedCurrency.value = v;
//                     },
//                   )),
//             ]),
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Price per Unit', required: true),
//               _mTextField(context, c.priceController, 'e.g. 148',
//                   keyboardType: TextInputType.number),
//             ]),
//           ),
//           const SizedBox(height: AppSize.space12),
//           // Unit + Qty
//           _twoCol(
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Unit', required: true),
//               Obx(() => _mDropdown<String>(
//                     context,
//                     'Select unit',
//                     c.selectedUnit.value.isEmpty ? null : c.selectedUnit.value,
//                     _kUnits,
//                     (v) {
//                       if (v != null) c.selectedUnit.value = v;
//                     },
//                   )),
//             ]),
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Available Qty', required: true),
//               _mTextField(context, c.quantityController, 'e.g. 500',
//                   keyboardType: TextInputType.number),
//             ]),
//           ),
//           const SizedBox(height: AppSize.space12),
//           _label(context, 'Min. Order Qty (MOQ)'),
//           _mTextField(context, c.moqController, 'e.g. 10',
//               keyboardType: TextInputType.number),
//         ],
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  SECTION 7b: ADVANCE BOOKING PRICING
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _AbPricingSection extends StatelessWidget {
//   final AddNewProductCon c;
//   const _AbPricingSection({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _FormCard(
//       icon: Icons.attach_money_rounded,
//       iconBg: const Color(0xFFEFF6FF),
//       iconColor: const Color(0xFF2563EB),
//       title: 'Booking Pricing',
//       subtitle: 'Set booking price and estimated total',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _label(context, 'Currency'),
//           Obx(() => _mDropdown<String>(
//                 context,
//                 'Select currency',
//                 c.selectedCurrency.value.isEmpty
//                     ? null
//                     : c.selectedCurrency.value,
//                 _kCurrencies,
//                 (v) {
//                   if (v != null) c.selectedCurrency.value = v;
//                 },
//               )),
//           const SizedBox(height: AppSize.space12),
//           _twoCol(
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Booking Price', required: true),
//               _mTextField(context, c.bookingPriceController, 'e.g. 5000',
//                   keyboardType: TextInputType.number),
//             ]),
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Total Estimated'),
//               _mTextField(
//                   context, c.totalEstimatedPriceController, 'e.g. 30000',
//                   keyboardType: TextInputType.number),
//             ]),
//           ),
//           const SizedBox(height: AppSize.space12),
//           _twoCol(
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Unit', required: true),
//               Obx(() => _mDropdown<String>(
//                     context,
//                     'Unit',
//                     c.selectedUnit.value.isEmpty ? null : c.selectedUnit.value,
//                     _kUnits,
//                     (v) {
//                       if (v != null) c.selectedUnit.value = v;
//                     },
//                   )),
//             ]),
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Available Qty', required: true),
//               _mTextField(context, c.quantityController, 'e.g. 200',
//                   keyboardType: TextInputType.number),
//             ]),
//           ),
//           const SizedBox(height: AppSize.space12),
//           _label(context, 'Min. Order Qty (MOQ)'),
//           _mTextField(context, c.moqController, 'e.g. 10',
//               keyboardType: TextInputType.number),
//         ],
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  SECTION 7c: LIVE AUCTION PRICING
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _LaPricingSection extends StatelessWidget {
//   final AddNewProductCon c;
//   const _LaPricingSection({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _FormCard(
//       icon: Icons.attach_money_rounded,
//       iconBg: AppColors.backgroundAmberLight,
//       iconColor: const Color(0xFFD97706),
//       title: 'Auction Pricing',
//       subtitle: 'Starting bid and available lot size',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _twoCol(
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Currency'),
//               Obx(() => _mDropdown<String>(
//                     context,
//                     'Currency',
//                     c.selectedCurrency.value.isEmpty
//                         ? null
//                         : c.selectedCurrency.value,
//                     _kCurrencies,
//                     (v) {
//                       if (v != null) c.selectedCurrency.value = v;
//                     },
//                   )),
//             ]),
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Starting Bid', required: true),
//               _mTextField(context, c.startingBidController, 'e.g. 8000',
//                   keyboardType: TextInputType.number),
//             ]),
//           ),
//           const SizedBox(height: AppSize.space12),
//           _twoCol(
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Unit', required: true),
//               Obx(() => _mDropdown<String>(
//                     context,
//                     'Unit',
//                     c.selectedUnit.value.isEmpty ? null : c.selectedUnit.value,
//                     _kUnits,
//                     (v) {
//                       if (v != null) c.selectedUnit.value = v;
//                     },
//                   )),
//             ]),
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _label(context, 'Lot Qty', required: true),
//               _mTextField(context, c.quantityController, 'e.g. 100',
//                   keyboardType: TextInputType.number),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  SECTION 8: AUCTION END DATE/TIME (Live Auction only)
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _AuctionDetailsSection extends StatelessWidget {
//   final AddNewProductCon c;
//   const _AuctionDetailsSection({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _FormCard(
//       icon: Icons.timer_outlined,
//       iconBg: AppColors.backgroundAmberLight,
//       iconColor: const Color(0xFFD97706),
//       title: 'Auction End Date & Time',
//       badge: 'Required',
//       subtitle: 'When will the auction close?',
//       child: Obx(() {
//         final dt = c.auctionEndDateTime.value;
//         return GestureDetector(
//           onTap: () async {
//             final ctx = context;
//             final date = await showDatePicker(
//               context: ctx,
//               initialDate: dt ?? DateTime.now().add(const Duration(days: 3)),
//               firstDate: DateTime.now(),
//               lastDate: DateTime(2030),
//               builder: (bCtx, child) => Theme(
//                 data: Theme.of(bCtx).copyWith(
//                   colorScheme: const ColorScheme.light(
//                     primary: Color(0xFFD97706),
//                   ),
//                 ),
//                 child: child!,
//               ),
//             );
//             if (date == null || !ctx.mounted) return;
//             final time = await showTimePicker(
//               context: ctx,
//               initialTime: TimeOfDay.fromDateTime(
//                   dt ?? DateTime.now().add(const Duration(hours: 1))),
//             );
//             if (time != null) {
//               c.auctionEndDateTime.value = DateTime(
//                   date.year, date.month, date.day, time.hour, time.minute);
//             }
//           },
//           child: AppContainer(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(
//               horizontal: AppSize.space14,
//               vertical: AppSize.space14,
//             ),
//             backgroundColor:
//                 dt != null ? AppColors.backgroundAmberLight : context.appBg,
//             borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//             border: Border.all(
//               color: dt != null ? const Color(0xFFFCD34D) : context.borderClr,
//               width: dt != null
//                   ? AppSize.borderWidth1 + 0.5
//                   : AppSize.borderWidth1,
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.event_rounded,
//                   size: AppSize.icon20Medium,
//                   color: dt != null
//                       ? const Color(0xFFD97706)
//                       : context.txtSecondary,
//                 ),
//                 const SizedBox(width: AppSize.space10),
//                 Expanded(
//                   child: dt != null
//                       ? Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             AppText(
//                               text: '${dt.day}/${dt.month}/${dt.year}',
//                               fontSize: AppSize.font14Medium2,
//                               fontWeight: FontWeight.w700,
//                               color: context.txtPrimary,
//                             ),
//                             AppText(
//                               text:
//                                   '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}',
//                               fontSize: AppSize.font12Small2,
//                               color: const Color(0xFFD97706),
//                             ),
//                           ],
//                         )
//                       : AppText(
//                           text: 'Tap to select auction end date & time',
//                           fontSize: AppSize.font13Small,
//                           color: context.txtSecondary,
//                         ),
//                 ),
//                 Icon(Icons.chevron_right_rounded, color: context.txtSecondary),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  SECTION 9: LOCATION & DELIVERY (CSCPickerPlus)
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _LocationSection extends StatelessWidget {
//   final AddNewProductCon c;
//   final bool showDelivery;
//   const _LocationSection({required this.c, required this.showDelivery});
//
//   @override
//   Widget build(BuildContext context) {
//     return _FormCard(
//       icon: Icons.location_on_outlined,
//       iconBg: AppColors.badgeLightRed,
//       iconColor: AppColors.borderError,
//       title: 'Location & Delivery',
//       subtitle: 'Where is the product and how will it be delivered?',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ✅ CSCPickerPlus replaces all custom country dropdowns
//           CSCPickerPlus(
//             showStates: true,
//             showCities: true,
//             flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
//             dropdownDecoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//               border: Border.all(color: context.borderClr),
//               color: context.appBg,
//             ),
//             disabledDropdownDecoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//               border: Border.all(color: context.borderClr),
//               color: context.appBg,
//             ),
//             countryDropdownLabel: 'Select Country',
//             stateDropdownLabel: 'Select State / Region',
//             cityDropdownLabel: 'Select City',
//             selectedItemStyle: TextStyle(
//               fontSize: AppSize.font13Small,
//               color: context.txtPrimary,
//             ),
//             dropdownHeadingStyle: TextStyle(
//               fontSize: AppSize.font13Small,
//               fontWeight: FontWeight.w600,
//               color: context.txtPrimary,
//             ),
//             dropdownItemStyle: TextStyle(
//               fontSize: AppSize.font13Small,
//               color: context.txtPrimary,
//             ),
//             dropdownDialogRadius: AppSize.radius8Small2,
//             searchBarRadius: AppSize.radius8Small2,
//             onCountryChanged: (val) => c.selectedCountry.value = val ?? '',
//             onStateChanged: (val) => c.selectedState.value = val ?? '',
//             onCityChanged: (val) => c.selectedCity.value = val ?? '',
//           ),
//
//           if (showDelivery) ...[
//             const SizedBox(height: AppSize.space12),
//             _label(context, 'Delivery Option'),
//             Obx(() => _mDropdown<String>(
//                   context,
//                   'How will it be delivered?',
//                   c.selectedDeliveryOption.value.isEmpty
//                       ? null
//                       : c.selectedDeliveryOption.value,
//                   _kDelivery,
//                   (v) {
//                     if (v != null) c.selectedDeliveryOption.value = v;
//                   },
//                 )),
//             const SizedBox(height: AppSize.space12),
//             _label(context, 'Estimated Delivery Time'),
//             _mTextField(
//                 context, c.deliveryTimeController, 'e.g. 5–7 business days'),
//           ],
//         ],
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  SECTION 10: TAGS
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _TagsSection extends StatelessWidget {
//   final AddNewProductCon c;
//   const _TagsSection({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return _FormCard(
//       icon: Icons.label_outline_rounded,
//       iconBg: AppColors.badgePurple,
//       iconColor: const Color(0xFF9333EA),
//       title: 'Tags',
//       subtitle: 'Help buyers find your product',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Current tags
//           Obx(() => c.tags.isEmpty
//               ? const SizedBox.shrink()
//               : Padding(
//                   padding: const EdgeInsets.only(bottom: AppSize.space10),
//                   child: Wrap(
//                     spacing: AppSize.space6,
//                     runSpacing: AppSize.space6,
//                     children: c.tags
//                         .map((tag) => AppContainer(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: AppSize.space10,
//                                 vertical: AppSize.space5,
//                               ),
//                               backgroundColor: AppColors.backgroundEmerald100,
//                               borderRadius:
//                                   BorderRadius.circular(AppSize.radius20Large),
//                               border: Border.all(color: AppColors.emerald100),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   AppText(
//                                     text: tag,
//                                     fontSize: AppSize.font12Small2,
//                                     fontWeight: FontWeight.w500,
//                                     color: AppColors.backGroundEmeraldGreen,
//                                   ),
//                                   const SizedBox(width: AppSize.space4),
//                                   GestureDetector(
//                                     onTap: () => c.removeTag(tag),
//                                     child: const Icon(
//                                       Icons.close,
//                                       size: 13,
//                                       color: AppColors.backGroundEmeraldGreen,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ))
//                         .toList(),
//                   ),
//                 )),
//
//           // Tag input row
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: c.tagInputController,
//                   style: TextStyle(
//                       fontSize: AppSize.font13Small, color: context.txtPrimary),
//                   decoration: _inputDeco(context, 'Add a tag…'),
//                   onSubmitted: c.addTag,
//                 ),
//               ),
//               const SizedBox(width: AppSize.space8),
//               GestureDetector(
//                 onTap: () => c.addTag(c.tagInputController.text),
//                 child: AppContainer(
//                   height: 42,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: AppSize.space14),
//                   backgroundColor: AppColors.backGroundEmeraldGreen,
//                   borderRadius: BorderRadius.circular(AppSize.radius8Small2),
//                   alignment: Alignment.center,
//                   child: const AppText(
//                     text: 'Add',
//                     fontSize: AppSize.font13Small,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textWhite,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: AppSize.space6),
//           AppText(
//             text: 'Press Enter or tap Add to insert a tag',
//             fontSize: AppSize.font10XSmall,
//             color: context.txtSecondary,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  BOTTOM ACTION BAR
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class _BottomActionBar extends StatelessWidget {
//   final AddNewProductCon c;
//   const _BottomActionBar({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppContainer(
//       padding: EdgeInsets.fromLTRB(
//         AppSize.space16,
//         AppSize.space12,
//         AppSize.space16,
//         AppSize.space12 + MediaQuery.of(context).padding.bottom,
//       ),
//       backgroundColor: context.cardBg,
//       border: Border(top: BorderSide(color: context.borderClr)),
//       boxShadows: [
//         BoxShadow(
//           color: AppColors.shadowBase.withValues(alpha: 0.06), // ✅ Fixed
//           blurRadius: 8,
//           offset: const Offset(0, -2),
//         ),
//       ],
//       child: Row(
//         children: [
//           // Save Draft
//           Expanded(
//             child: AppOutlinedButton(
//               text: 'Save Draft',
//               icon: Icons.save_outlined,
//               iconSize: AppSize.icon16Small,
//               iconColor: context.txtPrimary,
//               textColor: context.txtPrimary,
//               foregroundColor: context.txtPrimary,
//               border: BorderSide(color: context.borderClr),
//               borderRadius: AppSize.radius10Medium,
//               height: AppSize.buttonHeight52,
//               onPressed: c.saveDraft,
//             ),
//           ),
//           const SizedBox(width: AppSize.space12),
//           // Publish (flex: 2 wider)
//           Expanded(
//             flex: 2,
//             child: AppElevatedButton(
//               text: 'Publish Product',
//               icon: Icons.send_rounded,
//               iconSize: AppSize.icon16Small,
//               iconColor: AppColors.textWhite,
//               textColor: AppColors.textWhite,
//               backgroundColor: AppColors.buttonEmeraldGreen,
//               borderRadius: AppSize.radius10Medium,
//               height: AppSize.buttonHeight52,
//               elevation: AppSize.elevation0,
//               fontWeight: FontWeight.w700,
//               fontSize: AppSize.font13Small,
//               onPressed: c.publishProduct,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
