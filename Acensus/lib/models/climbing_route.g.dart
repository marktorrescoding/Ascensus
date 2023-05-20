// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'climbing_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClimbingRoute _$ClimbingRouteFromJson(Map<String, dynamic> json) =>
    ClimbingRoute(
      name: json['name'] as String,
      yds: json['yds'] as String,
      content: Content.fromJson(json['content'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClimbingRouteToJson(ClimbingRoute instance) =>
    <String, dynamic>{
      'name': instance.name,
      'yds': instance.yds,
      'content': instance.content,
    };
