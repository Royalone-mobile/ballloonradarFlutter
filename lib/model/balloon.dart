import 'package:json_annotation/json_annotation.dart';

part 'balloon.g.dart';

@JsonSerializable()
class Balloon {
  String uid;
  String sign;
  String photoURL;
  bool approved;


  Balloon({this.uid, this.sign, this.photoURL, this.approved});

  factory Balloon.fromJson(Map<String, dynamic> json) => _$BalloonFromJson(json);
  Map<String, dynamic> toJson() => _$BalloonToJson(this);
}