/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-05-22 20:24:17
 */
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_oxygen/flutter_oxygen.dart';
import 'package:go_router/go_router.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:window_manager/window_manager.dart';

import 'web/web_interface.dart';

/// 【NavigatorUtilsCore1工具类，用于路由跳转】\
/// init：初始化方法，传递路由映射\
/// push：将新页面添加到导航堆栈顶部\
/// getCurrentRoute：获取当前路由\
/// refreshCurrentRoute：刷新当前路由\
/// mapValueToString：map value转成字符串

class NavigatorUtilsCore {
  // 私有构造函数
  NavigatorUtilsCore._internal();

  static final NavigatorUtilsCore _instance = NavigatorUtilsCore._internal();
  static NavigatorUtilsCore get instance => _instance;

  // 工厂构造函数，防止误调用
  factory NavigatorUtilsCore() => _instance;

  static final navigatorKey = RouteStrategy().navigatorKey;

  static BuildContext? get navigatorContext => navigatorKey?.currentContext;

  /// 当前路由
  FlutterRouter? currentRoute;

  /// 路由列表
  List<FlutterRouter> routes = [];

  /// 是否桌面系统
  late bool isDesktop;

  /// app名称
  late String appName;

  /// 初始化方法，传递路由映射
  static Widget Function(BuildContext, Widget?) init({
    required List<FlutterRouter> routers,
    required DeviceTypeEnum deviceType,
    required isDesktop,
    required appName,
    Widget Function(BuildContext, Widget?)? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder == null || child == null) {
        return const SizedBox.shrink();
      }

      // for (var router in routers) {
      //   router.init(childContext: context);
      // }

      // 这里记得再初始化一次，否则在项目的路由里，第一次进来拿不到context
      // final routeStrategy = CustomRouter.init(deviceType);
      _instance.routes = routers;
      _instance.isDesktop = isDesktop;
      _instance.appName = appName;

      _instance.refreshCurrentRoute();

      return builder(context, child);
    };
  }

  /// 将新页面添加到导航堆栈顶部 \
  /// 可以后退，没有dispose生命周期 \
  /// pathParameters：路由参数 \
  /// queryParameters：路由参数 \
  /// extra：路由参数
  static void go(
    Route route, {
    Map<String, dynamic> pathParameters = const <String, dynamic>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    final navigatorState = Navigator.of(navigatorContext!);
    final routeName = route.name;

    // 检查当前栈中是否已有此路由名称的页面
    bool hasRouteInStack =
        navigatorState.canPop() &&
        (navigatorState as dynamic).widget.pages?.any((page) {
          if (page is MaterialPage) {
            return page.name == routeName;
          }
          return false;
        });

    if (!hasRouteInStack) {
      navigatorContext?.pushNamed(
        routeName,
        pathParameters: mapValueToString(pathParameters),
        queryParameters: mapValueToString(queryParameters),
        extra: extra,
      );
    } else {
      // 如果已有该页面，则将其作为当前页面（可选）
      Navigator.of(navigatorContext!).popUntil(ModalRoute.withName(routeName));
    }
  }

  /// 直接跳转到指定的命名路由，并替换当前页面
  /// 不能后退，拥有dispose生命周期 \
  /// pathParameters：路由参数 \
  /// queryParameters：路由参数 \
  /// extra：路由参数
  /// 例如：登录页 -> 登录成功后，跳转到首页
  static void replace(
    Route route, {
    Map<String, dynamic> pathParameters = const <String, dynamic>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    if (navigatorContext == null) {
      return;
    }

    final routerDelegate = GoRouter.of(navigatorContext!).routerDelegate;

    final matches = routerDelegate.currentConfiguration.matches;

    final targetIndex = matches.indexWhere((match) {
      final item = match.route;

      return item is GoRoute ? item.name == route.name : false;
    });

    if (targetIndex != -1) {
      // popUntil 到目标路由
      Navigator.of(navigatorContext!).popUntil((item) {
        final settings = item.settings;
        if (settings.name == null) return true;
        return settings.name == route.name;
      });

      navigatorContext?.replaceNamed(
        route.name,
        pathParameters: mapValueToString(pathParameters),
        queryParameters: mapValueToString(queryParameters),
        extra: extra,
      );

      return;
    }

    navigatorContext?.pushReplacementNamed(
      route.name,
      pathParameters: mapValueToString(pathParameters),
      queryParameters: mapValueToString(queryParameters),
      extra: extra,
    );
  }

  /// 切换路由并在桌面端设置窗口的属性和显示状态
  void navigateAndSetupWindow(String? routeName) async {
    if (routeName == null || !_instance.isDesktop) return;

    // 根据routeName找出匹配的路由
    final route = _instance.routes
        .where((route) => route.name == routeName)
        .firstOrNull;

    if (route == null) {
      return;
    }

    WindowOptions windowOptions = WindowOptions(
      size: Size(route.width, route.height),
      center: route.center,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: route.hideTitleBar && !DeviceUtilsCore.isLinux
          ? TitleBarStyle.hidden
          : TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setResizable(route.resizable);
      await windowManager.setMinimizable(route.minimize);
      await windowManager.setMaximizable(route.maximize);
      await windowManager.show();
      await windowManager.focus();
    });
  }

  /// 获取当前路由
  FlutterRouter? getCurrentRoute(String? name) {
    navigateAndSetupWindow(name);
    final item = _instance.routes
        .where((item) => item.name == name)
        .firstOrNull;

    /// 设置当前路由的MetaSEO
    setMetaSEO(item);
    return item;
  }

  /// 设置当前页路由
  void setCurrentRoute(String? name) {
    final route = getCurrentRoute(name);

    if (route != _instance.currentRoute) {
      _instance.currentRoute = route;
      RouteStrategy().initRoute = route;
    }
  }

  /// 刷新当前路由
  void refreshCurrentRoute() {
    final currentRoute = _instance.currentRoute;
    if (currentRoute is FlutterRouter) {
      _instance.currentRoute = _instance.getCurrentRoute(currentRoute.name);
    }
  }

  /// 设置当前路由的MetaSEO
  void setMetaSEO(FlutterRouter? item) {
    if (DeviceUtilsCore.isWeb) {
      final meta = MetaSEO();

      if (item?.title != null) {
        final title = '${item!.title} - ${_instance.appName}';

        WebWrapper.setTitle(title);
        meta.ogTitle(ogTitle: title);
        meta.twitterTitle(twitterTitle: title);
      }
      if (item?.keywords != null) meta.keywords(keywords: item!.keywords!);
      if (item?.description != null) {
        meta.description(description: item!.description!);
        meta.ogDescription(ogDescription: item.description!);
        meta.twitterDescription(twitterDescription: item.description!);
      }
    }
  }

  /// map value转成字符串
  static Map<String, String> mapValueToString(Map<String, dynamic> inputMap) {
    return inputMap.map((key, value) => MapEntry(key, value.toString()));
  }
}
