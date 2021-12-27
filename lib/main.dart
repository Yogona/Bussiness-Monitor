import 'dart:async';

import 'package:business_tracker/database/getUserCounter.dart';
import 'package:business_tracker/database/streams.dart';
import 'package:business_tracker/shared/constants.dart';
import 'package:flutter/material.dart';

import 'Wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Timer _timer = Timer.periodic(Duration(seconds: 1), (timer) => getUserCounter());
  void initState(){
    //getUserCounter();
    super.initState();
  }

  void dispose(){
    // if(_timer.isActive){
    //   _timer.cancel();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        ),

      home: SafeArea(child: Wrapper()),
    );
  }
}
