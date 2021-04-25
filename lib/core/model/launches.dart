import 'package:json_annotation/json_annotation.dart';
import 'package:spacex_project/core/model/links.dart';

part 'launches.g.dart';

@JsonSerializable(
    checked: true, explicitToJson: true, fieldRename: FieldRename.snake)
class Launches{
  int flight_number;
  String name;
  String date_local;
  Links links;
  String id;
  bool success;
  String details;
  String launchpad;

  Launches();

  factory Launches.fromJson(Map<String, dynamic>json) => _$LaunchesFromJson(json);

  Map<String, dynamic> toJson() => _$LaunchesToJson(this);

}