/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2025-09-04 08:44:10
 */
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class AttachLocationUtilsCore {
  void attachDialog({
    required BuildContext context,
    required Widget child,
    Alignment alignment = Alignment.centerRight,
  }) async {
    SmartDialog.showAttach(
      targetContext: context,
      alignment: alignment,
      animationType: SmartAnimationType.fade,
      usePenetrate: true,
      debounce: true,
      clickMaskDismiss: false,
      builder: (_) => TapRegion(
        onTapOutside: (event) {
          SmartDialog.dismiss();
        },
        child: child,
      ),
    );
  }
}
