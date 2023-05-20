import 'package:json_annotation/json_annotation.dart';
import 'content.dart';

part 'climbing_route.g.dart';

@JsonSerializable()
class ClimbingRoute {
  final String name;
  final String yds;
  final Content content;

  ClimbingRoute({
    required this.name,
    required this.yds,
    required this.content,
  });

  factory ClimbingRoute.fromJson(Map<String, dynamic> json) {
    return ClimbingRoute(
      name: json['name'],
      yds: json['yds'],
      content: Content.fromJson(json['content'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'yds': yds,
      'content': content.toJson(),
    };
  }
}
