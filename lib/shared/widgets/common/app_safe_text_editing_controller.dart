import 'package:flutter/material.dart';

/// [TextEditingController] that exposes [isDisposed] so UI can skip attaching during route teardown.
///
/// Use for controllers owned by [GetxController]s that may outlive or be torn down with overlaid routes.
class AppSafeTextEditingController extends TextEditingController {
  AppSafeTextEditingController({super.text});

  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    super.dispose();
  }
}
