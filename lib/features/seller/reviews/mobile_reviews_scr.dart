// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agri_market/core/constants/colors.dart';
// import 'package:agri_market/core/theme/app_theme.dart';
// import 'package:agri_market/data/models/review_model.dart';
// import 'package:agri_market/features/seller/reviews/review_rating_con.dart';
// import 'package:agri_market/features/seller/reviews/widgets/reply_dialog.dart';
//
// class MobileReviewsScr extends StatelessWidget {
//   const MobileReviewsScr({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<ReviewsCon>();
//     return Scaffold(
//       backgroundColor: context.appBg,
//       body: Column(
//         children: [
//           _RatingHeader(c: c),
//           _StatsBar(c: c),
//           _FilterChips(c: c),
//           Expanded(child: _ReviewList(c: c)),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Rating Header ──────────────────────────────────────────────────────────
//
// class _RatingHeader extends StatelessWidget {
//   final ReviewsCon c;
//   const _RatingHeader({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Container(
//           color: context.cardBg,
//           padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
//           child: Row(
//             children: [
//               // Big number
//               Column(
//                 children: [
//                   Text(
//                     c.avgRating.toStringAsFixed(1),
//                     style: TextStyle(
//                       fontSize: 40,
//                       fontWeight: FontWeight.w900,
//                       color: context.txtPrimary,
//                       height: 1,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   _StarRow(rating: c.avgRating.round()),
//                   const SizedBox(height: 2),
//                   Text('${c.totalReviews} reviews',
//                       style: TextStyle(
//                           fontSize: 10, color: context.txtSecondary)),
//                 ],
//               ),
//               const SizedBox(width: 20),
//               // Rating bars
//               Expanded(
//                 child: Column(
//                   children: List.generate(5, (i) {
//                     final star = 5 - i;
//                     final fraction = c.ratingBarWidth(star);
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 4),
//                       child: Row(
//                         children: [
//                           Text('$star',
//                               style: TextStyle(
//                                   fontSize: 10,
//                                   color: context.txtSecondary)),
//                           const SizedBox(width: 4),
//                           Icon(Icons.star_rounded,
//                               size: 10, color: const Color(0xFFFBBF24)),
//                           const SizedBox(width: 6),
//                           Expanded(
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(3),
//                               child: LinearProgressIndicator(
//                                 value: fraction,
//                                 backgroundColor: context.borderClr,
//                                 valueColor: const AlwaysStoppedAnimation(
//                                     Color(0xFFFBBF24)),
//                                 minHeight: 6,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//                           Text('${c.countByRating(star)}',
//                               style: TextStyle(
//                                   fontSize: 10,
//                                   color: context.txtSecondary)),
//                         ],
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
//
// class _StarRow extends StatelessWidget {
//   final int rating;
//   const _StarRow({required this.rating});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: List.generate(
//         5,
//         (i) => Icon(
//           i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
//           size: 14,
//           color: const Color(0xFFFBBF24),
//         ),
//       ),
//     );
//   }
// }
//
// // ── Stats Strip ────────────────────────────────────────────────────────────
//
// class _StatsBar extends StatelessWidget {
//   final ReviewsCon c;
//   const _StatsBar({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Container(
//           color: context.cardBg,
//           child: Row(
//             children: [
//               _stat(context, '${c.totalReviews}', 'Total',
//                   CColors.iconEmeraldGreen, CColors.backgroundEmerald100),
//               Container(width: 1, height: 40, color: context.dividerClr),
//               _stat(context, '${c.repliedCount}', 'Replied',
//                   CColors.iconEmeraldGreen, CColors.backgroundEmerald100),
//               Container(width: 1, height: 40, color: context.dividerClr),
//               _stat(context, '${c.pendingCount}', 'Pending',
//                   CColors.backGroundOrange, const Color(0xFFFFF7ED)),
//               Container(width: 1, height: 40, color: context.dividerClr),
//               _stat(context, '${c.flaggedCount}', 'Flagged',
//                   CColors.iconError, const Color(0xFFFEE2E2)),
//             ],
//           ),
//         ));
//   }
//
//   Widget _stat(BuildContext context, String value, String label, Color fg, Color bg) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         color: bg,
//         child: Column(
//           children: [
//             Text(value,
//                 style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w800,
//                     color: fg)),
//             const SizedBox(height: 2),
//             Text(label,
//                 style: TextStyle(fontSize: 9, color: context.txtSecondary)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Filter Chips ───────────────────────────────────────────────────────────
//
// class _FilterChips extends StatelessWidget {
//   final ReviewsCon c;
//   const _FilterChips({required this.c});
//
//   static const _filters = [
//     (ReviewFilter.all, 'All', CColors.backGroundEmeraldGreen, CColors.borderEmeraldGreen),
//     (ReviewFilter.fiveStar, '5 ★', CColors.backGroundEmeraldGreen, CColors.borderEmeraldGreen),
//     (ReviewFilter.fourStar, '4 ★', CColors.backGroundEmeraldGreen, CColors.borderEmeraldGreen),
//     (ReviewFilter.threeStar, '3 ★', CColors.backGroundEmeraldGreen, CColors.borderEmeraldGreen),
//     (ReviewFilter.pendingReply, 'Pending', CColors.backGroundOrange, CColors.backGroundOrange),
//     (ReviewFilter.flagged, 'Flagged', CColors.borderError, CColors.borderError),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 44,
//       child: Obx(() {
//         final activeFilter = c.selectedFilter.value;
//         return ListView.separated(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             itemCount: _filters.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 6),
//             itemBuilder: (_, i) {
//               final (filter, label, activeColor, activeBorder) = _filters[i];
//               final active = activeFilter == filter;
//               return GestureDetector(
//                 onTap: () => c.setFilter(filter),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 150),
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: active ? activeColor : context.cardBg,
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(
//                       color: active ? activeBorder : context.borderClr,
//                     ),
//                   ),
//                   child: Text(
//                     label,
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w600,
//                       color: active ? CColors.textWhite : context.txtSecondary,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//       }),
//     );
//   }
// }
//
// // ── Review List ────────────────────────────────────────────────────────────
//
// class _ReviewList extends StatelessWidget {
//   final ReviewsCon c;
//   const _ReviewList({required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final list = c.filteredReviews;
//       if (list.isEmpty) {
//         return Center(
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             Icon(Icons.rate_review_outlined,
//                 size: 48, color: context.txtSecondary),
//             const SizedBox(height: 12),
//             Text('No reviews found',
//                 style: TextStyle(fontSize: 14, color: context.txtSecondary)),
//           ]),
//         );
//       }
//       return ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: list.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 10),
//         itemBuilder: (_, i) => _ReviewCard(review: list[i], c: c),
//       );
//     });
//   }
// }
//
// class _ReviewCard extends StatelessWidget {
//   final ReviewModel review;
//   final ReviewsCon c;
//   const _ReviewCard({required this.review, required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: context.cardBg,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: review.isFlagged
//               ? CColors.borderError.withOpacity(0.4)
//               : context.borderClr,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Reviewer info + rating
//           Row(
//             children: [
//               Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                   color: review.avatarColor,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(
//                     review.buyerName.substring(0, 2).toUpperCase(),
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(review.buyerName,
//                         style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w700,
//                             color: context.txtPrimary)),
//                     Text(review.buyerLocation,
//                         style: TextStyle(
//                             fontSize: 10, color: context.txtSecondary)),
//                   ],
//                 ),
//               ),
//               _StarRow(rating: review.rating),
//               if (review.isFlagged)
//                 Padding(
//                   padding: const EdgeInsets.only(left: 6),
//                   child: Icon(Icons.flag_rounded,
//                       size: 14, color: CColors.iconError),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           // Product tag
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//             decoration: BoxDecoration(
//               color: CColors.backgroundEmerald100,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(
//               '${review.productEmoji} ${review.productName}',
//               style: const TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600,
//                   color: CColors.textEmeraldGreen),
//             ),
//           ),
//           const SizedBox(height: 8),
//           // Review text
//           Text(
//             review.reviewText,
//             style: TextStyle(
//                 fontSize: 12,
//                 color: context.txtSecondary,
//                 height: 1.5),
//             maxLines: 3,
//             overflow: TextOverflow.ellipsis,
//           ),
//           // Seller reply preview
//           if (review.sellerReply != null) ...[
//             const SizedBox(height: 8),
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: CColors.backgroundEmerald100,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: CColors.borderEmeraldGreen.withOpacity(0.3)),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(Icons.reply_rounded,
//                       size: 12, color: CColors.iconEmeraldGreen),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: Text(
//                       review.sellerReply!,
//                       style: const TextStyle(
//                           fontSize: 11,
//                           color: CColors.textEmeraldGreen,
//                           height: 1.4),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//           const SizedBox(height: 10),
//           // Actions
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 c.formatDate(review.reviewDate),
//                 style: TextStyle(fontSize: 10, color: context.txtSecondary),
//               ),
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => c.toggleFlag(review.id),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 5),
//                       decoration: BoxDecoration(
//                         color: review.isFlagged
//                             ? const Color(0xFFFEE2E2)
//                             : context.cardBg2,
//                         borderRadius: BorderRadius.circular(6),
//                         border: Border.all(
//                           color: review.isFlagged
//                               ? CColors.borderError
//                               : context.borderClr,
//                         ),
//                       ),
//                       child: Icon(
//                         review.isFlagged
//                             ? Icons.flag_rounded
//                             : Icons.flag_outlined,
//                         size: 13,
//                         color: review.isFlagged
//                             ? CColors.iconError
//                             : context.txtSecondary,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   if (review.sellerReply == null)
//                     GestureDetector(
//                       onTap: () => Get.dialog(ReviewReplyDialog(
//                         review: review,
//                         controller: c.replyController,
//                         onSubmit: () => c.submitReply(review.id),
//                       )),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 5),
//                         decoration: BoxDecoration(
//                           color: CColors.backgroundEmerald100,
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: const Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.reply_rounded,
//                                 size: 13, color: CColors.iconEmeraldGreen),
//                             SizedBox(width: 4),
//                             Text('Reply',
//                                 style: TextStyle(
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.w600,
//                                     color: CColors.textEmeraldGreen)),
//                           ],
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
