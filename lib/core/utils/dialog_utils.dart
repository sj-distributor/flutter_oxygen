/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2025-09-10 10:40:33
 */
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class DialogUtilsCore {
  /// [builder]：自定义 dialog
  ///
  /// [clickMaskDismiss]：true（点击遮罩后，将关闭dialog），false（不关闭）
  ///
  /// [usePenetrate]：true（点击事件将穿透遮罩），false（不穿透）
  ///
  /// [useAnimation]：true（使用动画），false（不使用）
  ///
  /// [debounce]：防抖功能
  ///
  /// [controller]：可使用该控制器来刷新自定义的dialog的布局
  ///
  /// [alignment]：控制弹窗的位置, 详细请参照[SmartConfigCustom]中alignment参数说明
  ///
  /// [animationType]：设置动画类型, 具体可参照[SmartAnimationType]注释
  ///
  /// [maskColor]：遮罩颜色，如果给[maskWidget]设置了值，该参数将会失效
  ///
  /// [bindWidget]：将dialog与某个Widget绑定, 当该widget不可见时, dialog自动隐藏, 该widget可见时, dialog自动显示;
  /// 适用于PageView, TabView之类, 绑定其子页面, 切换页面时, dialog也能合理交互
  /// 注意: [bindWidget]处理逻辑高于[bindPage], 当[bindWidget]不为null, [bindPage]将自动被设置为false
  ///
  /// [onDismiss]：在dialog被关闭的时候，该回调将会被触发

  /// 显示对话框
  static Future<T?> show<T>({
    required Widget Function(BuildContext) builder,
    bool clickMaskDismiss = true,
    bool? usePenetrate,
    bool useAnimation = true,
    bool debounce = true,
    bool hideMaskColor = false,
    BuildContext? bindWidget,
    SmartDialogController? controller,
    Alignment alignment = Alignment.center,
    SmartAnimationType? animationType,
    Color? maskColor,
    VoidCallback? onDismiss,
  }) async {
    return await SmartDialog.show<T>(
      clickMaskDismiss: clickMaskDismiss,
      usePenetrate: usePenetrate,
      useAnimation: useAnimation,
      debounce: debounce,
      controller: controller,
      alignment: alignment,
      animationType: animationType,
      maskColor: hideMaskColor ? Colors.transparent : maskColor,
      bindWidget: bindWidget,
      onDismiss: onDismiss,
      builder: builder,
    );
  }

  /// 关闭当前dialog
  static Future<void> dismiss<T>({
    SmartStatus status = SmartStatus.smart,
    String? tag,
    T? result,
    bool force = false,
  }) async {
    SmartDialog.dismiss(
      status: SmartStatus.dialog,
      tag: tag,
      result: result,
      force: force,
    );
  }
}
