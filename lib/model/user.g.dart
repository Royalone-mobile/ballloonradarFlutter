// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      country: json['country'] as String,
      kindOfPilot:
          _$enumDecodeNullable(_$KindOfPilotEnumMap, json['kindOfPilot']),
      speedUnit: _$enumDecodeNullable(_$SpeedUnitEnumMap, json['speedUnit']),
      heightUnit: _$enumDecodeNullable(_$HeightUnitEnumMap, json['heightUnit']),
      distanceUnit:
          _$enumDecodeNullable(_$DistanceUnitEnumMap, json['distanceUnit']),
      flightPerMonth: _$enumDecodeNullable(
          _$FlightsPerMonthEnumMap, json['flightPerMonth']),
      utcTime: json['utcTime'] as int,
      hidden: json['hidden'] as bool);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'displayName': instance.displayName,
      'email': instance.email,
      'country': instance.country,
      'kindOfPilot': _$KindOfPilotEnumMap[instance.kindOfPilot],
      'speedUnit': _$SpeedUnitEnumMap[instance.speedUnit],
      'heightUnit': _$HeightUnitEnumMap[instance.heightUnit],
      'distanceUnit': _$DistanceUnitEnumMap[instance.distanceUnit],
      'flightPerMonth': _$FlightsPerMonthEnumMap[instance.flightPerMonth],
      'utcTime': instance.utcTime,
      'hidden': instance.hidden
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$KindOfPilotEnumMap = <KindOfPilot, dynamic>{
  KindOfPilot.private: 'private',
  KindOfPilot.sport: 'sport',
  KindOfPilot.commercial: 'commercial'
};

const _$SpeedUnitEnumMap = <SpeedUnit, dynamic>{
  SpeedUnit.ms: 'ms',
  SpeedUnit.kmh: 'kmh',
  SpeedUnit.knots: 'knots',
  SpeedUnit.milesh: 'milesh'
};

const _$HeightUnitEnumMap = <HeightUnit, dynamic>{
  HeightUnit.meters: 'meters',
  HeightUnit.feet: 'feet'
};

const _$DistanceUnitEnumMap = <DistanceUnit, dynamic>{
  DistanceUnit.meters: 'meters',
  DistanceUnit.miles: 'miles'
};

const _$FlightsPerMonthEnumMap = <FlightsPerMonth, dynamic>{
  FlightsPerMonth.lessThan5: 'lessThan5',
  FlightsPerMonth.between5and10: 'between5and10',
  FlightsPerMonth.moreThan10: 'moreThan10'
};
