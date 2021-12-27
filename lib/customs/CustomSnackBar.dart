import 'package:flutter/material.dart';

class CustomSnackBar{
  final String msg;
  CustomSnackBar({required this.msg});

  SnackBar getSnackBar(BuildContext context){
    return SnackBar(
      content: Text(this.msg),

      // action: SnackBarAction(
      //   label: "Ok",
      //
      //   onPressed: (){
      //     Navigator.of(context).pop();
      //   },
      // ),
    );
  }
}