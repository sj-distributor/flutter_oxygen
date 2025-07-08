/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-07-31 18:52:22
 */

import 'dart:async';

import 'package:flutter/material.dart' hide Route;
import 'package:go_router/go_router.dart';

import 'route.dart';

abstract class IRouterAbstract {
  late List<FlutterRouter> routes;
  late List<NavigatorObserver>? observers = [];
  late FutureOr<String?> Function(BuildContext, GoRouterState)? redirect;
  GlobalKey<NavigatorState>? navigatorKey;

  /// 根据自定义路由FlutterRouter
  /// 组装成GoRoute
  GoRouter generateRoutes();
}
