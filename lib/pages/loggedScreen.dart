import 'package:balloonradar_flutter/model/balloon.dart';
import 'package:balloonradar_flutter/model/flight.dart';
import 'package:balloonradar_flutter/model/loc.dart';
import 'package:balloonradar_flutter/model/user.dart';
import 'package:balloonradar_flutter/pages/flightPanelScreen.dart';
import 'package:balloonradar_flutter/pages/updateProfile.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils.dart';
import 'package:geolocator/geolocator.dart';

import 'chooseFlightScreen.dart';

class LoggedScreen extends StatefulWidget {
  Balloon balloon;
  String balloonDocID;

  LoggedScreen(this.balloon, this.balloonDocID);

  @override
  LoggedScreenState createState() {
    return new LoggedScreenState();
  }
}

class LoggedScreenState extends State<LoggedScreen> {
  User _user;
  String _flightDocID;

  @override
  void initState() {
    super.initState();
    setupUserStream();
    setupLastFlightStream();
    setupGPSStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Balloonradar"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("Drawer Header"),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UpdateProfile.getUser()));
              },
              title: Text("Settings"),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ChooseFlightScreen(widget.balloonDocID, _user)));
              },
              title: Text("Flights"),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/chooseBalloon');
              },
              title: Text("Change balloon"),
            )
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("flights")
            .document(_flightDocID)
            .collection("points")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Loc> locs = snapshot.data.documents.map((documentSnapshot) {
            return Loc.fromJson(documentSnapshot.data);
          }).toList();

          return Stack(
            children: <Widget>[
/*              FlutterMap(
                options: new MapOptions(
                  onTap: (tap) {
                    addPosition(tap.latitude, tap.longitude, 0);
                  },
                  center: new LatLng(51.5, -0.09),
                  zoom: 13.0,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate: "https://api.tiles.mapbox.com/v4/"
                        "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                    additionalOptions: {
                      'accessToken': 'pk.eyJ1IjoicmFmYWxiZWRuYXJjenVrIiwiYSI6ImNqa2xqZTBqcTAxaGczb3RkdTBnemU3cDAifQ.l5DEpmw_h7Clclc-5vTwtw',
                      'id': 'mapbox.streets',
                    },
                  ),
                  PolylineLayerOptions(polylines: [
                    Polyline(
                        color: Colors.red,
                        strokeWidth: 4.0,
                        points: snapshot.data.documents.map((documentSnapshot) {
                          Loc loc = Loc.fromJson(documentSnapshot.data);
                          return LatLng(loc.lat, loc.lng);
                        }).toList()),
                    Polyline(strokeWidth: 2.0, color: Colors.lightBlueAccent, points: getHelperLatLngs(locs)),
                    Polyline(strokeWidth: 4.0, color: Colors.greenAccent, points: getGreenLatLng(locs))
                  ]),
                  MarkerLayerOptions(markers: getMarkers(snapshot.data.documents))
                ],
              ),*/
              Align(
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: 0.7,
                  child: RaisedButton(
                    color: _flightDocID != null
                        ? Colors.redAccent
                        : Colors.greenAccent,
                    onPressed: () {
                      flightPanelClick(context);
                    },
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "FLIGHT PANEL",
                            style: TextStyle(fontSize: 24.0),
                          )),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Opacity(
                  opacity: 0.7,
                  child: Container(
                    color: Colors.blueAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          getDistance(_user, locs),
                          textScaleFactor: 1.5,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          getTime(locs),
                          textScaleFactor: 1.5,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          getDirection(locs),
                          textScaleFactor: 1.5,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          getAltitude(_user, locs),
                          textScaleFactor: 1.5,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          getSpeed(_user, locs),
                          textScaleFactor: 1.5,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void flightPanelClick(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FlightPanelScreen(
                _flightDocID, widget.balloonDocID, _user, widget.balloon)));
  }

  void addPosition(double latitude, double longitude, int altitude) {
    if (_flightDocID != null) {
      Loc location = Loc(
          lat: latitude,
          lng: longitude,
          alt: altitude,
          time: (DateTime.now().millisecondsSinceEpoch / 1000).floor());
      Firestore.instance
          .collection("flights")
          .document(_flightDocID)
          .collection("points")
          .add(location.toJson());
    }
  }

  void setupLastFlightStream() async {
    Firestore.instance
        .collection("flights")
        .where("balloonuid", isEqualTo: widget.balloonDocID)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      Flight lastFlight = Flight.fromJson(snapshot.documents.last.data);
      if (!isEnded(lastFlight.endedTime)) {
        setState(() {
          _flightDocID = snapshot.documents.last.documentID;
        });
      } else {
        setState(() {
          _flightDocID = null;
        });
      }
    });
  }

  List<LatLng> getHelperLatLngs(List<Loc> locs) {
    int maxSmoothness = 10;
    if (locs.length < 2) {
      return [];
    } else {
      LatLng p2 = LatLng(locs.last.lat, locs.last.lng);
      LatLng p1;
      if (locs.length < maxSmoothness) {
        p1 = LatLng(locs.first.lat, locs.first.lng);
      } else {
        p1 = LatLng(locs[locs.length - maxSmoothness].lat,
            locs[locs.length - maxSmoothness].lng);
      }
      return [p1, p2];
    }
  }

  List<LatLng> getGreenLatLng(List<Loc> locs) {
    int maxSmoothness = 10;
    int timeSeconds = 30 * 60;
    if (locs.length < 2) {
      return [];
    } else {
      Distance distance = Distance();
      LatLng p2 = LatLng(locs.last.lat, locs.last.lng);
      DateTime p2Time =
          DateTime.fromMillisecondsSinceEpoch(locs.last.time * 1000);
      LatLng p1;
      DateTime p1Time;
      if (locs.length < maxSmoothness) {
        p1 = LatLng(locs.first.lat, locs.first.lng);
        p1Time = DateTime.fromMillisecondsSinceEpoch(locs.first.time * 1000);
      } else {
        p1 = LatLng(locs[locs.length - maxSmoothness].lat,
            locs[locs.length - maxSmoothness].lng);
        p1Time = DateTime.fromMillisecondsSinceEpoch(
            locs[locs.length - maxSmoothness].time * 1000);
      }
      double ms = distance.distance(p1, p2) /
          (p2Time.millisecondsSinceEpoch - p1Time.millisecondsSinceEpoch) *
          1000;
      double meters = ms * timeSeconds;
      double bearing = distance.bearing(p1, p2);
      return [p2, latlngFromDestinationBearing(p2, bearing, meters)];
    }
  }

  void setupUserStream() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection("users")
        .document(user.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      setState(() {
        _user = User.fromJson(snapshot.data);
      });
    });
  }

  void setupGPSStream() async {
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
        accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 10);
    geolocator.getPositionStream(locationOptions).listen((Position _position) {
      addPosition(
          _position.latitude, _position.longitude, _position.altitude.floor());
    });
  }
}
