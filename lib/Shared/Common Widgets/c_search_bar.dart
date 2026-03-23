import 'package:flutter/material.dart';
import '../../Core/Constant/colors.dart';
import 'c_container.dart';

class CSearchBar extends StatelessWidget {
  final double? width;
  final String hintText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool autofocus;
  final Color? backgroundColor;

  const CSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.controller,
    this.onChanged,
    this.onTap,
    this.autofocus = false,
    this.backgroundColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CContainer(
      width: width,
      backgroundColor: backgroundColor,
      border: Border.all(color: CColors.borderGray),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onTap: onTap,
              autofocus: autofocus,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: CColors.textGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 12,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.search,
              color: CColors.iconGreen.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
