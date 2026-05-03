// lib/core/utils/product_image_storage.dart
// Hive + web-safe product photos: JPEG bytes → optional resize → base64 with prefix.

import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Stored in [ProductModel.images] / inventory so [AppUrlOrAssetImage] can detect bytes.
const String kProductImageHivePrefix = 'b64:';

class ProductImageStorage {
  ProductImageStorage._();

  static const int _maxEdgePx = 1280;
  static const int _jpegQuality = 78;

  /// Resize (if large) and re-encode as JPEG to keep Hive entries smaller.
  static Uint8List compressBytes(Uint8List input) {
    try {
      final decoded = img.decodeImage(input);
      if (decoded == null) return input;
      img.Image out = decoded;
      if (decoded.width > _maxEdgePx || decoded.height > _maxEdgePx) {
        out = decoded.width >= decoded.height
            ? img.copyResize(decoded, width: _maxEdgePx)
            : img.copyResize(decoded, height: _maxEdgePx);
      }
      return Uint8List.fromList(img.encodeJpg(out, quality: _jpegQuality));
    } catch (_) {
      return input;
    }
  }

  static String toHiveString(Uint8List jpegBytes) {
    return '$kProductImageHivePrefix${base64Encode(jpegBytes)}';
  }

  /// Thumbnail path for lists / grids (first image or empty → placeholder in [AppUrlOrAssetImage]).
  static String firstOrEmpty(List<String> images) =>
      images.isNotEmpty ? images.first : '';

  static Uint8List? decodeHiveStringToBytes(String s) {
    try {
      if (s.startsWith(kProductImageHivePrefix)) {
        return base64Decode(s.substring(kProductImageHivePrefix.length));
      }
      if (s.startsWith('data:image')) {
        final i = s.indexOf(',');
        if (i == -1) return null;
        return base64Decode(s.substring(i + 1));
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
