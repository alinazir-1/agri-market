import 'dart:io';

import 'package:flutter/widgets.dart';

bool _isLikelyFilePath(String p) =>
    p.contains(r':\') || p.startsWith('/') || p.startsWith(r'\\');

Widget? buildLocalFileImage({
  required String path,
  required double? width,
  required double? height,
  required BoxFit fit,
  required Widget Function() placeholder,
}) {
  if (!_isLikelyFilePath(path)) return null;
  final f = File(path);
  if (!f.existsSync()) {
    return placeholder();
  }
  return Image.file(
    f,
    width: width,
    height: height,
    fit: fit,
    errorBuilder: (_, __, ___) => placeholder(),
  );
}
