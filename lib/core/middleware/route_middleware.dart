/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-07-29 14:13:30
 */
import 'package:flutter/material.dart';
import 'package:flutter_oxygen/flutter_oxygen.dart' hide Route;

class RouteMiddlewareCore extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    super.didPush(route, previousRoute);

    // 设置当前页路由
    if (route.settings.name != null &&
        previousRoute?.settings.name != route.settings.name) {
      NavigatorUtilsCore().setCurrentRoute(route.settings.name);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    // 设置当前页路由
    if (previousRoute != null) {
      NavigatorUtilsCore().setCurrentRoute(previousRoute.settings.name);
    }
  }
}
