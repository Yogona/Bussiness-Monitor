import 'dart:convert';
import 'package:business_tracker/models/UserId.dart';
import 'package:flutter/material.dart';
import 'package:business_tracker/customs/LoadingWidget.dart';
import 'package:business_tracker/models/FeedBack.dart';
import 'package:business_tracker/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:business_tracker/shared/Methods.dart';

class FinishReg extends StatefulWidget {
  final GlobalKey<FormState> _regKey = GlobalKey<FormState>();
  final Function toggleDashboard;
  FinishReg({required this.toggleDashboard});

  @override
  _FinishRegState createState() => _FinishRegState();
}

class _FinishRegState extends State<FinishReg> {
  String _username = "";
  String _passwd = "";

  bool _isLoading = false;

  Future setCredentials() async{
    var url = Uri.parse(finishRegLink);
    String userId = UserId.getAbbr()+UserId.getValue();
    Methods methods = new Methods();

    try{

      Map<String, dynamic> body = {
        "username": _username,
        "passwd": _passwd,
        "userId": userId,
      };

      var response = await http.post(url, body: body);
      print(json.decode(response.body));
      feedBack = {
        "hasError": false,
        "msg": "Hongera umemaliza, kujisajili.",
      };

    }catch(e){
      feedBack = {
        "hasError": true,
        "msg": e.toString(),
      };
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)?LoadingWidget("Inamalizia usajili..."):Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 50.0,
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
            height: 30.0,
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
              key: widget._regKey,

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

                      labelText: "Jina la Akaunti",

                      hintText: "Yogona012",
                    ),

                    keyboardType: TextInputType.name,

                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'\w')),
                    ],

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

                      hintText: "Tumia namba, herufi na alama.",
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

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    decoration: inputDecoration.copyWith(
                      prefixIcon: Icon(Icons.password),

                      labelText: "Hakikisha nenosiri",

                      hintText: "Nenosiri zifanane. ",
                    ),

                    obscureText: true,

                    validator: (val){
                      if(val == ""){
                        return "Tafadhali rudia nenosiri.";
                      } else if(val != _passwd){
                        return "Nenosiri hazifanani!";
                      }

                      return null;
                    },
                  ),

                  SizedBox(
                    height: sizedHeight,
                  ),

                  ElevatedButton(
                    style: btnStyle,

                    child: Text("Endelea"),

                    onPressed: ()async{
                      if(widget._regKey.currentState!.validate()){
                        setState(() {
                          _isLoading = true;
                        });

                        await setCredentials();

                        setState(() {
                          _isLoading = false;
                          widget.toggleDashboard();
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
        ],
      ),
    );
  }
}