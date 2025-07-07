/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-07-29 20:44:32
 */
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flutter_router.g.dart';

@JsonSerializable(explicitToJson: true)
class FlutterRouter {
  /// 路由名称
  final String name;

  /// 路由路径
  final String path;

  /// 页面
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Widget Function(BuildContext, GoRouterState state)? builder;

  /// 页面标题
  final String? title;

  /// 页面关键字
  final String? keywords;

  /// 页面描述
  final String? description;

  /// 窗口宽度
  final double width;

  /// 窗口高度
  final double height;

  /// 是否默认路由
  final bool isDefault;

  /// 是否允许最小化
  final bool minimize;

  /// 是否允许最大化
  final bool maximize;

  /// 是否允许全屏
  final bool resizable;

  /// 是否允许关闭
  final bool close;

  /// 是否居中
  final bool center;

  /// 是否需要登录授权
  final bool auth;

  /// 是否子窗口打开
  final bool subWindow;

  /// 更改本机窗口的标题栏样式
  final bool hideTitleBar;

  /// 是否是Shell
  final bool isShell;

  /// 自定义路由
  final List<FlutterRouter>? routes;

  /// appBar
  @JsonKey(includeFromJson: false, includeToJson: false)
  final PreferredSizeWidget? appBar;

  /// 底部导航栏
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Widget? bottomNavigationBar;

  /// 自定义路由\
  /// name：路由名称\
  /// path：路由路径\
  /// builder：页面\
  /// title：页面标题\
  /// keywords：页面关键字\
  /// description：页面描述\
  /// width：窗口宽度 640\
  /// height：窗口高度 640\
  /// isDefault：是否默认路由 false\
  /// minimize：是否允许最小化 true\
  /// maximize：是否允许最大化 true\
  /// resizable：是否允许全屏 true\
  /// close：是否允许关闭 true\
  /// center：是否居中 false\
  /// auth：是否需要登录授权 false\
  /// subWindow：是否子窗口打开 false\
  /// hideTitleBar：隐藏标题栏
  FlutterRouter({
    required this.name,
    required this.path,
    this.builder,
    this.title,
    this.keywords,
    this.description,
    this.width = 960,
    this.height = 640,
    this.isDefault = false,
    this.minimize = true,
    this.maximize = true,
    this.resizable = true,
    this.close = true,
    this.center = false,
    this.auth = false,
    this.subWindow = false,
    this.hideTitleBar = false,
    this.isShell = false,
    this.appBar,
    this.bottomNavigationBar,
    this.routes,
  });

  factory FlutterRouter.fromJson(Map<String, dynamic> json) =>
      _$FlutterRouterFromJson(json);

  Map<String, dynamic> toJson() => _$FlutterRouterToJson(this);
}
