/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-08-01 09:20:21
 */

import 'package:json_annotation/json_annotation.dart';

export 'flutter_router.dart';
export 'router_abstract.dart';
export 'router_enum.dart';
export 'router_strategy.dart';

part 'route.g.dart';

@JsonSerializable(explicitToJson: true)
class Route {
  const Route({required this.name, required this.path});

  /// 路由名称
  final String name;

  /// 路由路径
  final String path;

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);

  Map<String, dynamic> toJson() => _$RouteToJson(this);
}
