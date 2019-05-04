import 'package:json_annotation/json_annotation.dart';
import '../utils.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String displayName;
  String email;
  String country;
  KindOfPilot kindOfPilot;
  SpeedUnit speedUnit;
  HeightUnit heightUnit;
  DistanceUnit distanceUnit;
  FlightsPerMonth flightPerMonth;
  int utcTime;
  bool hidden;


  User({this.displayName, this.email, this.country, this.kindOfPilot,
      this.speedUnit, this.heightUnit, this.distanceUnit, this.flightPerMonth,
      this.utcTime, this.hidden});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
