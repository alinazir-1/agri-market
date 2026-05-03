import 'package:get/get.dart';

/// Registers once via [Get.lazyPut], then [Get.find] (avoids eager [Get.put] in build).
T lazyPutFind<T extends GetxController>(
  T Function() factory, {
  String? tag,
}) {
  if (!Get.isRegistered<T>(tag: tag)) {
    Get.lazyPut(factory, tag: tag, fenix: true);
  }
  return Get.find<T>(tag: tag);
}
