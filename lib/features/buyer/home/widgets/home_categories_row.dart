// home_categories_row.dart
import 'package:flutter/material.dart';
import 'package:agri_market/features/buyer/home/home_con.dart';

class HomeCategoriesRow extends StatelessWidget {
  const HomeCategoriesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE8F5E9))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: HomeCon.categories
                  .map((cat) => _CategoryChip(cat: cat))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const _StartSellingBtn(),
      ]),
    );
  }
}

class _CategoryChip extends StatefulWidget {
  final Map<String, String> cat;
  const _CategoryChip({required this.cat});
  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(right: 3),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFFF1F8F1) : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: _hovered ? const Color(0xFF4CAF50) : Colors.transparent,
            ),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Image.asset(
              widget.cat['image']!,
              width: 18,
              height: 18,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.eco, size: 16, color: Color(0xFF4CAF50)),
            ),
            const SizedBox(width: 5),
            Text(
              widget.cat['label']!,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: _hovered
                    ? const Color(0xFF1B5E20)
                    : const Color(0xFF374151),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _StartSellingBtn extends StatefulWidget {
  const _StartSellingBtn();
  @override
  State<_StartSellingBtn> createState() => _StartSellingBtnState();
}

class _StartSellingBtnState extends State<_StartSellingBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFF145214) : const Color(0xFF1B5E20),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.storefront_outlined, color: Colors.white, size: 14),
            SizedBox(width: 5),
            Text('+ Start Selling',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5)),
          ]),
        ),
      ),
    );
  }
}
