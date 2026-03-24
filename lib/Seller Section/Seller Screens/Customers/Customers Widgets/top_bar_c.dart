import 'package:flutter/material.dart';
import '../../../../Shared/Screens Common Widgets/screen_top_bar.dart';
import '../customers_con.dart';

/// Thin wrapper so existing [CustomersScr] code stays unchanged.
/// Delegates to the shared [ScreenTopBar].
class TopBar extends StatelessWidget {
  final CustomersCon c;
  const TopBar({super.key, required this.c});

  @override
  Widget build(BuildContext context) => ScreenTopBar(
        title: 'Customers',
        subtitle: 'Manage your buyer relationships',
        searchController: c.searchController,
        onSearch: c.onSearch,
        searchHint: 'Search by name, email...',
      );
}
