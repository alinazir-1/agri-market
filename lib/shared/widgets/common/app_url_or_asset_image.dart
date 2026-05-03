import 'package:flutter/material.dart';
import 'package:agri_market/shared/widgets/common/app_url_or_asset_image_file_stub.dart'
    if (dart.library.io)
        'package:agri_market/shared/widgets/common/app_url_or_asset_image_file_io.dart'
    as file_image_builder;

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/core/utils/product_image_storage.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';

/// Hive / web: `b64:` + base64 JPEG, `data:image/...;base64,...`, assets, or legacy http(s).
class AppUrlOrAssetImage extends StatelessWidget {
  const AppUrlOrAssetImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;

  static bool isNetwork(String p) =>
      p.startsWith('http://') || p.startsWith('https://');

  Widget _placeholder() => AppContainer(
        width: width,
        height: height,
        backgroundColor: AppColors.badgeSuccessBg,
        alignment: Alignment.center,
        child: const Icon(Icons.image_outlined,
            size: AppSize.icon20, color: AppColors.iconEmeraldGreen),
      );

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) {
      return _placeholder();
    }
    final mem = ProductImageStorage.decodeHiveStringToBytes(path);
    if (mem != null) {
      return Image.memory(
        mem,
        width: width,
        height: height,
        fit: fit,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    if (isNetwork(path)) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => AppContainer(
          width: width,
          height: height,
          backgroundColor: AppColors.badgeSuccessBg,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image,
              size: AppSize.icon20, color: AppColors.iconSecondary),
        ),
      );
    }
    final local = file_image_builder.buildLocalFileImage(
      path: path,
      width: width,
      height: height,
      fit: fit,
      placeholder: _placeholder,
    );
    if (local != null) return local;
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }
}
