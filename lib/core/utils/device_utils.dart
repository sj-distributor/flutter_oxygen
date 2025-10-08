/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-04-24 20:43:11
 */
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_oxygen/flutter_oxygen.dart';
import 'package:get_user_agent/get_user_agent.dart';

class DeviceUtilsCore {
  static bool get isWeb => kIsWeb;

  static bool get isWindows => !isWeb && Platform.isWindows;
  static bool get isMacOS => !isWeb && Platform.isMacOS;
  static bool get isLinux => !isWeb && Platform.isLinux;

  static bool get isAndroid => !isWeb && Platform.isAndroid;
  static bool get isIOS => !isWeb && Platform.isIOS;

  static bool get isDesktop => isWindows || isMacOS || isLinux;

  static bool get isApp => isAndroid || isIOS;

  static bool get isWebPc => isWeb && !isMobileUserAgent();
  static bool get isWebMobile => isWeb && isMobileUserAgent();

  /// 判断是否移动端web
  static bool isMobileUserAgent() {
    final userAgent = UserAgent();
    RegExp mobileRegExp = RegExp(
      r'android|webos|iphone|ipad|ipod|blackberry|iemobile|opera mini',
      caseSensitive: false,
    );
    return mobileRegExp.hasMatch(userAgent.getUserAgent().toLowerCase());
  }

  static Size getScreenSize() {
    // final window = WidgetsBinding.instance.window;
    final window = PlatformDispatcher.instance.views.first;
    final pixelRatio = window.devicePixelRatio;
    final width = window.physicalSize.width / pixelRatio;
    final height = window.physicalSize.height / pixelRatio;
    return Size(width, height);
  }

  /// 判断是否iPad
  static bool get isIPad {
    if (!isWebMobile && isDesktop) return false;

    final shortestSide = getScreenSize().shortestSide;
    return shortestSide >= 600 && shortestSide <= 800;

    // final double shortestSide = MediaQuery.of(context).size.shortestSide;
    // return shortestSide >= 600 && shortestSide <= 800;
  }

  /// 获取设备类型，分开判断是因为web端不支持Platform
  static DeviceTypeEnum getDeviceType() {
    if (isWebPc) return DeviceTypeEnum.desktop;
    if (isIPad) return DeviceTypeEnum.iPad;
    if (isWebMobile) return DeviceTypeEnum.mobile;
    if (isApp) return DeviceTypeEnum.mobile;
    return DeviceTypeEnum.desktop;
  }

  /// 获取设备信息
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    return deviceInfo.data;
  }
}
