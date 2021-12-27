import 'dart:convert';

import 'package:business_tracker/customs/CustomSnackBar.dart';
import 'package:business_tracker/customs/LoadingWidget.dart';
import 'package:business_tracker/models/User.dart';
import 'package:business_tracker/shared/Methods.dart';
import 'package:business_tracker/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class RegisterProduct extends StatefulWidget {
  final GlobalKey<FormState> _productKey = GlobalKey<FormState>();

  @override
  _RegisterProductState createState() => _RegisterProductState();
}

class _RegisterProductState extends State<RegisterProduct> {
  bool _isLoading = false;
  String _productName = "";
  String _description = "";
  String _price = "";

  Future<void> _registerProduct() async {
    Map<String, dynamic> _body = {
      "productName": _productName,
      "price": _price,
      "description": _description,
      "addedBy": User.getUserId()
    };

    var url = Uri.parse(prodRegLink);
    var response = await http.post(url, body: _body,);
    SnackBar snackBar;
    if(json.decode(response.body) == "true"){
      snackBar = CustomSnackBar(msg: "Bidhaa imesajiliwa kikamilifu.") as SnackBar;
    }else{
      snackBar = CustomSnackBar(msg: json.decode(response.body)) as SnackBar;
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {

    return (_isLoading)?LoadingWidget("Inalifanyia kazi, tafadhali subiri..."):
    ListView(
      children: [
        // SizedBox(
        //   height: 50.0,
        // ),
        //
        // Center(
        //   child: Text(
        //     "Ongeza Bidhaa",
        //     style: TextStyle(
        //       fontSize: headFontSize,
        //
        //       color: headColor,
        //     ),
        //   ),
        // ),

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
            key: widget._productKey,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                SizedBox(
                  height: sizedHeight,
                ),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  decoration: inputDecoration.copyWith(
                    prefixIcon: Icon(Icons.edit),

                    labelText: "Jina la bidhaa",

                    hintText: "Peni",
                  ),

                  keyboardType: TextInputType.text,

                  validator: (val){
                    if(val == ""){
                      return "Tafadhali jaza hapa.";
                    }

                    return null;
                  },

                  onChanged: (val){
                    setState(() {
                      _productName = val;
                    });
                  },
                ),

                SizedBox(
                  height: sizedHeight,
                ),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  decoration: inputDecoration.copyWith(
                    prefixIcon: Icon(Icons.money),

                    labelText: "Bei",

                    hintText: "5000",
                  ),

                  keyboardType: TextInputType.number,
                  
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'\d'))
                  ],

                  validator: (val){
                    if(val == ""){
                      return "Tafadhali jaza kwa namba.";
                    } else if(val!.startsWith(RegExp(r'0'))){
                      return "Usianze na sifuri.";
                    }

                    return null;
                  },

                  onChanged: (val){
                    setState(() {
                      _price = val;
                    });
                  },
                ),

                SizedBox(
                  height: sizedHeight,
                ),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  maxLines: 7,

                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.note),

                    labelText: "Description",

                    contentPadding: EdgeInsets.only(
                      left: 10.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )
                    ),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )
                    ),

                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: Colors.red,
                        )
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )
                    ),
                  ),

                  onChanged: (val){
                    setState(() {
                      _description = val;
                    });
                  },
                ),

                SizedBox(
                  height: sizedHeight,
                ),

                ElevatedButton(
                  style: btnStyle,

                  child: Text("Sajili"),

                  onPressed: () async {
                    if(widget._productKey.currentState!.validate()){
                      setState(() {
                        _isLoading = true;
                      });

                      await _registerProduct();

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

      ],
    );
  }
}
