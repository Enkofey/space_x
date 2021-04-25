
import 'package:json_annotation/json_annotation.dart';

part 'patch.g.dart';

@JsonSerializable(checked: true, explicitToJson: true, fieldRename: FieldRename.snake)
class Patch{

  String large;

  Patch();

  factory Patch.fromJson(Map<String, dynamic>json) => _$PatchFromJson(json);

  Map<String, dynamic> toJson() => _$PatchToJson(this);

}