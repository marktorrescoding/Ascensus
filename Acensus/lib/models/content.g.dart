// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
      description: json['description'] as String,
      location: json['location'] as String,
      protection: json['protection'] as String,
    );

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'description': instance.description,
      'location': instance.location,
      'protection': instance.protection,
    };
