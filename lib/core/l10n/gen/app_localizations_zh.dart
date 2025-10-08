// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get sendTimeout => '连接超时';

  @override
  String get authException => '未授权';

  @override
  String get serverException => '服务器错误';

  @override
  String get networkException => '网络错误';

  @override
  String get appException => '未知错误';

  @override
  String get loading => '加载中';

  @override
  String get retry => '重试';

  @override
  String get page => '页';

  @override
  String get model => '模型';

  @override
  String get modelName => '模型名称';

  @override
  String get type => '类型';

  @override
  String get status => '状态';

  @override
  String get action => '操作';

  @override
  String get size => '尺寸';

  @override
  String get paramsSize => '参数量';

  @override
  String get updateTime => '修改日期';

  @override
  String get homePage => '首页';

  @override
  String get modelPage => '模型管理';

  @override
  String get loginPage => '登录页';

  @override
  String get testPage => '测试页';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get sendTimeout => '连接超时';

  @override
  String get authException => '未授权';

  @override
  String get serverException => '服务器错误';

  @override
  String get networkException => '网络错误';

  @override
  String get appException => '未知错误';

  @override
  String get loading => '載入中';

  @override
  String get retry => '重試';

  @override
  String get page => '頁';

  @override
  String get model => '模型';

  @override
  String get modelName => '模型名稱';

  @override
  String get type => '類型';

  @override
  String get status => '狀態';

  @override
  String get action => '操作';

  @override
  String get size => '尺寸';

  @override
  String get paramsSize => '參數量';

  @override
  String get updateTime => '修改日期';

  @override
  String get homePage => '首頁';

  @override
  String get modelPage => '模型管理';

  @override
  String get loginPage => '登录页';

  @override
  String get testPage => '测试页';
}
