import 'package:balloonradar_flutter/model/loc.dart';
import 'package:balloonradar_flutter/model/user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils.dart';

class PreviousFlightScreen extends StatefulWidget {
  String _flightDocID;
  User _user;

  PreviousFlightScreen(this._flightDocID, this._user);

  @override
  PreviousFlightScreenState createState() {
    return new PreviousFlightScreenState();
  }
}

class PreviousFlightScreenState extends State<PreviousFlightScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Balloonradar"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("flights")
            .document(widget._flightDocID)
            .collection("points")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Loc> locs = snapshot.data.documents.map((documentSnapshot) {
            return Loc.fromJson(documentSnapshot.data);
          }).toList();
          if (locs.length < 1) {
            return Text("Loading or no flights points...");
          }
          return Stack(
            children: <Widget>[
/*              FlutterMap(
                options: new MapOptions(
                  center: LatLng(locs.first.lat, locs.first.lng),
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
                  ]),
                  MarkerLayerOptions(markers: getMarkers(snapshot.data.documents))
                ],
              ),*/
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
                          getDistance(widget._user, locs),
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
                          getMaxAltitude(widget._user, locs),
                          textScaleFactor: 1.5,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          getSpeed(widget._user, locs),
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
}
