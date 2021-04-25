// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launches.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Launches _$LaunchesFromJson(Map<String, dynamic> json) {
  return $checkedNew('Launches', json, () {
    final val = Launches();
    $checkedConvert(json, 'flight_number', (v) => val.flight_number = v as int);
    $checkedConvert(json, 'name', (v) => val.name = v as String);
    $checkedConvert(json, 'date_local', (v) => val.date_local = v as String);
    $checkedConvert(
        json,
        'links',
        (v) => val.links =
            v == null ? null : Links.fromJson(v as Map<String, dynamic>));
    $checkedConvert(json, 'id', (v) => val.id = v as String);
    $checkedConvert(json, 'success', (v) => val.success = v as bool);
    $checkedConvert(json, 'details', (v) => val.details = v as String);
    $checkedConvert(json, 'launchpad', (v) => val.launchpad = v as String);
    return val;
  });
}

Map<String, dynamic> _$LaunchesToJson(Launches instance) => <String, dynamic>{
      'flight_number': instance.flight_number,
      'name': instance.name,
      'date_local': instance.date_local,
      'links': instance.links?.toJson(),
      'id': instance.id,
      'success': instance.success,
      'details': instance.details,
      'launchpad': instance.launchpad,
    };
