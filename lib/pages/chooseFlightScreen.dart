import 'package:balloonradar_flutter/model/flight.dart';
import 'package:balloonradar_flutter/model/user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'previousFlightScreen.dart';
import '../utils.dart';

class ChooseFlightScreen extends StatefulWidget {
  String _balloonuid;
  User _user;

  ChooseFlightScreen(this._balloonuid, this._user);

  @override
  ChooseFlightScreenState createState() {
    return new ChooseFlightScreenState();
  }
}

class ChooseFlightScreenState extends State<ChooseFlightScreen> {
  List<Flight> _flights = [];
  List<DocumentSnapshot> _flightsSnapshot = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose flight")),
      body: balloonsList(context),
    );
  }

  Widget balloonsList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("flights").where("balloonuid", isEqualTo: widget._balloonuid).where("endedTime", isLessThan: getMaxInt()).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text("Loading...");
          _flightsSnapshot = snapshot.data.documents;
          _flights = snapshot.data.documents.map((snp) {
            return Flight.fromJson(snp.data);
          }).toList();
          return ListView.builder(
            itemBuilder: (context, index) => _buildBalloon(context, index),
            itemCount: _flights.length,
          );
        });
  }

  Widget _buildBalloon(BuildContext context, int index) {
    return Card(
      elevation: 5.0,
      child: InkWell(
        onTap: () {
          pickFlight(_flights[index], _flightsSnapshot[index].documentID, context);
        },
        child: Container(
            height: 200.0,
            child: Column(
              children: <Widget>[
                Text("${_flights[index].startedTime} - ${_flights[index].endedTime}"),
              ],
            )),
      ),
    );
  }

  void pickFlight(Flight flight, String documentID, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PreviousFlightScreen(documentID, widget._user)));
  }
}
