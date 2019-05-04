import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SetupUser extends StatefulWidget{

  @override
  SetupUserState createState() {
    return new SetupUserState();
  }
}

class SetupUserState extends State<SetupUser> {

  TextEditingController _nameEC = TextEditingController();
  TextEditingController _forenameEC = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Update Profile"),
        ),
        body: _userInfo());
  }


  Widget _userInfo(){
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 60.0),
      children: <Widget>[
        SizedBox(height: 16.0,),
        Text("Hi [login]! Update your profile"),
        SizedBox(height: 32.0,),
        TextField(
          controller: _nameEC,
          decoration: InputDecoration(
            hintText: "Name",
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
          ),
        ),
        SizedBox(height: 32.0,),
        TextField(
          controller: _forenameEC,
          decoration: InputDecoration(
              hintText: "Forename",
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
          ),
        ),
        SizedBox(height: 32.0),
        Material(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.lightBlueAccent,
          shadowColor: Colors.lightBlueAccent.shade100,
          elevation: 5.0,
          child: RaisedButton(
            color:Colors.lightBlueAccent,
            child: Text("Update"),
            onPressed: (){

            },
          ),
        )
      ],
    );
  }
}