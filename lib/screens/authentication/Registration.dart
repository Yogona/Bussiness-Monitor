import 'package:business_tracker/screens/authentication/FinishReg.dart';
import 'package:flutter/material.dart';

import 'Register.dart';

class Registration extends StatefulWidget {
  final Function toggleDashboard;
  final Function toggleAuth;
  Registration({required this.toggleAuth, required this.toggleDashboard});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool _hasRegistered = false;

  void setRegistered(){
    setState(() {
      _hasRegistered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_hasRegistered)?FinishReg(toggleDashboard: widget.toggleDashboard):
    Register(toggleAuth: widget.toggleAuth, setRegistered: setRegistered,);
  }
}
