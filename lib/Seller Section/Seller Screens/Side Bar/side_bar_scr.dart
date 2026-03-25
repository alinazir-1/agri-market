import 'package:agri_market/Seller%20Section/Seller%20Screens/Side%20Bar/side_bar_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/colors.dart';
import 'Side Bar Widgets/side_bar_widget.dart';

class SellerSideBarScr extends StatelessWidget {
  SellerSideBarScr({super.key});

  final SellerSideBarCon c = Get.find();

  /// Screens narrower than this use a Drawer instead of a persistent sidebar.
  static const double _drawerBreakpoint = 900;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final useDrawer = width < _drawerBreakpoint;

    if (useDrawer) {
      return Scaffold(
        key: c.scaffoldKey,
        backgroundColor: CColors.backGroundWhite,
        drawer: Drawer(
          width: 260,
          backgroundColor: CColors.backGroundWhite,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: SafeArea(
            child: SideBar(c: c, forceExpanded: true),
          ),
        ),
        body: SafeArea(
          child: Obx(
            () => _LazyIndexedStack(
              index: c.selectedIndex.value,
              children: c.screens,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      key: c.scaffoldKey,
      backgroundColor: CColors.backGroundWhite,
      body: SafeArea(
        child: Row(
          children: [
            SideBar(c: c),
            Expanded(
              child: Obx(
                () => _LazyIndexedStack(
                  index: c.selectedIndex.value,
                  children: c.screens,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Builds each screen only when first visited, then keeps it alive.
/// Unlike [IndexedStack] which builds all children upfront.
class _LazyIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const _LazyIndexedStack({required this.index, required this.children});

  @override
  State<_LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<_LazyIndexedStack> {
  late final List<bool> _built;

  @override
  void initState() {
    super.initState();
    _built = List.generate(
      widget.children.length,
      (i) => i == widget.index,
    );
  }

  @override
  void didUpdateWidget(_LazyIndexedStack old) {
    super.didUpdateWidget(old);
    if (!_built[widget.index]) {
      _built[widget.index] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: List.generate(widget.children.length, (i) {
        return Offstage(
          offstage: i != widget.index,
          child: _built[i] ? widget.children[i] : const SizedBox.shrink(),
        );
      }),
    );
  }
}
