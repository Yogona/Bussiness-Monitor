import 'dart:async';
import 'dart:convert';
import 'package:business_tracker/database/streams.dart';
import 'package:business_tracker/shared/constants.dart';
import 'package:http/http.dart' as http;

Future getUserCounter() async {
  var userCounterUrl = Uri.parse(usrCounterLink);

  try{
    var response = await http.get(userCounterUrl);

    List data = json.decode(response.body);

    userCounterStream.add(data);
  }catch(e){
    print(e.toString());
  }
}