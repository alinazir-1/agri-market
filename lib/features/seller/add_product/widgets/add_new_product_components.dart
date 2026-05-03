// // lib/features/seller/add_product/widgets/add_product_form_widgets.dart
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agri_market/core/constants/colors.dart';
// import 'package:agri_market/core/constants/sizes.dart';
// import '../../../../shared/widgets/common/app_container.dart';
// import '../../../../shared/widgets/common/app_text.dart';
//
// class FormLabel extends StatelessWidget {
//   final String label;
//   final bool required;
//   final String? hint;
//
//   const FormLabel(
//       {super.key, required this.label, this.required = false, this.hint});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: AppSize.space5),
//       child: Row(
//         children: [
//           AppText(
//             text: label,
//             fontSize: AppSize.font11XSmall2,
//             fontWeight: FontWeight.w700,
//             color: AppColors.textPrimary,
//           ),
//           if (required)
//             const AppText(
//               text: ' *',
//               fontSize: AppSize.font11XSmall2,
//               color: AppColors.textError,
//             ),
//           if (hint != null)
//             AppText(
//               text: '  $hint',
//               fontSize: AppSize.font10XSmall,
//               color: AppColors.textSecondary,
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// class FormTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String placeholder;
//   final String? prefixText;
//   final int maxLines;
//   final TextInputType? keyboardType;
//
//   const FormTextField({
//     super.key,
//     required this.controller,
//     required this.placeholder,
//     this.prefixText,
//     this.maxLines = 1,
//     this.keyboardType,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       maxLines: maxLines,
//       keyboardType: keyboardType,
//       style: const TextStyle(
//           fontSize: AppSize.font11XSmall2, color: AppColors.textPrimary),
//       decoration: InputDecoration(
//         hintText: placeholder,
//         prefixText: prefixText,
//         hintStyle: const TextStyle(
//             fontSize: AppSize.font11XSmall2, color: AppColors.textSecondary),
//         prefixStyle: const TextStyle(
//           fontSize: AppSize.font11XSmall2,
//           color: AppColors.textSecondary,
//           fontWeight: FontWeight.w600,
//         ),
//         filled: true,
//         fillColor: AppColors.backgroundSurface,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: AppSize.space12,
//           vertical: AppSize.space8,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppSize.radius10Medium),
//           borderSide: const BorderSide(color: AppColors.borderGray),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppSize.radius10Medium),
//           borderSide: const BorderSide(color: AppColors.borderGray),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppSize.radius10Medium),
//           borderSide: const BorderSide(
//             color: AppColors.borderEmeraldGreen,
//             width: AppSize.borderWidth1,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class FormDropdown extends StatelessWidget {
//   final String hint;
//   final RxString value;
//   final List<String> items;
//   final void Function(String)? onChanged;
//
//   const FormDropdown({
//     super.key,
//     required this.hint,
//     required this.value,
//     required this.items,
//     this.onChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => DropdownButtonFormField<String>(
//         value: value.value.isEmpty ? null : value.value,
//         hint: Text(hint,
//             style: const TextStyle(
//                 fontSize: AppSize.font11XSmall2,
//                 color: AppColors.textSecondary)),
//         style: const TextStyle(
//             fontSize: AppSize.font11XSmall2, color: AppColors.textPrimary),
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: AppColors.backgroundSurface,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: AppSize.space12,
//             vertical: AppSize.space8,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(AppSize.radius10Medium),
//             borderSide: const BorderSide(color: AppColors.borderGray),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(AppSize.radius10Medium),
//             borderSide: const BorderSide(color: AppColors.borderGray),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(AppSize.radius10Medium),
//             borderSide: const BorderSide(color: AppColors.borderEmeraldGreen),
//           ),
//         ),
//         items: items
//             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//             .toList(),
//         onChanged: (val) {
//           if (val == null) return;
//           onChanged != null ? onChanged!(val) : value.value = val;
//         },
//       ),
//     );
//   }
// }
//
// class FormDatePicker extends StatelessWidget {
//   final Rx<DateTime?> value;
//   final String placeholder;
//   final bool includeTime;
//
//   const FormDatePicker({
//     super.key,
//     required this.value,
//     required this.placeholder,
//     this.includeTime = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => InkWell(
//           onTap: () async {
//             final date = await showDatePicker(
//               context: context,
//               initialDate: DateTime.now().add(const Duration(days: 1)),
//               firstDate: DateTime.now(),
//               lastDate: DateTime(2035),
//             );
//             if (date == null) return;
//             if (!includeTime) {
//               value.value = date;
//               return;
//             }
//             final time = await showTimePicker(
//               context: context,
//               initialTime: TimeOfDay.now(),
//             );
//             if (time == null) return;
//             value.value = DateTime(
//                 date.year, date.month, date.day, time.hour, time.minute);
//           },
//           child: AppContainer(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: AppSize.space12, vertical: AppSize.space8),
//             backgroundColor: AppColors.backgroundSurface,
//             border: Border.all(color: AppColors.borderGray),
//             borderRadius: BorderRadius.circular(AppSize.radius10Medium),
//             child: Row(
//               children: [
//                 Icon(
//                   includeTime
//                       ? Icons.access_time_rounded
//                       : Icons.calendar_today_outlined,
//                   size: AppSize.icon16Small,
//                   color: AppColors.iconEmeraldGreen,
//                 ),
//                 const SizedBox(width: AppSize.space8),
//                 Expanded(
//                   child: AppText(
//                     text: value.value != null
//                         ? includeTime
//                             ? '${value.value!.day}/${value.value!.month}/${value.value!.year} ${value.value!.hour.toString().padLeft(2, '0')}:${value.value!.minute.toString().padLeft(2, '0')}'
//                             : '${value.value!.day}/${value.value!.month}/${value.value!.year}'
//                         : placeholder,
//                     fontSize: AppSize.font11XSmall2,
//                     color: value.value != null
//                         ? AppColors.textPrimary
//                         : AppColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
