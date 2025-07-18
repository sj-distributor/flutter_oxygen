// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flutter_router.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlutterRouter _$FlutterRouterFromJson(Map<String, dynamic> json) =>
    FlutterRouter(
      name: json['name'] as String,
      path: json['path'] as String,
      title: json['title'] as String?,
      keywords: json['keywords'] as String?,
      description: json['description'] as String?,
      width: (json['width'] as num?)?.toDouble() ?? 960,
      height: (json['height'] as num?)?.toDouble() ?? 640,
      isDefault: json['isDefault'] as bool? ?? false,
      minimize: json['minimize'] as bool? ?? true,
      maximize: json['maximize'] as bool? ?? true,
      resizable: json['resizable'] as bool? ?? true,
      close: json['close'] as bool? ?? true,
      center: json['center'] as bool? ?? false,
      auth: json['auth'] as bool? ?? false,
      subWindow: json['subWindow'] as bool? ?? false,
      hideTitleBar: json['hideTitleBar'] as bool? ?? false,
      isShell: json['isShell'] as bool? ?? false,
      routes: (json['routes'] as List<dynamic>?)
          ?.map((e) => FlutterRouter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FlutterRouterToJson(FlutterRouter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'path': instance.path,
      'title': instance.title,
      'keywords': instance.keywords,
      'description': instance.description,
      'width': instance.width,
      'height': instance.height,
      'isDefault': instance.isDefault,
      'minimize': instance.minimize,
      'maximize': instance.maximize,
      'resizable': instance.resizable,
      'close': instance.close,
      'center': instance.center,
      'auth': instance.auth,
      'subWindow': instance.subWindow,
      'hideTitleBar': instance.hideTitleBar,
      'isShell': instance.isShell,
      'routes': instance.routes?.map((e) => e.toJson()).toList(),
    };
