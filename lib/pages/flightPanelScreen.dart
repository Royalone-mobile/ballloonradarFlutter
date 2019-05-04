import 'package:balloonradar_flutter/model/balloon.dart';
import 'package:balloonradar_flutter/model/flight.dart';
import 'package:balloonradar_flutter/model/user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils.dart';
import 'previousFlightScreen.dart';

class FlightPanelScreen extends StatefulWidget {
  String _flightDocID;
  String _balloonDocID;
  User _user;
  Balloon _balloon;

  List<String> params = [
    "ARC valid",
    "Insurance valid",
    "pilot licence / medical valid",
    "flight radio on board",
    "ICAO map on board",
    "flight instrument on board",
    "gas tanks full",
    "quick release attached to the car",
    "petrol in the fan"
  ];

  @override
  FlightPanelScreenState createState() {
    return new FlightPanelScreenState();
  }

  FlightPanelScreen(this._flightDocID, this._balloonDocID, this._user, this._balloon);
}

class FlightPanelScreenState extends State<FlightPanelScreen> {
  bool _newFlightClicked = false;
  Map<String, bool> _values;
  bool _allSafetyParams = false;
  bool _safetyParamsChecked = false;
  Flight _flight;

  @override
  void initState() {
    super.initState();
    if (widget._flightDocID != null) {
      Firestore.instance.collection("flights").document(widget._flightDocID).get().then((DocumentSnapshot snapshot) {
        setState(() {
          _flight = Flight.fromJson(snapshot.data);
        });
      });
      _allSafetyParams = false;
      _safetyParamsChecked = true;
      _values = Map.fromIterable(widget.params, key: (param) => param, value: (param) => true);
    } else {
      _values = Map.fromIterable(widget.params, key: (param) => param, value: (param) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Flight Panel")),
        body: Builder(
          builder: (context) => !_newFlightClicked && widget._flightDocID == null
              ? RaisedButton(
                  child: Text("NEW FLIGHT"),
                  onPressed: newFlight,
                )
              : ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  children: <Widget>[
                    widget._flightDocID == null ? Text(DateTime.now().toString()) : SizedBox(),
                    SizedBox(
                      height: 25.0,
                    ),
                    Text("Sunrise/Sunset: TODO"),
                    SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _safetyParamsChecked,
                          onChanged: widget._flightDocID == null
                              ? (value) {
                                  setState(() {
                                    _safetyParamsChecked = value;
                                    if (_safetyParamsChecked) {
                                      _values = Map.fromIterable(widget.params, key: (param) => param, value: (param) => true);
                                    } else {
                                      _values = Map.fromIterable(widget.params, key: (param) => param, value: (param) => false);
                                    }
                                  });
                                }
                              : null,
                        ),
                        RaisedButton(
                            child: Text("All Safety Params"),
                            onPressed: widget._flightDocID == null
                                ? () {
                                    setState(() {
                                      _allSafetyParams = !_allSafetyParams;
                                    });
                                  }
                                : null),
                      ],
                    ),
                    Column(
                      children: _allSafetyParams ? safetyParams() : [],
                    ),
                    RaisedButton(
                      color: _values.containsValue(false) ? null : Colors.green,
                      onPressed: widget._flightDocID == null
                          ? () {
                              takeOff(context);
                            }
                          : null,
                      child: Text(widget._flightDocID == null ? "START FLIGHT" : "FLIGHT STARTED"),
                    ),
                    _flight == null ? SizedBox() : Text("Start time: ${_flight.startedTime.toString()}"),
                    _flight == null
                        ? SizedBox()
                        : RaisedButton(
                            child: Text("50% gas fuel left"),
                            onPressed: _flight.halfGas == null
                                ? () {
                                    halfGas();
                                  }
                                : null,
                          ),
                    _flight == null || _flight.halfGas == null ? SizedBox() : Text("Gas wil be empty in ${getGasEmptyTime(_flight)}"),
                    widget._flightDocID == null
                        ? SizedBox()
                        : RaisedButton(
                            color: Colors.red,
                            textColor: Colors.white,
                            onPressed: () {
                              landing(context);
                            },
                            child: Text("STOP FLIGHT"),
                          )
                  ],
                ),
        ));
  }

  List<Widget> safetyParams() {
    return widget.params.map((String param) {
      return Row(
        children: <Widget>[
          Checkbox(
              value: _values[param],
              onChanged: (value) {
                setState(() {
                  _values[param] = value;
                });
              }),
          Text(param),
        ],
      );
    }).toList();
  }

  void takeOff(BuildContext context) async {
    if (!_values.containsValue(false)) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      Flight newFlight = Flight((DateTime.now().millisecondsSinceEpoch / 1000).floor(), getMaxInt(), widget._user.hidden,
          useruid: user.uid, balloonuid: widget._balloonDocID, displayName: widget._user.displayName, sign: widget._balloon.sign, photoURL: widget._balloon.photoURL);
      await Firestore.instance.collection("flights").add(newFlight.toJson());
      Navigator.pop(context);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("You have to check all safety params beore flight")));
    }
  }

  void landing(BuildContext context) async {
    DocumentSnapshot snapshot = await Firestore.instance.collection("flights").document(widget._flightDocID).get();
    Flight flight = Flight.fromJson(snapshot.data);
    flight.endedTime = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    await Firestore.instance.collection("flights").document(widget._flightDocID).setData(flight.toJson());
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => PreviousFlightScreen(widget._flightDocID, widget._user)));
  }

  void newFlight() {
    setState(() {
      _newFlightClicked = true;
    });
  }

  halfGas() async {
    DocumentSnapshot snapshot = await Firestore.instance.collection("flights").document(widget._flightDocID).get();
    Flight flight = Flight.fromJson(snapshot.data);
    flight.halfGas = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    await Firestore.instance.collection("flights").document(widget._flightDocID).setData(flight.toJson());
    setState(() {
      _flight.halfGas = flight.halfGas;
    });
  }

  String getGasEmptyTime(Flight flight) {
    if (flight == null || flight.startedTime == null || flight.halfGas == null) return "00:00";
    Duration fromStartToHalf = Duration(seconds: flight.halfGas - flight.startedTime);
    Duration fromHalfToEnd = fromStartToHalf > Duration(minutes: 7) ? fromStartToHalf - Duration(minutes: 7) : Duration();
    Duration left = fromHalfToEnd - DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(flight.halfGas * 1000));
    return durationToHMS(left);
  }
}
