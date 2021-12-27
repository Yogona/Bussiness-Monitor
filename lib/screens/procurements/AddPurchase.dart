import 'dart:convert';
import 'package:business_tracker/customs/CustomSnackBar.dart';
import 'package:business_tracker/customs/LoadingWidget.dart';
import 'package:business_tracker/database/streams.dart';
import 'package:business_tracker/shared/Methods.dart';
import 'package:business_tracker/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AddPurchase extends StatefulWidget {
  final GlobalKey<FormState> _purchaseKey = GlobalKey<FormState>();

  @override
  _AddPurchaseState createState() => _AddPurchaseState();
}

class _AddPurchaseState extends State<AddPurchase> {
  bool _isLoading = false;
  String _productId = "";
  String _quantity = "";
  String _cost = "";

  Future<void> _addPurchase() async {
    Map<String, dynamic> _body = {
      "productId": _productId,
      "cost": _cost,
      "quantity": _quantity,
    };

    var url = Uri.parse(purchaseAddLink);
    var response = await http.post(url, body: _body,);
    SnackBar snackBar;
    if(json.decode(response.body) == "true"){
      snackBar = CustomSnackBar(msg: "Umeongeza manunuzi kikamilifu.") as SnackBar;
    }else{
      snackBar = CustomSnackBar(msg: json.decode(response.body)) as SnackBar;
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    Methods.getProducts();

    return (_isLoading)?LoadingWidget("Inalifanyia kazi, tafadhali subiri..."):
    ListView(
      children: [
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
            key: widget._purchaseKey,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                SizedBox(
                  height: sizedHeight,
                ),

                StreamBuilder<List>(
                  stream: productsStream.stream,

                  builder: (context, snapShot){
                    if(snapShot.hasData){
                      return DropdownButtonFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        decoration: inputDecoration.copyWith(
                          prefixIcon: Icon(Icons.widgets),
                          labelText: "Chagua bidhaa",
                          hintText: "Samaki",
                        ),

                        validator: (val){
                          if(val == null){
                            return "Tafadhali chagua bidhaa.";
                          }

                          return null;
                        },

                        items: snapShot.requireData.map((product) {
                          return DropdownMenuItem(
                            value: product['id'],

                            child: Text(
                              product['productName']+" - "+product['price']
                            ),
                          );
                        }).toList(),

                        onChanged: (val){
                          setState(() {
                            _productId = val.toString();
                          });
                        },
                      );
                    } else if(snapShot.hasError){
                      return Text(
                        "Error: "+snapShot.error.toString(),
                        style: TextStyle(
                          color: errorColor,
                        ),
                      );
                    }

                    return Text(
                        "Couldn't load products",
                      style: TextStyle(
                        color: errorColor,
                      ),
                    );
                  },
                ),

                SizedBox(
                  height: sizedHeight,
                ),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  decoration: inputDecoration.copyWith(
                    prefixIcon: Icon(Icons.money),

                    labelText: "Gharama",

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
                      _cost = val;
                    });
                  },
                ),

                SizedBox(
                  height: sizedHeight,
                ),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  decoration: inputDecoration.copyWith(
                    prefixIcon: Icon(Icons.production_quantity_limits),

                    labelText: "Idadi",

                    hintText: "10",
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
                      _quantity = val;
                    });
                  },
                ),

                SizedBox(
                  height: sizedHeight,
                ),

                ElevatedButton(
                  style: btnStyle,

                  child: Text("Hifadhi"),

                  onPressed: () async {
                    if(widget._purchaseKey.currentState!.validate()){
                      setState(() {
                        _isLoading = true;
                      });

                      await _addPurchase();

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