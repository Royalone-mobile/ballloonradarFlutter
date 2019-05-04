// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Loc _$LocFromJson(Map<String, dynamic> json) {
  return Loc(
      lat: (json['lat'] as num)?.toDouble(),
      lng: (json['lng'] as num)?.toDouble(),
      alt: json['alt'] as int,
      time: json['time'] as int);
}

Map<String, dynamic> _$LocToJson(Loc instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'alt': instance.alt,
      'time': instance.time
    };
