/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-05-24 09:20:05
 */
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class LoadingUtilsCore {
  /// loading弹窗
  /// [msg]：loading 的信息（使用[builder]参数，该参数将失效）\
  /// [controller]：可使用该控制器来刷新自定义的loading的布局\
  /// [alignment]：控制弹窗的位置, 详细请参照[SmartConfigLoading]中alignment参数说明\
  /// [clickMaskDismiss]：true（点击遮罩后，将关闭loading），false（不关闭）\
  /// [animationType]：具体可参照[SmartAnimationType]注释\
  /// [nonAnimationTypes]：对于不同的场景, 可动态关闭弹窗动画, 具体请参照[SmartNonAnimationType]\
  /// [animationBuilder]：支持高度自定义动画, 具体可参照[AnimationBuilder]说明\
  /// [usePenetrate]：true（点击事件将穿透遮罩），false（不穿透）\
  /// [useAnimation]：true（使用动画），false（不使用）\
  /// [animationTime]：动画持续时间\
  /// [maskColor]：遮罩颜色，如果给[maskWidget]设置了值，该参数将会失效\
  /// [maskWidget]：可高度定制遮罩\
  /// [onDismiss]：在dialog被关闭的时候，该回调将会被触发\
  /// [onMask]：点击遮罩时，该回调将会被触发\
  /// [displayTime]：控制弹窗在屏幕上显示时间; 默认为null, 为null则代表该参数不会控制弹窗关闭\
  /// [backDismiss]：true（返回事件将关闭loading，但是不会关闭页面），false（返回事件不会关闭loading，也不会关闭页面）
  static void loading({
    String? msg,
    SmartDialogController? controller,
    Alignment? alignment,
    bool? clickMaskDismiss,
    SmartAnimationType? animationType,
    List<SmartNonAnimationType>? nonAnimationTypes,
    Widget Function(AnimationController, Widget, AnimationParam)?
    animationBuilder,
    bool? usePenetrate,
    bool? useAnimation,
    Duration? animationTime,
    Color? maskColor,
    Widget? maskWidget,
    void Function()? onDismiss,
    void Function()? onMask,
    Duration? displayTime,
    SmartBackType? backType,
    Widget Function(BuildContext)? builder,
  }) {
    if (msg == null) {
      builder ??= (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      };
    }

    SmartDialog.showLoading(
      msg: msg ?? 'Loading',
      alignment: alignment,
      clickMaskDismiss: clickMaskDismiss,
      animationType: animationType,
      nonAnimationTypes: nonAnimationTypes,
      animationBuilder: animationBuilder,
      usePenetrate: usePenetrate,
      useAnimation: useAnimation,
      animationTime: animationTime,
      maskColor: maskColor,
      maskWidget: maskWidget,
      onDismiss: onDismiss,
      onMask: onMask,
      displayTime: displayTime,
      backType: backType,
      builder: builder,
    );
  }

  static Future<void> dismiss() async {
    await SmartDialog.dismiss(status: SmartStatus.loading);
  }
}
