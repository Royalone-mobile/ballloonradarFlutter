import 'package:json_annotation/json_annotation.dart';

part 'loc.g.dart';

@JsonSerializable()
class Loc{
  double lat;
  double lng;
  int alt;
  int time;


  Loc({this.lat, this.lng, this.alt, this.time});

  factory Loc.fromJson(Map<String, dynamic> json) => _$LocFromJson(json);
  Map<String, dynamic> toJson() => _$LocToJson(this);
}