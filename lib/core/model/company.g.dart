// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) {
  return $checkedNew('Company', json, () {
    final val = Company();
    $checkedConvert(json, 'founded', (v) => val.founded = v as int);
    $checkedConvert(json, 'name', (v) => val.name = v as String);
    $checkedConvert(json, 'founder', (v) => val.founder = v as String);
    $checkedConvert(json, 'employees', (v) => val.employees = v as int);
    $checkedConvert(json, 'summary', (v) => val.summary = v as String);
    return val;
  });
}

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'founded': instance.founded,
      'name': instance.name,
      'founder': instance.founder,
      'employees': instance.employees,
      'summary': instance.summary,
    };
