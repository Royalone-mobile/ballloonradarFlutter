import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> singInGoogle() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    FirebaseUser user = await _auth.signInWithCredential(credential);
    return user;
  }

  Future<FirebaseUser> currentUser() async {
    return _auth.currentUser();
  }

  Future<List<DocumentSnapshot>> getBalloons() async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection("balloons").getDocuments();
    return snapshot.documents;
  }
}
