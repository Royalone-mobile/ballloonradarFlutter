// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balloon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Balloon _$BalloonFromJson(Map<String, dynamic> json) {
  return Balloon(
      uid: json['uid'] as String,
      sign: json['sign'] as String,
      photoURL: json['photoURL'] as String,
      approved: json['approved'] as bool);
}

Map<String, dynamic> _$BalloonToJson(Balloon instance) => <String, dynamic>{
      'uid': instance.uid,
      'sign': instance.sign,
      'photoURL': instance.photoURL,
      'approved': instance.approved
    };
