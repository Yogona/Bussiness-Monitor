import 'package:business_tracker/screens/authentication/Authenticate.dart';
import 'package:business_tracker/screens/dashboard/Dashboard.dart';
import 'package:flutter/material.dart';

import 'models/User.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _showDashboard = false;

  void toggleDashboard(){
    setState(() {
      _showDashboard = !_showDashboard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot){
        return (_showDashboard)?Dashboard(toggleDashboard: toggleDashboard,):Authenticate(toggleDashboard: toggleDashboard,);
      },
    );
  }
}