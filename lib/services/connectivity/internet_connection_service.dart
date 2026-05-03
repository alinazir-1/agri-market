import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class InternetConnectionService extends GetxService {
  final RxBool isOnline = true.obs;
  StreamSubscription<List<ConnectivityResult>>? _sub;

  Future<InternetConnectionService> init() async {
    final current = await Connectivity().checkConnectivity();
    isOnline.value = _hasInternet(current);
    _sub = Connectivity().onConnectivityChanged.listen((results) {
      final online = _hasInternet(results);
      if (online == isOnline.value) return;
      isOnline.value = online;
      if (!online) {
        Get.snackbar('Offline', 'Internet connection is not available.');
      } else {
        Get.snackbar('Online', 'Internet connection restored.');
      }
    });
    return this;
  }

  bool _hasInternet(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
