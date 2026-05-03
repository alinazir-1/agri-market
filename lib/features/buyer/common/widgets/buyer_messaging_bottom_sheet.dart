// lib/features/buyer/common/widgets/buyer_messaging_bottom_sheet.dart
//
// LinkedIn-style **bottom-right dock** (not centered): panel #1 = inbox list;
// panel #2 = full chat opens to the **left** when the user selects a thread.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/features/buyer/common/widgets/buyer_home_messages_con.dart';
import 'package:agri_market/features/seller/messages/widgets/message_components.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

class BuyerMessagingBottomSheet {
  BuyerMessagingBottomSheet._();

  /// Inset from the **left** so the dock sits toward the right but not flush
  /// to the viewport edge (matches reference: floating, slightly inset).
  static const double _dockInsetLeft = 72;

  /// Inset from the **right** — keeps the tray off the hard edge.
  static const double _dockInsetRight = 28;

  /// Horizontal gap between chat panel and inbox list (side-by-side).
  static const double _panelGap = 8;

  static const double _listPanelWidth = 300;
  static const double _minChatWidth = 280;
  static const double _idealChatWidth = 420;
  static const double _maxChatWidth = 480;

  static Future<void> open(
    BuildContext context, {
    bool openWithChatPanel = false,
  }) {
    final con = Get.find<BuyerHomeMessagesCon>();
    if (openWithChatPanel) {
      con.prepareBuyerDockWithChatPanel();
    } else {
      con.prepareBuyerDockInboxOnly();
    }

    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: AppColors.shadowBase.withValues(alpha: 0.22),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (dialogCtx, animation, secondaryAnimation) {
        final screenH = MediaQuery.sizeOf(dialogCtx).height;
        final dockH = (screenH * 0.58).clamp(380.0, 600.0);

        return MediaQuery.removePadding(
          context: dialogCtx,
          removeBottom: true,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(dialogCtx).pop(),
                  child: ColoredBox(
                    color: AppColors.backGroundTransparent,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    _dockInsetLeft,
                    0,
                    _dockInsetRight,
                    0,
                  ),
                child: GestureDetector(
                  onTap: () {},
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxRowW = constraints.maxWidth;
                      return Obx(() {
                        final chatOpen = con.buyerDockChatPanelOpen.value;
                        final interior = maxRowW -
                            _listPanelWidth -
                            (chatOpen ? _panelGap : 0);
                        final chatW = chatOpen
                            ? interior
                                .clamp(_minChatWidth, _maxChatWidth)
                                .toDouble()
                            : 0.0;
                        final useSideBySide =
                            chatOpen && interior >= _minChatWidth;

                        if (!chatOpen || useSideBySide) {
                          return _DockCard(
                            height: dockH,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (chatOpen) ...[
                                  SizedBox(
                                    width: chatW.clamp(
                                      _minChatWidth,
                                      _idealChatWidth,
                                    ),
                                    child: ChatWindow(messageController: con),
                                  ),
                                  SizedBox(width: _panelGap),
                                ],
                                SizedBox(
                                  width: _listPanelWidth.clamp(
                                    0,
                                    maxRowW,
                                  ),
                                  child: _InboxPanel(
                                    messageController: con,
                                    listPlacedAtRowEnd: chatOpen,
                                    onClose: () =>
                                        Navigator.of(dialogCtx).pop(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // Narrow: chat above, inbox below (still bottom-right block).
                        return _DockCard(
                          height: dockH,
                          width: maxRowW.clamp(280, _listPanelWidth + 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 3,
                                child: ChatWindow(messageController: con),
                              ),
                              const SizedBox(height: AppSize.space8),
                              const Divider(
                                height: 1,
                                color: AppColors.borderLight,
                              ),
                              Expanded(
                                flex: 2,
                                child: _InboxPanel(
                                  messageController: con,
                                  listPlacedAtRowEnd: false,
                                  onClose: () =>
                                      Navigator.of(dialogCtx).pop(),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
          ),
        );
      },
      transitionBuilder: (ctx, animation, secondary, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.02, 0.08),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        );
      },
    );
  }
}

class _DockCard extends StatelessWidget {
  const _DockCard({
    required this.height,
    required this.child,
    this.width,
  });

  final double height;
  final double? width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      shadowColor: AppColors.shadowBase.withValues(alpha: 0.2),
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSize.radius12),
      ),
      clipBehavior: Clip.antiAlias,
      color: AppColors.backGroundWhite,
      child: width != null
          ? SizedBox(width: width, height: height, child: child)
          : SizedBox(height: height, child: child),
    );
  }
}

class _InboxPanel extends StatelessWidget {
  const _InboxPanel({
    required this.messageController,
    required this.listPlacedAtRowEnd,
    required this.onClose,
  });

  final BuyerHomeMessagesCon messageController;
  final bool listPlacedAtRowEnd;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppContainer(
          padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
          border: const Border(
            bottom: BorderSide(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              const AppText(
                text: 'Messaging',
                fontSize: AppSize.font18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: AppSize.space8),
              Obx(() {
                final n = messageController.totalUnread;
                if (n <= 0) return const SizedBox.shrink();
                return AppContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.space8,
                    vertical: AppSize.space2,
                  ),
                  backgroundColor: AppColors.emeraldGreen,
                  borderRadius: BorderRadius.circular(AppSize.radius20),
                  child: AppText(
                    text: '$n unread',
                    fontSize: AppSize.font8,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWhite,
                  ),
                );
              }),
              const Spacer(),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {},
                  child: AppContainer(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(AppSize.radius8),
                    child: const Icon(
                      Icons.more_horiz_rounded,
                      size: AppSize.icon20,
                      color: AppColors.iconSecondary,
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {},
                  child: AppContainer(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(AppSize.radius8),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: AppSize.icon16,
                      color: AppColors.iconSecondary,
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onClose,
                  child: AppContainer(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(AppSize.radius8),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: AppSize.icon24,
                      color: AppColors.iconSecondary,
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onClose,
                  child: AppContainer(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(AppSize.radius8),
                    child: const Icon(
                      Icons.close_rounded,
                      size: AppSize.icon20,
                      color: AppColors.iconSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ConversationList(
            messageController: messageController,
            listPlacedAtRowEnd: listPlacedAtRowEnd,
            showSectionHeader: false,
          ),
        ),
      ],
    );
  }
}
