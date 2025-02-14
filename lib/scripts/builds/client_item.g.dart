// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientItem _$ClientItemFromJson(Map<String, dynamic> json) => ClientItem(
      clientName: json['clientName'] as String,
      projectName: json['projectName'] as String,
      appName: json['appName'] as String,
      apiUrl: json['apiUrl'] as String,
      version: json['version'] as String,
      password: json['password'] as String,
      defaultLanguage: json['defaultLanguage'] as String? ?? 'zh',
      primaryColor: json['primaryColor'] as String? ?? '#1677FF',
      env: json['env'] as String? ?? 'dev',
    );

Map<String, dynamic> _$ClientItemToJson(ClientItem instance) =>
    <String, dynamic>{
      'clientName': instance.clientName,
      'projectName': instance.projectName,
      'appName': instance.appName,
      'apiUrl': instance.apiUrl,
      'version': instance.version,
      'password': instance.password,
      'defaultLanguage': instance.defaultLanguage,
      'primaryColor': instance.primaryColor,
      'env': instance.env,
    };
