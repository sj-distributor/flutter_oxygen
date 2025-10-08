// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flutter_router.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FlutterRouterCWProxy {
  FlutterRouter name(String name);

  FlutterRouter path(String path);

  FlutterRouter builder(Widget Function(BuildContext, GoRouterState)? builder);

  FlutterRouter pageBuilder(
    Page<dynamic> Function(BuildContext, GoRouterState)? pageBuilder,
  );

  FlutterRouter title(String? title);

  FlutterRouter keywords(String? keywords);

  FlutterRouter description(String? description);

  FlutterRouter width(double width);

  FlutterRouter height(double height);

  FlutterRouter isDefault(bool isDefault);

  FlutterRouter minimize(bool minimize);

  FlutterRouter maximize(bool maximize);

  FlutterRouter resizable(bool resizable);

  FlutterRouter close(bool close);

  FlutterRouter center(bool center);

  FlutterRouter auth(bool auth);

  FlutterRouter subWindow(bool subWindow);

  FlutterRouter hideTitleBar(bool hideTitleBar);

  FlutterRouter isShell(bool isShell);

  FlutterRouter appBar(PreferredSizeWidget? appBar);

  FlutterRouter bottomNavigationBar(Widget? bottomNavigationBar);

  FlutterRouter routes(List<FlutterRouter>? routes);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `FlutterRouter(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// FlutterRouter(...).copyWith(id: 12, name: "My name")
  /// ```
  FlutterRouter call({
    String name,
    String path,
    Widget Function(BuildContext, GoRouterState)? builder,
    Page<dynamic> Function(BuildContext, GoRouterState)? pageBuilder,
    String? title,
    String? keywords,
    String? description,
    double width,
    double height,
    bool isDefault,
    bool minimize,
    bool maximize,
    bool resizable,
    bool close,
    bool center,
    bool auth,
    bool subWindow,
    bool hideTitleBar,
    bool isShell,
    PreferredSizeWidget? appBar,
    Widget? bottomNavigationBar,
    List<FlutterRouter>? routes,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfFlutterRouter.copyWith(...)` or call `instanceOfFlutterRouter.copyWith.fieldName(value)` for a single field.
class _$FlutterRouterCWProxyImpl implements _$FlutterRouterCWProxy {
  const _$FlutterRouterCWProxyImpl(this._value);

  final FlutterRouter _value;

  @override
  FlutterRouter name(String name) => call(name: name);

  @override
  FlutterRouter path(String path) => call(path: path);

  @override
  FlutterRouter builder(
    Widget Function(BuildContext, GoRouterState)? builder,
  ) => call(builder: builder);

  @override
  FlutterRouter pageBuilder(
    Page<dynamic> Function(BuildContext, GoRouterState)? pageBuilder,
  ) => call(pageBuilder: pageBuilder);

  @override
  FlutterRouter title(String? title) => call(title: title);

  @override
  FlutterRouter keywords(String? keywords) => call(keywords: keywords);

  @override
  FlutterRouter description(String? description) =>
      call(description: description);

  @override
  FlutterRouter width(double width) => call(width: width);

  @override
  FlutterRouter height(double height) => call(height: height);

  @override
  FlutterRouter isDefault(bool isDefault) => call(isDefault: isDefault);

  @override
  FlutterRouter minimize(bool minimize) => call(minimize: minimize);

  @override
  FlutterRouter maximize(bool maximize) => call(maximize: maximize);

  @override
  FlutterRouter resizable(bool resizable) => call(resizable: resizable);

  @override
  FlutterRouter close(bool close) => call(close: close);

  @override
  FlutterRouter center(bool center) => call(center: center);

  @override
  FlutterRouter auth(bool auth) => call(auth: auth);

  @override
  FlutterRouter subWindow(bool subWindow) => call(subWindow: subWindow);

  @override
  FlutterRouter hideTitleBar(bool hideTitleBar) =>
      call(hideTitleBar: hideTitleBar);

  @override
  FlutterRouter isShell(bool isShell) => call(isShell: isShell);

  @override
  FlutterRouter appBar(PreferredSizeWidget? appBar) => call(appBar: appBar);

  @override
  FlutterRouter bottomNavigationBar(Widget? bottomNavigationBar) =>
      call(bottomNavigationBar: bottomNavigationBar);

  @override
  FlutterRouter routes(List<FlutterRouter>? routes) => call(routes: routes);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `FlutterRouter(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// FlutterRouter(...).copyWith(id: 12, name: "My name")
  /// ```
  FlutterRouter call({
    Object? name = const $CopyWithPlaceholder(),
    Object? path = const $CopyWithPlaceholder(),
    Object? builder = const $CopyWithPlaceholder(),
    Object? pageBuilder = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? keywords = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? width = const $CopyWithPlaceholder(),
    Object? height = const $CopyWithPlaceholder(),
    Object? isDefault = const $CopyWithPlaceholder(),
    Object? minimize = const $CopyWithPlaceholder(),
    Object? maximize = const $CopyWithPlaceholder(),
    Object? resizable = const $CopyWithPlaceholder(),
    Object? close = const $CopyWithPlaceholder(),
    Object? center = const $CopyWithPlaceholder(),
    Object? auth = const $CopyWithPlaceholder(),
    Object? subWindow = const $CopyWithPlaceholder(),
    Object? hideTitleBar = const $CopyWithPlaceholder(),
    Object? isShell = const $CopyWithPlaceholder(),
    Object? appBar = const $CopyWithPlaceholder(),
    Object? bottomNavigationBar = const $CopyWithPlaceholder(),
    Object? routes = const $CopyWithPlaceholder(),
  }) {
    return FlutterRouter(
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      path: path == const $CopyWithPlaceholder() || path == null
          ? _value.path
          // ignore: cast_nullable_to_non_nullable
          : path as String,
      builder: builder == const $CopyWithPlaceholder()
          ? _value.builder
          // ignore: cast_nullable_to_non_nullable
          : builder as Widget Function(BuildContext, GoRouterState)?,
      pageBuilder: pageBuilder == const $CopyWithPlaceholder()
          ? _value.pageBuilder
          // ignore: cast_nullable_to_non_nullable
          : pageBuilder as Page<dynamic> Function(BuildContext, GoRouterState)?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
      keywords: keywords == const $CopyWithPlaceholder()
          ? _value.keywords
          // ignore: cast_nullable_to_non_nullable
          : keywords as String?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      width: width == const $CopyWithPlaceholder() || width == null
          ? _value.width
          // ignore: cast_nullable_to_non_nullable
          : width as double,
      height: height == const $CopyWithPlaceholder() || height == null
          ? _value.height
          // ignore: cast_nullable_to_non_nullable
          : height as double,
      isDefault: isDefault == const $CopyWithPlaceholder() || isDefault == null
          ? _value.isDefault
          // ignore: cast_nullable_to_non_nullable
          : isDefault as bool,
      minimize: minimize == const $CopyWithPlaceholder() || minimize == null
          ? _value.minimize
          // ignore: cast_nullable_to_non_nullable
          : minimize as bool,
      maximize: maximize == const $CopyWithPlaceholder() || maximize == null
          ? _value.maximize
          // ignore: cast_nullable_to_non_nullable
          : maximize as bool,
      resizable: resizable == const $CopyWithPlaceholder() || resizable == null
          ? _value.resizable
          // ignore: cast_nullable_to_non_nullable
          : resizable as bool,
      close: close == const $CopyWithPlaceholder() || close == null
          ? _value.close
          // ignore: cast_nullable_to_non_nullable
          : close as bool,
      center: center == const $CopyWithPlaceholder() || center == null
          ? _value.center
          // ignore: cast_nullable_to_non_nullable
          : center as bool,
      auth: auth == const $CopyWithPlaceholder() || auth == null
          ? _value.auth
          // ignore: cast_nullable_to_non_nullable
          : auth as bool,
      subWindow: subWindow == const $CopyWithPlaceholder() || subWindow == null
          ? _value.subWindow
          // ignore: cast_nullable_to_non_nullable
          : subWindow as bool,
      hideTitleBar:
          hideTitleBar == const $CopyWithPlaceholder() || hideTitleBar == null
          ? _value.hideTitleBar
          // ignore: cast_nullable_to_non_nullable
          : hideTitleBar as bool,
      isShell: isShell == const $CopyWithPlaceholder() || isShell == null
          ? _value.isShell
          // ignore: cast_nullable_to_non_nullable
          : isShell as bool,
      appBar: appBar == const $CopyWithPlaceholder()
          ? _value.appBar
          // ignore: cast_nullable_to_non_nullable
          : appBar as PreferredSizeWidget?,
      bottomNavigationBar: bottomNavigationBar == const $CopyWithPlaceholder()
          ? _value.bottomNavigationBar
          // ignore: cast_nullable_to_non_nullable
          : bottomNavigationBar as Widget?,
      routes: routes == const $CopyWithPlaceholder()
          ? _value.routes
          // ignore: cast_nullable_to_non_nullable
          : routes as List<FlutterRouter>?,
    );
  }
}

extension $FlutterRouterCopyWith on FlutterRouter {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfFlutterRouter.copyWith(...)` or `instanceOfFlutterRouter.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FlutterRouterCWProxy get copyWith => _$FlutterRouterCWProxyImpl(this);

  /// Returns a copy of the object with the selected fields set to `null`.
  /// A flag set to `false` leaves the field unchanged. Prefer `copyWith(field: null)` or `copyWith.fieldName(null)` for single-field updates.
  ///
  /// Example:
  /// ```dart
  /// FlutterRouter(...).copyWithNull(firstField: true, secondField: true)
  /// ```
  FlutterRouter copyWithNull({
    bool builder = false,
    bool pageBuilder = false,
    bool title = false,
    bool keywords = false,
    bool description = false,
    bool appBar = false,
    bool bottomNavigationBar = false,
    bool routes = false,
  }) {
    return FlutterRouter(
      name: name,
      path: path,
      builder: builder == true ? null : this.builder,
      pageBuilder: pageBuilder == true ? null : this.pageBuilder,
      title: title == true ? null : this.title,
      keywords: keywords == true ? null : this.keywords,
      description: description == true ? null : this.description,
      width: width,
      height: height,
      isDefault: isDefault,
      minimize: minimize,
      maximize: maximize,
      resizable: resizable,
      close: close,
      center: center,
      auth: auth,
      subWindow: subWindow,
      hideTitleBar: hideTitleBar,
      isShell: isShell,
      appBar: appBar == true ? null : this.appBar,
      bottomNavigationBar: bottomNavigationBar == true
          ? null
          : this.bottomNavigationBar,
      routes: routes == true ? null : this.routes,
    );
  }
}

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
