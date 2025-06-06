/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2025-02-12 20:02:11
 */

import 'package:json_annotation/json_annotation.dart';

part 'client_item.g.dart';

@JsonSerializable(explicitToJson: true)
class ClientItem {
  const ClientItem({
    required this.clientName,
    required this.projectName,
    required this.appName,
    required this.apiUrl,
    required this.version,
    required this.stripeKey,
    // required this.namespace,
    required this.password,
    required this.merchantId,
    this.defaultLanguage = 'zh',
    this.primaryColor = '#1677FF',
    this.env = 'dev',
  });

  /// 客户名称
  final String clientName;

  /// 项目名称 \
  /// 英文小写蛇形命名 \
  /// 签名证书的文件使用该命名
  final String projectName;

  /// 应用名称 \
  /// 可以是中文、英文（大小写）
  final String appName;

  /// 接口地址 \
  /// 可变地址：可通过 CI 变量传入
  final String apiUrl;

  /// 版本
  final String version;

  /// 命名空间
  // final String namespace;

  /// 密钥密码 \
  /// 用于App证书签名的密码，全部使用该密码
  final String password;

  /// 商户id
  final String merchantId;

  /// 默认语言
  final String defaultLanguage;

  /// 主题色
  final String primaryColor;

  /// 环境
  final String env;

  /// stripe key
  final String stripeKey;

  factory ClientItem.fromJson(Map<String, dynamic> json) =>
      _$ClientItemFromJson(json);

  Map<String, dynamic> toJson() => _$ClientItemToJson(this);
}
