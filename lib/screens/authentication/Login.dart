import 'dart:convert';

import 'package:business_tracker/customs/CustomSnackBar.dart';
import 'package:business_tracker/customs/LoadingWidget.dart';
import 'package:business_tracker/models/User.dart';
import 'package:business_tracker/shared/Methods.dart';
import 'package:business_tracker/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  final Function toggleAuth;
  final Function toggleDashboard;
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  Login({ required this.toggleAuth, required this.toggleDashboard });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Methods methods = Methods();
  bool _isLoading = false;
  String _errorTxt = "";
  String _username = "";
  String _passwd = "";

  Future<dynamic> _accessSystem() async {
    var url = Uri.parse(loginLink);
    Map<String, dynamic> body = {
      "username": _username,
      "passwd": _passwd,
    };
    var response = await http.post(url, body: body,);
    List<dynamic> user = json.decode(response.body);


    if(user.elementAt(0)['loggedIn']){
      User.setProfile(
          user.elementAt(0)['userId'],
          user.elementAt(0)['roleId'],
          user.elementAt(0)['username'],
          user.elementAt(0)['fName'],
          user.elementAt(0)['sName'],
          user.elementAt(0)['lName'],
          user.elementAt(0)['email'],
          user.elementAt(0)['phone'],
          user.elementAt(0)['location'],
          user.elementAt(0)['gender'],
      );

      widget.toggleDashboard();

      SnackBar snackBar = CustomSnackBar(msg: "Hongera umeingia kikamilifu.") as SnackBar;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        _errorTxt = "Taarifa zako sio sahihi, jaribu tena.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)?LoadingWidget("Inapakia, tafadhali subiri..."):Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 100.0,
          ),

          Center(
            child: Text(
              "KITUNZA BIASHARA",
              style: TextStyle(
                fontSize: headFontSize,

                color: headColor,
              ),
            ),
          ),

          SizedBox(
            height: 50.0,
          ),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),

              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: boxShadowColor,
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                ),
              ],
            ) ,

            margin: EdgeInsets.only(
              left: formMargin,
              right: formMargin,
            ),

            padding: EdgeInsets.only(
              left: formPadding,
              right: formPadding,
            ),

            child: Form(
              key: widget._loginKey,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [
                  SizedBox(
                    height: sizedHeight,
                  ),

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    decoration: inputDecoration.copyWith(
                      prefixIcon: Icon(Icons.person),

                      labelText: "Jina la akaunti",

                      hintText: "Mekzedek",
                    ),

                    keyboardType: TextInputType.name,

                    validator: (val){
                      if(val == ""){
                        return "Tafadhali tumia herufi, namba na '_'.";
                      }

                      return null;
                    },

                    onChanged: (val){
                      setState(() {
                        _username = val;
                      });
                    },
                  ),

                  SizedBox(
                    height: sizedHeight,
                  ),

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    decoration: inputDecoration.copyWith(
                      prefixIcon: Icon(Icons.password),

                      labelText: "Nenosiri",

                      hintText: "Weka neno siri.",
                    ),

                    obscureText: true,

                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'[.\\]')),
                    ],

                    onChanged: (val){
                      setState(() {
                        _passwd = val;
                      });
                    },

                    validator: (val){
                      if(val == ""){
                        return "Jaza neno siri, na usitumie '.' wala '\\'.";
                      }

                      return null;
                    },
                  ),

                  SizedBox(
                    height: sizedHeight,
                  ),

                  Text(
                    _errorTxt,
                    style: TextStyle(
                      color: errorColor,
                    ),
                  ),

                  SizedBox(
                    height: sizedHeight,
                  ),

                  ElevatedButton(
                    style: btnStyle,

                    child: Text("Ingia"),

                    onPressed: () async {
                      if(widget._loginKey.currentState!.validate()){
                        setState(() {
                          _isLoading = true;
                        });

                        await _accessSystem();

                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            height: 10.0,
          ),

          TextButton(
            child: Text(
                "Jisajili"
            ),

            onPressed: (){
              widget.toggleAuth();
            },
          ),
        ],
      ),
    );
  }
}