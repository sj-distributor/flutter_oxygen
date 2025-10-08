// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
  name: json['name'] as String,
  path: json['path'] as String,
  projectName: json['projectName'] as String?,
);

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
  'name': instance.name,
  'path': instance.path,
  'projectName': instance.projectName,
};
