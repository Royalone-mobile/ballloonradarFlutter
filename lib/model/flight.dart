import 'package:json_annotation/json_annotation.dart';

part 'flight.g.dart';

@JsonSerializable()
class Flight {
  String useruid;
  String balloonuid;
  int startedTime;
  int endedTime;
  int halfGas;
  String sign;
  String displayName;
  String photoURL;
  bool hidden;

  Flight(this.startedTime, this.endedTime, this.hidden, {this.useruid, this.balloonuid, this.halfGas, this.sign, this.displayName, this.photoURL});

  factory Flight.fromJson(Map<String, dynamic> json) => _$FlightFromJson(json);

  Map<String, dynamic> toJson() => _$FlightToJson(this);
}
