/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-04-29 09:44:05
 */
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ToastUtilsCore {
  // 私有构造函数
  ToastUtilsCore._internal();

  static final ToastUtilsCore _instance = ToastUtilsCore._internal();
  static ToastUtilsCore get instance => _instance;

  // 工厂构造函数，防止误调用
  factory ToastUtilsCore() => _instance;

  /// 关闭当前toast
  static Future<void> dismiss() async {
    SmartDialog.dismiss(status: SmartStatus.toast);
  }

  /// 关闭全部toast
  static Future<void> dismissAll() async {
    SmartDialog.dismiss(status: SmartStatus.allToast);
  }

  /// showToast
  static Future<void> showToast(
    /// 显示内容
    String message, {

    /// 显示时长
    Duration? duration,

    /// 点击mask关闭
    bool clickMaskDismiss = false,

    /// 是否穿透点击
    bool usePenetrate = true,

    /// mask遮罩层颜色
    Color maskColor = Colors.transparent,

    /// 对其方式
    Alignment alignment = Alignment.center,

    /// 显示逻辑
    SmartToastType displayType = SmartToastType.onlyRefresh,
  }) async {
    await SmartDialog.dismiss();
    SmartDialog.showToast(
      message,
      displayTime: duration,
      clickMaskDismiss: clickMaskDismiss,
      usePenetrate: usePenetrate,
      maskColor: maskColor,
      alignment: alignment,
      displayType: displayType,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Text(message, style: const TextStyle(color: Colors.white)),
        );
      },
    );
  }
}
