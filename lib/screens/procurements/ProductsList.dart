import 'package:business_tracker/customs/DefaultPage.dart';
import 'package:business_tracker/customs/LoadingWidget.dart';
import 'package:business_tracker/database/streams.dart';
import 'package:business_tracker/shared/Methods.dart';
import 'package:business_tracker/shared/constants.dart';
import 'package:flutter/material.dart';

class ProductsList extends StatefulWidget {
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {

  @override
  Widget build(BuildContext context) {
    Methods.getProducts();

    return StreamBuilder<List>(
      stream: productsStream.stream,

      builder: (context, snapShot){
        if(snapShot.hasData){
          return (snapShot.requireData.length < 1)?LoadingWidget("Hakuna bidhaa."):
          GridView.builder(
            physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()
            ),

            padding: EdgeInsets.only(
              top: 10.0,
            ),

            itemCount: snapShot.requireData.length,

            itemBuilder: (context, item){
              return Container(
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

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Product:"+snapShot.data![item]['productName']
                    ),
                    Text(
                        "Description:"+snapShot.data![item]['description']
                    ),
                    Text(
                        "Price:"+snapShot.data![item]['price']+" TZS"
                    ),
                    Text(
                        "Quantity:"+snapShot.data![item]['quantity']
                    ),
                  ],
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            mainAxisSpacing: 20.0,
          ),
          );
        } else if(snapShot.hasError){
          return Text("Error:${snapShot.error}",);
        }

        return LoadingWidget("Hakuna bidhaa.");
      },
    );
  }
}
