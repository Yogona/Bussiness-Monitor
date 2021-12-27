import 'package:business_tracker/customs/DefaultPage.dart';
import 'package:business_tracker/customs/LoadingWidget.dart';
import 'package:business_tracker/database/getUserCounter.dart';
import 'package:business_tracker/database/streams.dart';
import 'package:business_tracker/models/UserId.dart';
import 'package:flutter/material.dart';
import 'Login.dart';
import 'Registration.dart';

class Authenticate extends StatefulWidget {
  final Function toggleDashboard;
  Authenticate({required this.toggleDashboard});

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isLogin = true;

  void toggleAuth(){
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    getUserCounter();

    return (isLogin)?Login(toggleAuth: toggleAuth,toggleDashboard: widget.toggleDashboard,):
    StreamBuilder<List>(
      stream: userCounterStream.stream,

      builder: (context, snapShot){
        if(snapShot.hasData){
          snapShot.requireData.map((rec) {
            UserId.setAbbr(rec['abbr']);
            UserId.setValue(rec['value'].toString());
          }).toList();

          return  Registration(toggleAuth: this.toggleAuth, toggleDashboard: widget.toggleDashboard,);
        } else if(snapShot.hasError){
          return DefaultPage(text: snapShot.error.toString(),);
        }

        return LoadingWidget("Inapakia tafadhali subiri...");
      },
    );
  }
}
