// import 'package:agri/Core/Constant/sizes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../Core/Constant/colors.dart';
// import '../../Seller Section/Seller Screens/Marketplace/marketplace_con.dart';
//
// class CategorySection extends StatelessWidget {
//   const CategorySection({super.key, required this.marketPlaceController});
//
//   final MarketplaceCon marketPlaceController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Column(
//         children: [
//           Row(
//             children: [
//               // ── Back Button ──
//               Obx(
//                 () => GestureDetector(
//                   onTap: marketPlaceController.selectedIndex.value > 0
//                       ? marketPlaceController.scrollPrevious
//                       : null,
//                   child: Container(
//                     height: 40,
//                     padding: const EdgeInsets.all(CSize.space2),
//                     decoration: BoxDecoration(
//                       color: marketPlaceController.selectedIndex.value > 0
//                           ? CColors.backGroundEmeraldGreen
//                           : CColors.borderGray.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(CSize.radius24XLarge),
//                     ),
//                     child: const Icon(
//                       Icons.arrow_back_ios_new_outlined,
//                       size: CSize.icon20Medium,
//                       color: CColors.iconWhite,
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(width: CSize.space10),
//
//               // ── Category List ──
//               Expanded(
//                 flex: 2,
//                 child: SizedBox(
//                   height: 40,
//                   child: ListView.builder(
//                     controller: marketPlaceController.categoryScrollController,
//                     scrollDirection: Axis.horizontal,
//                     itemCount: marketPlaceController.category.length,
//                     itemBuilder: (context, index) {
//                       final cat = marketPlaceController.category[index];
//
//                       return Obx(
//                         () => GestureDetector(
//                           onTap: () =>
//                               marketPlaceController.selectCategory(index),
//                           child: Container(
//                             margin: const EdgeInsets.only(right: CSize.space12),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: CSize.space16,
//                               vertical: CSize.space8,
//                             ),
//                             decoration: BoxDecoration(
//                               color:
//                                   marketPlaceController.selectedIndex.value ==
//                                       index
//                                   ? CColors.backGroundFreshGreen.withOpacity(
//                                       0.2,
//                                     )
//                                   : CColors.backGroundTransparent,
//                               borderRadius: BorderRadius.circular(
//                                 CSize.radius10Medium,
//                               ),
//                               border: Border.all(
//                                 color:
//                                     marketPlaceController.selectedIndex.value ==
//                                         index
//                                     ? CColors.borderEmeraldGreen
//                                     : CColors.borderGray,
//                                 width: CSize.borderWidth1,
//                               ),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 cat.name,
//                                 style: TextStyle(
//                                   fontSize: CSize.font16Medium,
//                                   fontWeight: FontWeight.w500,
//                                   color:
//                                       marketPlaceController
//                                               .selectedIndex
//                                               .value ==
//                                           index
//                                       ? CColors.textEmeraldGreen
//                                       : CColors.textPrimary,
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 maxLines: 1,
//                                 softWrap: false,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//
//               const SizedBox(width: CSize.space10),
//
//               // ── Forward Button ──
//               Obx(
//                 () => GestureDetector(
//                   onTap:
//                       marketPlaceController.selectedIndex.value <
//                           marketPlaceController.category.length - 1
//                       ? marketPlaceController.scrollNext
//                       : null,
//                   child: Container(
//                     height: 40,
//                     padding: const EdgeInsets.all(CSize.space2),
//                     decoration: BoxDecoration(
//                       color:
//                           marketPlaceController.selectedIndex.value <
//                               marketPlaceController.category.length - 1
//                           ? CColors.backGroundEmeraldGreen
//                           : CColors.borderGray.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(CSize.radius24XLarge),
//                     ),
//                     child: const Icon(
//                       Icons.arrow_forward_ios_outlined,
//                       size: CSize.icon20Medium,
//                       color: CColors.iconWhite,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
