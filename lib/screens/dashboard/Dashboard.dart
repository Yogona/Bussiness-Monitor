import 'package:business_tracker/models/User.dart';
import 'package:business_tracker/screens/dashboard/Procurements.dart';
import 'package:business_tracker/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Market.dart';

class Dashboard extends StatefulWidget {
  final Function toggleDashboard;
  Dashboard({required this.toggleDashboard});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    //We ask if it's not an admin so we can hide user management panel
    var isNotAdmin = (User.getRoleId() != "RL1");
    //We ask if it's a customer so we can hide purchases panel
    var isCustomer = (User.getRoleId() == "RL3");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style:  TextStyle(
            color: textColor,
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(
                Icons.account_box_outlined,
              color: textColor,
            ),

            onPressed: (){

            },
          ),

          IconButton(
            icon: Icon(
                Icons.logout,
              color: textColor,
            ),

            onPressed: (){
              setState(() {
                widget.toggleDashboard();
              });
            },
          )
        ],
      ),

      body: Column(
        // padding: EdgeInsets.all(formPadding),
        //
        // physics: BouncingScrollPhysics(
        //   parent: AlwaysScrollableScrollPhysics(),
        // ),
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          SizedBox(
            height: 50.0,
          ),

          //Users management
          isNotAdmin?SizedBox(height: 0,width: 0,):Container(
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

            child: ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return Procurements();
                  },
                ));
              },

              title: Text(
                "Ukurugenzi Watu",
                style: TextStyle(
                  color: headColor,
                ),
              ),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                      "Simamia Watu"
                  ),

                  Text(
                    "Duka",
                  )
                ],
              ),
            ),
          ),

          isNotAdmin?SizedBox(height: 0,width: 0,):SizedBox(
            height: 50.0,
          ),

          //Purchases management
          isCustomer?SizedBox(height: 0,width: 0,):Container(
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

            child: ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return Procurements();
                  },
                ));
              },

              title: Text(
                "Ununuzi",
                style: TextStyle(
                  color: headColor,
                ),
              ),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Sajili Bidhaa"
                  ),

                  Text(
                    "Duka",
                  ),

                  Text(
                    "Hifadhi Manunuzi",
                  ),

                  Text(
                    "Tazama Manunuzi",
                  )
                ],
              ),
            ),
          ),

          isCustomer?SizedBox(height: 0,width: 0,):SizedBox(
            height: 50.0,
          ),

          //Sales Management
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

            child: ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return Market();
                  },
                ));
              },

              title: Text(
                "Soko",
                style: TextStyle(
                  color: headColor,
                ),
              ),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                      "Profoma"
                  ),

                  Text(
                    "Ankara",
                  ),

                  Text(
                    "Noti ya Uwasilishaji",
                  ),

                  Text(
                    "Mauzo",
                  )
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
