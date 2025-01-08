/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-08-01 09:20:21
 */

export 'flutter_router.dart';
export 'router_abstract.dart';
export 'router_enum.dart';
export 'router_strategy.dart';

class Route {
  const Route({
    required this.name,
    required this.path,
  });

  final String name;
  final String path;
}
