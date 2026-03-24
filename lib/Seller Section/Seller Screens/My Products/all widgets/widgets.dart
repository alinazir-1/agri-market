import 'package:flutter/material.dart';
import '../../../../Core/Constant/colors.dart';
import '../../../../Core/Constant/sizes.dart';
import '../../../../Shared/Screens Common Widgets/screen_filter_chip.dart';

// ── 1. StatusPill ─────────────────────────────────────────────────────────────
class StatusPill extends StatelessWidget {
  final String label;
  final Color bg;
  final Color text;
  const StatusPill(
      {super.key, required this.label, required this.bg, required this.text});
  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: CSize.space8, vertical: 2),
        decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(CSize.radius20Large)),
        child: Text(label,
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w700, color: text)),
      );
}

// ── 2. GradePill ─────────────────────────────────────────────────────────────
class GradePill extends StatelessWidget {
  final String grade;
  const GradePill({super.key, required this.grade});
  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: CSize.space5, vertical: 1),
        decoration: BoxDecoration(
            color: const Color(0xFFFBBF24),
            borderRadius: BorderRadius.circular(CSize.radius20Large)),
        child: Text('GRADE $grade',
            style: const TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w800,
                color: Color(0xFF78350F))),
      );
}

// ── 3. MpFilterChip ──────────────────────────────────────────────────────────
// Thin wrapper — delegates to shared ScreenFilterChip.
typedef MpFilterChip = ScreenFilterChip;

// ── 4. TableEditBtn ───────────────────────────────────────────────────────────
class TableEditBtn extends StatelessWidget {
  final VoidCallback onTap;
  const TableEditBtn({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
              color: CColors.backgroundEmerald100,
              borderRadius: BorderRadius.circular(CSize.radius5Small),
              border: Border.all(
                  color: const Color(0xFFD1FAE5), width: CSize.borderWidth1)),
          child: const Icon(Icons.edit_outlined,
              size: 12, color: CColors.iconEmeraldGreen),
        ),
      );
}

// ── 5. TableDeleteBtn ─────────────────────────────────────────────────────────
class TableDeleteBtn extends StatelessWidget {
  final VoidCallback onTap;
  const TableDeleteBtn({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
              color: const Color(0xFFFFF5F5),
              borderRadius: BorderRadius.circular(CSize.radius5Small),
              border: Border.all(
                  color: const Color(0xFFFCA5A5), width: CSize.borderWidth1)),
          child: const Icon(Icons.delete_outline_rounded,
              size: 12, color: CColors.iconError),
        ),
      );
}

// ── 6. ProductImageCell ───────────────────────────────────────────────────────
class ProductImageCell extends StatelessWidget {
  final String imagePath;
  final String name;
  final String category;
  final String grade;
  const ProductImageCell(
      {super.key,
      required this.imagePath,
      required this.name,
      required this.category,
      required this.grade});
  @override
  Widget build(BuildContext context) => Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(CSize.radius10Medium),
          child: Image.asset(imagePath,
              width: 38,
              height: 38,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                  width: 38,
                  height: 38,
                  color: CColors.backgroundEmerald100,
                  child: const Icon(Icons.image_outlined,
                      size: CSize.icon16Small,
                      color: CColors.iconEmeraldGreen))),
        ),
        const SizedBox(width: CSize.space10),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: CColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Row(children: [
            Text(category,
                style:
                    const TextStyle(fontSize: 9, color: CColors.textSecondary)),
            const SizedBox(width: CSize.space5),
            GradePill(grade: grade),
          ]),
        ])),
      ]);
}

// ── 7. TimerBadge ─────────────────────────────────────────────────────────────
class TimerBadge extends StatelessWidget {
  final String text;
  final bool isEnded;
  final bool isEndingSoon;
  const TimerBadge(
      {super.key,
      required this.text,
      required this.isEnded,
      required this.isEndingSoon});
  @override
  Widget build(BuildContext context) {
    final Color bg = isEnded
        ? const Color(0xFFFEE2E2)
        : isEndingSoon
            ? const Color(0xFFFEF9C3)
            : CColors.backgroundEmerald100;
    final Color text = isEnded
        ? const Color(0xFF991B1B)
        : isEndingSoon
            ? const Color(0xFF854D0E)
            : CColors.textEmeraldGreen;
    final Color dot = isEnded
        ? const Color(0xFF991B1B)
        : isEndingSoon
            ? const Color(0xFF854D0E)
            : CColors.textEmeraldGreen;
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: CSize.space8, vertical: 3),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(CSize.radius20Large)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
        const SizedBox(width: CSize.space4),
        Text(this.text,
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w700, color: text)),
      ]),
    );
  }
}

// ── 8. HarvestBadge ───────────────────────────────────────────────────────────
class HarvestBadge extends StatelessWidget {
  final String date;
  final bool isAlmostFull;
  const HarvestBadge(
      {super.key, required this.date, required this.isAlmostFull});
  @override
  Widget build(BuildContext context) {
    final Color bg =
        isAlmostFull ? const Color(0xFFFEF9C3) : CColors.backgroundEmerald100;
    final Color text =
        isAlmostFull ? const Color(0xFF854D0E) : CColors.textEmeraldGreen;
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: CSize.space8, vertical: 3),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(CSize.radius20Large)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.calendar_today_outlined, size: 9, color: text),
        const SizedBox(width: CSize.space4),
        Text(date,
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w700, color: text)),
      ]),
    );
  }
}

// ── 9. TableHeader ────────────────────────────────────────────────────────────
class TableHeader extends StatelessWidget {
  final List<String> columns;
  const TableHeader({super.key, required this.columns});
  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
            color: Color(0xFFF0FDF4),
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))),
        child: Row(
            children: columns
                .map((col) => Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: CSize.space14, vertical: CSize.space10),
                      child: Text(col.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: CColors.textSecondary,
                              letterSpacing: 0.5)),
                    )))
                .toList()),
      );
}

// ── 10. Grid Card shared helpers ──────────────────────────────────────────────
class GridCardWrapper extends StatelessWidget {
  final Widget child;
  final bool isWarning;
  const GridCardWrapper(
      {super.key, required this.child, this.isWarning = false});
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: CColors.backGroundWhite,
          borderRadius: BorderRadius.circular(CSize.radius20Large),
          border: Border.all(
              color:
                  isWarning ? const Color(0xFFFED7AA) : const Color(0xFFE2E8F0),
              width: CSize.borderWidth1),
        ),
        child: child,
      );
}
