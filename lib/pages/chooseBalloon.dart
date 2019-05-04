import 'package:balloonradar_flutter/model/balloon.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editBalloonScreen.dart';
import 'loggedScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChooseBalloon extends StatefulWidget {
  @override
  ChooseBalloonState createState() {
    return new ChooseBalloonState();
  }
}

class ChooseBalloonState extends State<ChooseBalloon> {
  List<Balloon> _balloons = [];
  List<DocumentSnapshot> _balloonsSnapshot = [];
  FirebaseUser _user;

  @override
  void initState() {
    super.initState();
    setupUser();
  }

  void setupUser() async {
    FirebaseAuth.instance.currentUser().then((usr) {
      setState(() {
        _user = usr;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose balloon")),
      body: balloonsList(context),
    );
  }

  Widget balloonsList(BuildContext context) {
    if (_user == null) {
      return Text("Loading user...");
    }
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("balloons")
            .where("uid", isEqualTo: _user.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text("Loading...");
          _balloonsSnapshot = snapshot.data.documents;
          _balloons = snapshot.data.documents.map((snp) {
            Balloon bln = Balloon.fromJson(snp.data);
            return bln;
          }).toList();
          return ListView.builder(
            itemBuilder: (context, index) => _buildBalloon(context, index),
            itemCount: _balloons.length + 1,
          );
        });
  }

  Widget _buildBalloon(BuildContext context, int index) {
    if (index < _balloons.length) {
      return Card(
        elevation: 5.0,
        child: InkWell(
          onTap: () {
            pickBalloon(
                _balloons[index], _balloonsSnapshot[index].documentID, context);
          },
          child: Container(
              height: 200.0,
              child: Column(
                children: <Widget>[
                  Image.network(
                    _balloons[index].photoURL,
                    height: 100.0,
                  ),
                  Text(_balloons[index].sign),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditBalloonScreen.editBalloon(
                                      _balloonsSnapshot[index].documentID,
                                      _balloons[index])));
                    },
                  )
                ],
              )),
        ),
      );
    } else {
      return Card(
        elevation: 5.0,
        child: Container(
          height: 200.0,
          child: IconButton(
            icon: Icon(
              Icons.add,
              size: 100.0,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditBalloonScreen.newBalloon()));
            },
          ),
        ),
      );
    }
  }

  void pickBalloon(Balloon balloon, String documentID, BuildContext context) {
    if (balloon.approved == true) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LoggedScreen(balloon, documentID)));
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Balloon not approved")));
    }
  }
}
