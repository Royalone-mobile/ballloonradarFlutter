import 'package:balloonradar_flutter/model/balloon.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditBalloonScreen extends StatefulWidget {
  String _documentID;
  Balloon _balloon;

  @override
  EditBalloonScreenState createState() {
    return new EditBalloonScreenState();
  }

  EditBalloonScreen.newBalloon() {
    _documentID = null;
    _balloon = Balloon();
  }

  EditBalloonScreen.editBalloon(this._documentID, this._balloon);
}

class EditBalloonScreenState extends State<EditBalloonScreen> {
  TextEditingController _signURLController;
  TextEditingController _photoURLController;

  @override
  void initState() {
    super.initState();
    if (widget._documentID == null) {
      _photoURLController = TextEditingController();
      _signURLController = TextEditingController();
    } else {
      _photoURLController = TextEditingController.fromValue(
          TextEditingValue(text: widget._balloon.photoURL));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit balloon")),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        children: <Widget>[
          signView(),
          TextFormField(
            controller: _photoURLController,
            decoration: InputDecoration(
              hintText: "PhotoURL",
            ),
            onFieldSubmitted: (str) {
              saveBalloon(context);
            },
          ),
          SizedBox(
            height: 32.0,
          ),
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.blueAccent,
              size: 60.0,
            ),
            onPressed: () {
              saveBalloon(context);
            },
          ),
          SizedBox(
            height: 32.0,
          ),
          deleteButton(context)
        ],
      ),
    );
  }

  Widget signView() {
    if (widget._documentID == null) {
      return TextFormField(
          controller: _signURLController,
          decoration: InputDecoration(
            hintText: "Sign",
          ));
    } else {
      return Text("SIGN: ${widget._balloon.sign}");
    }
  }

  Widget deleteButton(BuildContext context) {
    if (widget._documentID == null) {
      return SizedBox();
    } else {
      return IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.blueAccent,
          size: 60.0,
        ),
        onPressed: () {
          deleteBalloon(context);
        },
      );
    }
  }

  void saveBalloon(BuildContext context) async {
    String photoURL = _photoURLController.text;
    String sign  = widget._balloon.sign ?? _signURLController.text;
    String uid = widget._balloon.uid ?? (await FirebaseAuth.instance.currentUser()).uid;
    Balloon newBalloon = Balloon(
        uid: uid,
        sign: sign,
        photoURL: photoURL,
        approved: widget._balloon.approved);
    print(newBalloon.toString());
    await Firestore.instance
        .collection("balloons")
        .document(widget._documentID)
        .setData(newBalloon.toJson());
    Navigator.pop(context);
  }

  void deleteBalloon(BuildContext context) async {
    await Firestore.instance
        .collection("balloons")
        .document(widget._documentID)
        .delete();
    Navigator.pop(context);
  }
}
