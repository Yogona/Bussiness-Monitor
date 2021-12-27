import 'package:business_tracker/screens/procurements/ProductsList.dart';
import 'package:business_tracker/screens/procurements/PurchasesList.dart';
import 'package:business_tracker/shared/Methods.dart';
import 'package:business_tracker/shared/constants.dart';
import 'package:flutter/material.dart';

import '../procurements/AddPurchase.dart';
import '../procurements/RegisterProduct.dart';

class Procurements extends StatefulWidget {
  const Procurements({Key? key}) : super(key: key);

  @override
  _ProcurementsState createState() => _ProcurementsState();
}

class _ProcurementsState extends State<Procurements> {
  String _title = "Ongeza Bidhaa";
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 4,

      child: Scaffold(
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
            RegisterProduct(),
            ProductsList(),
            AddPurchase(),
            PurchasesList(),
          ],
        ),

        bottomNavigationBar: TabBar(
          indicatorColor: themeColor,

          onTap: (val){
            if(val == 0){
              setState(() {
                _title = "Sajili Bidhaa";
              });
            } else if(val == 1){
              setState(() {
                _title = "Duka";
              });
            } else if(val == 2){
              setState(() {
                _title = "Hifadhi Manunuzi";
              });
            } else{
              setState(() {
                _title = "Tazama Manunuzi";
              });
            }
          },

          tabs: [
            Tab(
              text: "Sajili",
              icon: Icon(Icons.add_business_outlined),
            ),
            Tab(
              text: "Duka",
              icon: Icon(Icons.view_in_ar),
            ),
            Tab(
              text: "Hifadhi",
              icon: Icon(Icons.add_shopping_cart_outlined),
            ),
            Tab(
              text: "Tazama",
              icon: Icon(Icons.view_agenda_outlined),
            )
          ],
        ),
      ),
    );
  }
}

