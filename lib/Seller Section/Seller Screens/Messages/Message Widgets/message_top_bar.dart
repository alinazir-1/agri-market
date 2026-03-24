import 'package:flutter/material.dart';
import '../../../../Shared/Screens Common Widgets/screen_top_bar.dart';
import '../message_con.dart';

/// Thin wrapper so existing [MessagesScr] code stays unchanged.
/// Delegates to the shared [ScreenTopBar].
class MessageTopBar extends StatelessWidget {
  final MessagesCon messageController;
  const MessageTopBar({super.key, required this.messageController});

  @override
  Widget build(BuildContext context) => ScreenTopBar(
        title: 'Messages',
        subtitle: 'Communicate with your buyers',
        searchController: messageController.topSearchController,
        onSearch: messageController.onTopSearch,
        searchHint: 'Search conversations...',
      );
}
