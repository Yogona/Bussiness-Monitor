import 'dart:async';
import 'package:business_tracker/customs/CustomSnackBar.dart';
import 'package:business_tracker/customs/LoadingWidget.dart';
import 'package:business_tracker/models/FeedBack.dart';
import 'package:business_tracker/models/User.dart';
import 'package:business_tracker/models/UserId.dart';
import 'package:business_tracker/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  final Function toggleAuth;
  final Function setRegistered;
  Register({required this.toggleAuth, required this.setRegistered});
  final GlobalKey<FormState> _regKey = GlobalKey<FormState>();

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _fName = "";
  String _sName = "";
  String _lName = "";
  String _email = "";
  String _phone = "";
  String _location = "";
  String _gender = "";
  bool _isLoading = false;

  Future<void> register() async{
    var url = Uri.parse(regLink);
    String userId = UserId.getAbbr()+UserId.getValue();
    String usersCounter = UserId.getValue();

    Map<String, dynamic> body = {
      "userId"    : userId,//The id of the new added user, concatenated to get user db id
      "usersCtr"  : usersCounter, //Stores users number
      "fName"     : _fName,
      "sName"     : _sName,
      "lName"     : _lName,
      "email"     : _email,
      "phone"     : _phone,
      "location"  : _location,
      "gender"    : _gender,
    };

    try{
      var response = await http.post(url, body: body);
      //print(response.body);
      feedBack = {
        "hasError": false,
        "msg": "Akaunti imetengenezwa kikamilifu.",
      };
    }catch(e){
      feedBack = {
        "hasError": true,
        "msg": e.toString(),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)?LoadingWidget("Inatengeneza akaunti..."):Scaffold(
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
                      labelText: "Jina la kwanza",

                      hintText: "John",
                    ),

                    keyboardType: TextInputType.name,

                    inputFormatters: namesFormatters,

                    validator: namesValidators,

                    onChanged: (val){
                      setState(() {
                        _fName = val;
                      });
                    },
                  ),

                  SizedBox(
                    height: sizedHeight,
                  ),

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    decoration: inputDecoration.copyWith(
                      labelText: "Jina la kati",

                      hintText: "Michael",
                    ),

                    keyboardType: TextInputType.name,

                    inputFormatters: namesFormatters,

                    validator: (val){
                      if(val != ""){
                        if(!val!.startsWith(RegExp(r"[A-Z]"))){
                          return "Tafadhali anza na herufi kubwa.";
                        }
                      }

                      return null;
                    },

                    onChanged: (val){
                      setState(() {
                        _sName = val;
                      });
                    },
                  ),

                  SizedBox(
                    height: sizedHeight,
                  ),

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    decoration: inputDecoration.copyWith(
                      labelText: "Jina la mwisho",

                      hintText: "Doe",
                    ),

                    keyboardType: TextInputType.name,

                    inputFormatters: namesFormatters,

                    validator: namesValidators,

                    onChanged: (val){
                      setState(() {
                        _lName = val;
                      });
                    },
                  ),

                  SizedBox(
                    height: sizedHeight,
                  ),

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    keyboardType: TextInputType.emailAddress,

                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,A-Z,a-z,@,~,-_+]')),
                    ],

                    decoration: inputDecoration.copyWith(
                      labelText: "Barua pepe",

                      hintText: "contact@tansoften.com",
                    ),

                    validator: (val){
                      if(val == ""){
                        return "Tafadhali jaza barua pepe";
                      } else if(val!.startsWith(RegExp(r'@')) || val.endsWith("_") || val.endsWith("~") || val.endsWith("-") || val.endsWith("@") || val.endsWith(".") || val.endsWith("+")){
                        return "Tafadhali weka barua pepe sahihi.";
                      }

                      return null;
                    },

                    onChanged: (val){
                      setState(() {
                        _email = val;
                      });
                    },
                  ),

                  SizedBox(
                    height: sizedHeight,
                  ),

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    decoration: inputDecoration.copyWith(
                      labelText: "Namba za simu",

                      hintText: "0763765547",
                    ),

                    keyboardType: TextInputType.phone,

                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'\d')),
                    ],

                    validator: (val){
                      if(val == ""){
                        return "Tafadhali jaza namba za simu";
                      }

                      return null;
                    },

                    onChanged: (val){
                      setState(() {
                        _phone = val;
                      });
                    },
                  ),

                  SizedBox(
                    height: sizedHeight,
                  ),

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    decoration: inputDecoration.copyWith(
                      labelText: "Mahali",

                      hintText: "Kisasa",
                    ),

                    keyboardType: TextInputType.streetAddress,

                    validator: (val){
                      if(val == ""){
                        return "Tafadhali jaza mahali";
                      }

                      return null;
                    },

                    onChanged: (val){
                      setState(() {
                        _location = val;
                      });
                    },
                  ),

                  SizedBox(
                    height: sizedHeight,
                  ),

                  DropdownButtonFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    decoration: inputDecoration,

                    hint: Text("Jinsia"),

                    validator: (val){
                      if(val == null){
                        return "Tafadhali chagua jinsia";
                      }

                      return null;
                    },

                    items: [
                      DropdownMenuItem(
                        child: Text(
                          "Me",
                        ),

                        value: 'M',
                      ),

                      DropdownMenuItem(
                        child: Text(
                          "Ke",
                        ),

                        value: 'F',
                      )
                    ],

                    onChanged: (val){
                      setState(() {
                        _gender = val.toString();
                      });
                    },
                  ),

                  ElevatedButton(
                    style: btnStyle,

                    child: Text("Sajili"),

                    onPressed: ()async{
                      if(widget._regKey.currentState!.validate()){
                        setState(() {
                          _isLoading = true;
                        });

                        await register();

                        setState(() {
                          _isLoading = false;
                        });

                        if(!feedBack['hasError']){
                          User.setProfile(UserId.getUserId(), "RL1", "", _fName, _sName, _lName, _email, _phone, _location, _gender);
                          widget.setRegistered();
                        }

                        SnackBar snackBar = CustomSnackBar(msg: feedBack['msg']) as SnackBar;
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
            child: Text("Ingia"),

            onPressed: (){
              widget.toggleAuth();
            },
          )
        ],
      ),
    );
  }
}