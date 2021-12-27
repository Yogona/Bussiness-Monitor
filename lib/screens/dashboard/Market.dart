import 'package:business_tracker/models/User.dart';
import 'package:business_tracker/screens/market/DeliveryNote.dart';
import 'package:business_tracker/screens/market/Invoice.dart';
import 'package:business_tracker/screens/market/Proforma.dart';
import 'package:business_tracker/screens/procurements/ProductsList.dart';
import 'package:business_tracker/screens/procurements/PurchasesList.dart';
import 'package:business_tracker/shared/constants.dart';
import 'package:flutter/material.dart';

import '../procurements/AddPurchase.dart';
import '../procurements/RegisterProduct.dart';

class Market extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  String _title = "Profoma";
  @override
  Widget build(BuildContext context) {

    return (User.getRoleId() != "RL3")?DefaultTabController(
      length: 4,

      child: Scaffold(
        key: widget._scaffoldKey,
        appBar: AppBar(
          title: Text(
            _title,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),

        body: TabBarView(
          children: [
            Proforma(scaffoldKey: widget._scaffoldKey,),
            Invoice(),
            DeliveryNote(),
            PurchasesList(),
          ],
        ),

        bottomNavigationBar: TabBar(
          indicatorColor: themeColor,

          onTap: (val){
            if(val == 0){
              setState(() {
                _title = "Profoma";
              });
            } else if(val == 1){
              setState(() {
                _title = "Ankara";
              });
            } else if(val == 2){
              setState(() {
                _title = "Noti ya Uwasilishaji";
              });
            } else{
              setState(() {
                _title = "Mauzo";
              });
            }
          },

          tabs: [
            Tab(
              text: "Profoma",
              icon: Icon(Icons.article),
            ),
            Tab(
              text: "Ankara",
              icon: Icon(Icons.assignment),
            ),
            Tab(
              text: "Uwasilishaji",
              icon: Icon(Icons.note),
            ),
            (User.getRoleId() != "RL3")?Tab(
              text: "Mauzo",
              icon: Icon(Icons.view_agenda_outlined),
            ):SizedBox(height: 0.0, width: 0.0,)
          ],
        ),
      ),
    ):
    DefaultTabController(
      length: 3,

      child: Scaffold(
        key: widget._scaffoldKey,
        appBar: AppBar(
          title: Text(
            _title,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),

        body: TabBarView(
          children: [
            Proforma(scaffoldKey: widget._scaffoldKey,),
            Invoice(),
            DeliveryNote(),
          ],
        ),

        bottomNavigationBar: TabBar(
          indicatorColor: themeColor,

          onTap: (val){
            if(val == 0){
              setState(() {
                _title = "Profoma";
              });
            } else if(val == 1){
              setState(() {
                _title = "Ankara";
              });
            } else if(val == 2){
              setState(() {
                _title = "Noti ya Uwasilishaji";
              });
            }
          },

          tabs: [
            Tab(
              text: "Profoma",
              icon: Icon(Icons.article),
            ),
            Tab(
              text: "Ankara",
              icon: Icon(Icons.assignment),
            ),
            Tab(
              text: "Uwasilishaji",
              icon: Icon(Icons.note),
            ),
          ],
        ),
      ),
    );
  }
}