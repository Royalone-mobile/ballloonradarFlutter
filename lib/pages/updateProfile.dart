import 'package:balloonradar_flutter/model/user.dart';
import 'package:flutter/material.dart';
import '../utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateProfile extends StatefulWidget {
  User _user;
  String _documentID;
  bool _loadUser;

  UpdateProfile.fromUser(this._user, this._documentID) {
    _loadUser = false;
  }

  UpdateProfile.getUser() {
    _loadUser = true;
  }

  @override
  UpdateProfileState createState() {
    return new UpdateProfileState();
  }
}

class UpdateProfileState extends State<UpdateProfile> {
  String _docID;
  User _newUser;
  TextEditingController _displayNameController;
  TextEditingController _emailController;
  TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    if (widget._loadUser) {
      setup();
    } else {
      _docID = widget._documentID;
      _newUser = widget._user;
      _newUser.hidden = false;
      _displayNameController = TextEditingController.fromValue(
          TextEditingValue(text: _newUser.displayName ?? ""));
      _emailController = TextEditingController.fromValue(
          TextEditingValue(text: _newUser.email ?? ""));
      _countryController = TextEditingController.fromValue(
          TextEditingValue(text: _newUser.country ?? ""));
    }
  }

  void setup() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    var data = await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .get();
    setState(() {
      _docID = data.documentID;
      _newUser = User.fromJson(data.data);
      _newUser.hidden = false;
      _displayNameController = TextEditingController.fromValue(
          TextEditingValue(text: _newUser.displayName ?? ""));
      _emailController = TextEditingController.fromValue(
          TextEditingValue(text: _newUser.email ?? ""));
      _countryController = TextEditingController.fromValue(
          TextEditingValue(text: _newUser.country ?? ""));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update profile"),
      ),
      body: _newUser == null
          ? Text("Loading...")
          : ListView(
              padding: EdgeInsets.all(15.0),
              children: <Widget>[
                TextFormField(
                  controller: _displayNameController,
                  decoration: InputDecoration(labelText: "Name Forname"),
                ),
                TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(labelText: "Email")),
                TextFormField(
                    controller: _countryController,
                    decoration: InputDecoration(labelText: "Country")),
                DropdownButton<KindOfPilot>(
                  value: _newUser.kindOfPilot,
                  items: KindOfPilot.values.map(
                    (KindOfPilot unit) {
                      return new DropdownMenuItem<KindOfPilot>(
                          value: unit,
                          child: Text(unit.toString().split('.')[1]));
                    },
                  ).toList(),
                  onChanged: (KindOfPilot value) {
                    setState(() {
                      _newUser.kindOfPilot = value;
                    });
                  },
                  hint: Text("Kind of pilot"),
                ),
                DropdownButton<FlightsPerMonth>(
                  value: _newUser.flightPerMonth,
                  items: FlightsPerMonth.values.map(
                    (FlightsPerMonth unit) {
                      return new DropdownMenuItem<FlightsPerMonth>(
                          value: unit,
                          child: Text(unit.toString().split('.')[1]));
                    },
                  ).toList(),
                  onChanged: (FlightsPerMonth value) {
                    setState(() {
                      _newUser.flightPerMonth = value;
                    });
                  },
                  hint: Text("Flights per month"),
                ),
                DropdownButton<SpeedUnit>(
                  value: _newUser.speedUnit,
                  items: SpeedUnit.values.map(
                    (SpeedUnit unit) {
                      return new DropdownMenuItem<SpeedUnit>(
                          value: unit,
                          child: Text(unit.toString().split('.')[1]));
                    },
                  ).toList(),
                  onChanged: (SpeedUnit value) {
                    setState(() {
                      _newUser.speedUnit = value;
                    });
                  },
                  hint: Text("Speed unit"),
                ),
                DropdownButton<HeightUnit>(
                  value: _newUser.heightUnit,
                  items: HeightUnit.values.map(
                    (HeightUnit unit) {
                      return new DropdownMenuItem<HeightUnit>(
                          value: unit,
                          child: Text(unit.toString().split('.')[1]));
                    },
                  ).toList(),
                  onChanged: (HeightUnit value) {
                    setState(() {
                      _newUser.heightUnit = value;
                    });
                  },
                  hint: Text("Height unit"),
                ),
                DropdownButton<DistanceUnit>(
                  value: _newUser.distanceUnit,
                  items: DistanceUnit.values.map(
                    (DistanceUnit unit) {
                      return new DropdownMenuItem<DistanceUnit>(
                          value: unit,
                          child: Text(unit.toString().split('.')[1]));
                    },
                  ).toList(),
                  onChanged: (DistanceUnit value) {
                    setState(() {
                      _newUser.distanceUnit = value;
                    });
                  },
                  hint: Text("Distance Unit"),
                ),
                DropdownButton<int>(
                  value: _newUser.utcTime,
                  items: List.generate(24, (i) => i - 11).map(
                    (int unit) {
                      return new DropdownMenuItem<int>(
                          value: unit, child: Text(unit.toString()));
                    },
                  ).toList(),
                  onChanged: (int value) {
                    setState(() {
                      _newUser.utcTime = value;
                    });
                  },
                  hint: Text("Utc Time"),
                ),
                Row(
                  children: <Widget>[
                    Text("Hide my flights"),
                    Checkbox(
                      value: _newUser.hidden ?? false,
                      onChanged: (bool hidden) {
                        setState(() {
                          _newUser.hidden = hidden;
                        });
                      },
                    ),
                  ],
                ),
                RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blueAccent,
                    child: Text("Save"),
                    onPressed: () {
                      saveUser(context);
                    })
              ],
            ),
    );
  }

  void saveUser(BuildContext context) async {
    _newUser.displayName = _displayNameController.text;
    _newUser.email = _emailController.text;
    _newUser.country = _countryController.text;
    bool isAllUserData = true;
    _newUser.toJson().forEach((String key, var value) {
      print("value: $value");
      if (value == null || value == "") {
        print("value null or emtpy");
        isAllUserData = false;
      }
    });
    print("isAlluserData $isAllUserData");
    if (isAllUserData) {
      await Firestore.instance
          .collection("users")
          .document(_docID)
          .setData(_newUser.toJson());
      if (widget._loadUser) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, "/chooseBalloon");
      }
    } else {
      //TODO: Show info to enter all data
    }
  }
}
