import 'package:json_annotation/json_annotation.dart';
import 'package:spacex_project/core/model/patch.dart';

part 'links.g.dart';

@JsonSerializable(checked: true, explicitToJson: true, fieldRename: FieldRename.snake)
class Links{

  Patch patch;

  Links();

  factory Links.fromJson(Map<String, dynamic>json) => _$LinksFromJson(json);

  Map<String, dynamic> toJson() => _$LinksToJson(this);

}