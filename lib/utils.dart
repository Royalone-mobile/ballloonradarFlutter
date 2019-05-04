import 'package:balloonradar_flutter/model/loc.dart';
import 'package:balloonradar_flutter/model/user.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'dart:math' as math;

Widget loadingScreen() {
  return Center(
    child: FlutterLogo(
      size: 200.0,
    ),
  );
}

enum SpeedUnit { ms, kmh, knots, milesh }

enum HeightUnit { meters, feet }

enum DistanceUnit { meters, miles }

enum FlightsPerMonth { lessThan5, between5and10, moreThan10 }

enum KindOfPilot { private, sport, commercial }

int msToKmh(double ms) => (ms * 3.6).toInt();

int msToKnots(double ms) => (ms * 1.943844).toInt();

int msToMilesh(double ms) => (ms * 2.236936).toInt();

int metersToMiles(double meters) => (meters * 0.000621371192).toInt();

int metersToFeets(int meters) => (meters * 3.2808399).toInt();

LatLng latlngFromDestinationBearing(LatLng ll, double bearing, double d) {
  bearing = bearing * (PI / 180.0);
  double R = 6371000.0;
  double lat2 = math.asin(math.sin(ll.latitudeInRad) * math.cos(d / R) + math.cos(ll.latitudeInRad) * math.sin(d / R) * math.cos(bearing));
  double lng2 = ll.longitudeInRad + math.atan2(math.sin(bearing) * math.sin(d / R) * math.cos(ll.latitudeInRad), math.cos(d / R) - math.sin(ll.latitudeInRad) * math.sin(lat2));
  lng2 = (lng2 + 3 * PI) % (2 * PI) - PI;
  return LatLng(lat2 / PI * 180.0, lng2 / PI * 180.0);
}

String getSpeed(User usr, List<Loc> locs) {
  double ms;
  if (usr == null || locs.length < 2) {
    ms = 0.0;
  } else {
    int maxSmoothness = 10;
    Distance distance = Distance();
    LatLng p2 = LatLng(locs.last.lat, locs.last.lng);
    DateTime p2Time = DateTime.fromMillisecondsSinceEpoch(locs.last.time * 1000);
    LatLng p1;
    DateTime p1Time;
    if (locs.length < maxSmoothness) {
      p1 = LatLng(locs.first.lat, locs.first.lng);
      p1Time = DateTime.fromMillisecondsSinceEpoch(locs.first.time * 1000);
    } else {
      p1 = LatLng(locs[locs.length - maxSmoothness].lat, locs[locs.length - maxSmoothness].lng);
      p1Time = DateTime.fromMillisecondsSinceEpoch(locs[locs.length - maxSmoothness].time * 1000);
    }
    ms = distance.distance(p1, p2) / (p2Time.millisecondsSinceEpoch - p1Time.millisecondsSinceEpoch) * 1000;
  }

  switch (usr.speedUnit) {
    case SpeedUnit.ms:
      return "${ms.toInt()}m/s";
      break;
    case SpeedUnit.kmh:
      return "${msToKmh(ms)}km/h";
      break;
    case SpeedUnit.knots:
      return "${msToKnots(ms)}knots";
      break;
    case SpeedUnit.milesh:
      return "${msToMilesh(ms)}mi/h";
      break;
    default:
      return "${ms.toInt()}m/s";
  }
}

String getAltitude(User usr, List<Loc> locs) {
  int altitude;
  if (usr == null || locs.isEmpty) {
    altitude = 0;
  } else {
    altitude = locs.last.alt ?? 0;
  }
  switch (usr.heightUnit) {
    case HeightUnit.meters:
      return "${altitude}m";
      break;
    case HeightUnit.feet:
      return "${metersToFeets(altitude)}ft";
      break;
    default:
      return "${altitude}m";
  }
}

String getMaxAltitude(User usr, List<Loc> locs) {
  int altitude;
  if (usr == null || locs == null || locs.isEmpty) {
    altitude = 0;
  } else {
    int maxAltitude = 0;
    locs.forEach((loc) {
      if (loc.alt != null && loc.alt > maxAltitude) {
        maxAltitude = 0;
      }
    });
    altitude = maxAltitude;
  }
  switch (usr.heightUnit) {
    case HeightUnit.meters:
      return "${altitude}m";
      break;
    case HeightUnit.feet:
      return "${metersToFeets(altitude)}ft";
      break;
    default:
      return "${altitude}m";
  }
}

String getDistance(User usr, List<Loc> locs) {
  double distance;
  if (usr == null || locs == null || locs.length < 2) {
    distance = 0.0;
  } else {
    Distance dcs = Distance();
    distance = dcs.as(LengthUnit.Meter, LatLng(locs.first.lat, locs.first.lng), LatLng(locs.last.lat, locs.last.lng));
  }
  switch (usr.distanceUnit) {
    case DistanceUnit.meters:
      return "${distance.toInt()}m";
    case DistanceUnit.miles:
      return "${metersToMiles(distance)}mi";
    default:
      return "${metersToMiles(distance)}mi";
  }
}

String getDirection(List<Loc> locs) {
  int maxSmoothness = 10;
  if (locs.length < 2) {
    return "0°";
  } else {
    Distance distance = Distance();
    LatLng p2 = LatLng(locs.last.lat, locs.last.lng);
    LatLng p1;
    if (locs.length < maxSmoothness) {
      p1 = LatLng(locs.first.lat, locs.first.lng);
    } else {
      p1 = LatLng(locs[locs.length - maxSmoothness].lat, locs[locs.length - maxSmoothness].lng);
    }
    return "${(distance.bearing(p1, p2).toInt() + 360) % 360}°";
  }
}

String getTime(List<Loc> locs) {
  if (locs.length < 2) {
    return "00:00";
  } else {
    Duration duration = Duration(seconds: locs.last.time - locs.first.time);
    return durationToHMS(duration);
  }
}

/*
getMarkers(List<DocumentSnapshot> documents) {
  List<Marker> markers = [];
  if (documents.length > 0) {
    Loc firstLoc = Loc.fromJson(documents.first.data);
    Loc lastLoc = Loc.fromJson(documents.last.data);
    markers.add(Marker(
        point: LatLng(firstLoc.lat, firstLoc.lng),
        builder: (context) => Icon(
              Icons.album,
              size: 30.0,
              color: Colors.green,
            )));
    markers.add(Marker(
        point: LatLng(lastLoc.lat, lastLoc.lng),
        builder: (context) => Icon(
              Icons.album,
              size: 30.0,
              color: Colors.red,
            )));
  }
  return markers;
}
*/

int getMaxInt() {
  return 9223372036854775807;
}

bool isEnded(int time) {
  return time < 9000000000000000000;
}

String durationToHMS(Duration duration) {
  String hours = duration.inHours < 10 ? "0${duration.inHours}" : "${duration.inHours}";
  String minutes = duration.inMinutes % 60 < 10 ? "0${duration.inMinutes % 60}" : "${duration.inMinutes % 60}";
  String seconds = duration.inSeconds % 60 < 10 ? "0${duration.inSeconds % 60}" : "${duration.inSeconds % 60}";
  if (duration.inHours != 0) {
    return "$hours:$minutes:$seconds";
  } else {
    return "$minutes:$seconds";
  }
}

String dateFromSeconds(){
  
}