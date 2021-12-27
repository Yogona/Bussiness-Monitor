import 'dart:convert';
import 'package:business_tracker/database/streams.dart';
import 'package:business_tracker/models/FeedBack.dart';
import 'package:business_tracker/models/User.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;

class Methods{
  static String procurementTitle = "Ongeza Bidhaa";

  static Future<void> getSales(String invoiceId) async {
    try{
      var url = Uri.parse(salesLink+"?invoice_id=$invoiceId");
      var response = await http.get(url);
      var sales = json.decode(response.body);

      salesStream.add(sales);

      feedBack = {
        "hasError": false,
        "msg": "Imefanikiwa",
      };

    }catch($e){
      print($e.toString());
      feedBack = {
        "hasError": true,
        "msg": $e.toString(),
      };
    }
  }

  static Future<void> getInvoices(String type) async {
    try{
      var url = (User.getRoleId() != "RL3")?
      Uri.parse(invoicesLink+"?user_id=all&type=$type"):
      Uri.parse(invoicesLink+"?user_id=${User.getUserId()}&type=$type");

      var response = await http.get(url);
      var invoices = json.decode(response.body);

      invoicesStream.add(invoices);
      feedBack = {
        "hasError": false,
        "msg": "Imefanikiwa",
      };

    }catch($e){
      print($e.toString());
    }
  }

  static Future<void> getProducts() async {
    try{
      var url = Uri.parse(productsLink);
      var response = await http.get(url);
      var products = json.decode(response.body);

      productsStream.add(products);

      feedBack = {
        "hasError": false,
        "msg": "Imefanikiwa",
      };
    }catch($e){
      print($e.toString());
      feedBack = {
        "hasError": true,
        "msg": $e.toString(),
      };
    }
  }

  static Future<void> getPurchases() async {
    var url = Uri.parse(purchasesLink);

    try{
      var response = await http.get(url);
      var purchases = json.decode(response.body);

      purchasesStream.add(purchases);
      feedBack = {
        "hasError": false,
        "msg": "Imefanikiwa",
      };
    }catch($e){
      print($e.toString());
      feedBack = {
        "hasError": true,
        "msg": $e.toString(),
      };
    }
  }
}
