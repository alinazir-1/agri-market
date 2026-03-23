import 'package:flutter/material.dart';
import '../../Core/Constant/colors.dart';

class CDropdownField extends StatelessWidget {
  final String? value;
  final String hint;
  final ValueChanged<String?> onChanged;
  final double height;

  const CDropdownField({
    super.key,
    required this.value,
    required this.hint,
    required this.onChanged,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: CColors.borderGray),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(hint),
              icon: const Icon(Icons.keyboard_arrow_down),
              isExpanded: true,
              items: const ["Option 1", "Option 2", "Option 3", "Option 4"]
                  .map(
                    (e) => DropdownMenuItem<String>(value: e, child: Text(e)),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
