// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Flight _$FlightFromJson(Map<String, dynamic> json) {
  return Flight(json['startedTime'] as int, json['endedTime'] as int,
      json['hidden'] as bool,
      useruid: json['useruid'] as String,
      balloonuid: json['balloonuid'] as String,
      halfGas: json['halfGas'] as int,
      sign: json['sign'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String);
}

Map<String, dynamic> _$FlightToJson(Flight instance) => <String, dynamic>{
      'useruid': instance.useruid,
      'balloonuid': instance.balloonuid,
      'startedTime': instance.startedTime,
      'endedTime': instance.endedTime,
      'halfGas': instance.halfGas,
      'sign': instance.sign,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
      'hidden': instance.hidden
    };
