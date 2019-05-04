import 'package:balloonradar_flutter/model/user.dart';
import 'package:balloonradar_flutter/pages/updateProfile.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckLogin extends StatelessWidget {
  final Auth _auth = Auth();

  void getUser(BuildContext context) async {
    _auth.currentUser().then((FirebaseUser value) async {
      checkFirebaseUser(value, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    getUser(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("LoginScrenn"),
      ),
      body: _notLogged(context),
    );
  }

  Widget _notLogged(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        _signInViaGoogle(context);
      },
      child: Text("login"),
    );
  }

  void _signInViaGoogle(BuildContext context) async {
    FirebaseUser user = await _auth.singInGoogle();
    checkFirebaseUser(user, context);
  }

  void checkFirebaseUser(FirebaseUser value, BuildContext context) async {
    if (value != null) {
      var data = await Firestore.instance
          .collection("users")
          .document(value.uid)
          .get();
      User user;
      if (data.data != null) {
        user = User.fromJson(data.data);
      } else {
        user = User(displayName: value.displayName, email: value.email);
        Firestore.instance
            .collection('users')
            .document(value.uid)
            .setData(user.toJson());
      }
      bool isAllUserData = true;
      user.toJson().forEach((String key, var value) {
        print("value: $value");
        if (value == null) {
          isAllUserData = false;
          return;
        }
      });
      if (isAllUserData) {
        Navigator.pushReplacementNamed(context, '/chooseBalloon');
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    UpdateProfile.fromUser(user, data.documentID)));
      }
    }
  }
}
