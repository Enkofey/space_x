import 'package:json_annotation/json_annotation.dart';
import 'package:spacex_project/core/model/links.dart';

part 'launchpads.g.dart';

@JsonSerializable(
    checked: true, explicitToJson: true, fieldRename: FieldRename.snake)
class Launchpads{
  double latitude;
  double longitude;
  String id;

  Launchpads();

  factory Launchpads.fromJson(Map<String, dynamic>json) => _$LaunchpadsFromJson(json);

  Map<String, dynamic> toJson() => _$LaunchpadsToJson(this);

}