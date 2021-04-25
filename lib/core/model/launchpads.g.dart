// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launchpads.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Launchpads _$LaunchpadsFromJson(Map<String, dynamic> json) {
  return $checkedNew('Launchpads', json, () {
    final val = Launchpads();
    $checkedConvert(
        json, 'latitude', (v) => val.latitude = (v as num)?.toDouble());
    $checkedConvert(
        json, 'longitude', (v) => val.longitude = (v as num)?.toDouble());
    $checkedConvert(json, 'id', (v) => val.id = v as String);
    return val;
  });
}

Map<String, dynamic> _$LaunchpadsToJson(Launchpads instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'id': instance.id,
    };
