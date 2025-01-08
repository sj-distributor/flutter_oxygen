<!--
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-04-15 09:59:05
-->
# 路由模块
  - 使用例子
  ```
    /// 自定义路由
    class CustomRouter {
      // 支持的路由
      static const mobile = DeviceTypeEnum.mobile;
      static const iPad = DeviceTypeEnum.iPad;
      static const desktop = DeviceTypeEnum.desktop;

      static RouteStrategy init(DeviceTypeEnum deviceType) {
        /// 路由行为Map
        final routeMap = {
          mobile: MobileRoutes.instance.getRoutes(),
          iPad: MobileRoutes.instance.getRoutes(),
          desktop: DesktopRoutes.instance.getRoutes(),
        };

        // 初始化
        final routeStrategy = RouteStrategy.init(
          routeMap: routeMap,
          deviceType: deviceType,
        );

        // 注入中间件
        routeStrategy.observers = [
          RouteMiddleware(),
        ];

        return routeStrategy;
      }
    }
  ```