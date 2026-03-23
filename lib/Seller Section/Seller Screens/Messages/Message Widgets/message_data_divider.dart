// ── 4. Date Divider ──────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';

class MessageDateDivider extends StatelessWidget {
  final String label;

  const MessageDateDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Divider(color: Color(0xFFE2E8F0), thickness: 0.5)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: CSize.space8),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 9,
                color: CColors.textSecondary,
                fontWeight: FontWeight.w600),
          ),
        ),
        const Expanded(
            child: Divider(color: Color(0xFFE2E8F0), thickness: 0.5)),
      ],
    );
  }
}
