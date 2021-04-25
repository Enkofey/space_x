import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

@JsonSerializable(
    checked: true, explicitToJson: true, fieldRename: FieldRename.snake)
class Company{

  int founded;
  String name;
  String founder;
  int employees;
  String summary;

  Company();

  factory Company.fromJson(Map<String, dynamic>json) => _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);

}