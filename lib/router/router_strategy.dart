/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-07-31 18:42:54
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'flutter_router.dart';
import 'router_enum.dart';
import 'router_abstract.dart';

/// 路由策略
/// phone端、iPad端、pc端
/// 暂时废弃

class RouteStrategy extends IRouterAbstract {
  // 私有构造函数
  RouteStrategy._internal();
  static final RouteStrategy _instance = RouteStrategy._internal();
  static RouteStrategy get instance => _instance;

  // 工厂构造函数，防止误调用
  factory RouteStrategy() => _instance;

  /// 装载路由行为策略
  Map<DeviceTypeEnum, List<FlutterRouter>> routeMap = {};

  late DeviceTypeEnum deviceType;

  FlutterRouter? initRoute;

  /// 初始化
  static RouteStrategy init({
    required DeviceTypeEnum deviceType,
    Map<DeviceTypeEnum, List<FlutterRouter>>? routeMap,
  }) {
    if (routeMap != null) {
      _instance.routeMap = routeMap;
    }
    _instance.deviceType = deviceType;
    _instance.routes = getRoutes();
    _instance.allRoutes = extractRoutes(_instance.routes);

    return _instance;
  }

  /// 根据自定义路由FlutterRouter
  /// 组装成GoRoute
  @override
  GoRouter generateRoutes() {
    initRoute = initRoute ??
        routes.where((route) => route.isDefault).firstOrNull ??
        routes.firstOrNull;

    final router = GoRouter(
      initialLocation: initRoute?.path,
      routes: buildRoutes(routes),
      navigatorKey: navigatorKey,
      observers: observers,
      redirect: redirect,
    );

    return router;
  }

  List<RouteBase> buildRoutes(List<FlutterRouter> routers) {
    return routers.map((router) {
      if (router.isShell) {
        return ShellRoute(
          builder: (context, state, child) {
            return Scaffold(
              appBar: router.appBar,
              body: child,
              bottomNavigationBar: router.bottomNavigationBar,
            );
          },
          routes: buildRoutes(router.routes ?? []),
        );
      } else {
        return GoRoute(
          name: router.name,
          path: router.path,
          builder: router.builder,
        );
      }
    }).toList();
  }

  /// 获取路由
  static List<FlutterRouter> getRoutes() {
    if (!_instance.routeMap.containsKey(_instance.deviceType)) {
      return _instance.routeMap[DeviceTypeEnum.getDefault()]!;
    }

    return _instance.routeMap[_instance.deviceType]!;
  }

  /// 获取全部路由
  static List<FlutterRouter> extractRoutes(List<FlutterRouter> routers) {
    final List<FlutterRouter> result = [];

    void traverse(List<FlutterRouter> items) {
      for (final route in items) {
        result.add(route);
        if (route.routes != null && route.routes!.isNotEmpty) {
          traverse(route.routes!);
        }
      }
    }

    traverse(routers);
    return result;
  }

  static List<String> extractAuthPaths(List<FlutterRouter> routers) {
    final List<String> result = [];

    void traverse(List<FlutterRouter> items) {
      for (final route in items) {
        if (route.auth) {
          result.add(route.path);
        }
        if (route.routes != null && route.routes!.isNotEmpty) {
          traverse(route.routes!);
        }
      }
    }

    traverse(routers);
    return result;
  }
}
