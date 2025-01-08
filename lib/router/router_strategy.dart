/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-07-31 18:42:54
 */

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

    return _instance;
  }

  /// 获取路由
  static List<FlutterRouter> getRoutes() {
    if (!_instance.routeMap.containsKey(_instance.deviceType)) {
      return _instance.routeMap[DeviceTypeEnum.getDefault()]!;
    }

    return _instance.routeMap[_instance.deviceType]!;
  }
}
