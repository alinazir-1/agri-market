import 'package:get/get.dart';

import 'package:agri_market/shared/widgets/common/app_safe_text_editing_controller.dart';

/// Buyer chrome search: hero banner + compact top bar share one field.
///
/// Registered **permanent** ([HomeBinding.ensureBuyerShellSearchCon]) so this controller is
/// **not** tied to [HomeCon] lifecycle. That avoids `TextEditingController was used after being
/// disposed` when routes are replaced (e.g. product detail → `Get.offAllNamed` home) while the
/// tree is still unmounting [AppTextField]s.
///
/// Dispose runs only if this controller is explicitly deleted (e.g. full app teardown / logout flow).
class BuyerShellSearchCon extends GetxController {
  final AppSafeTextEditingController searchCtrl = AppSafeTextEditingController();

  @override
  void onClose() {
    if (!searchCtrl.isDisposed) {
      searchCtrl.dispose();
    }
    super.onClose();
  }
}
