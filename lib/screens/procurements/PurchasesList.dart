import 'package:business_tracker/customs/LoadingWidget.dart';
import 'package:business_tracker/database/streams.dart';
import 'package:business_tracker/shared/Methods.dart';
import 'package:business_tracker/shared/constants.dart';
import 'package:flutter/material.dart';

class PurchasesList extends StatefulWidget {
  const PurchasesList({Key? key}) : super(key: key);

  @override
  _PurchasesListState createState() => _PurchasesListState();
}

class _PurchasesListState extends State<PurchasesList> {
  @override
  Widget build(BuildContext context) {
    Methods.getProducts();


    return StreamBuilder<List>(
      stream: productsStream.stream,
      builder: (context, products){
        Methods.getPurchases();

        if(products.hasData){
          return StreamBuilder<List>(
            stream: purchasesStream.stream,

            builder: (context, purchases){
              if(purchases.hasData){
                return (purchases.requireData.length < 1)?LoadingWidget("Hakuna manunuzi."):
                ListView.builder(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()
                  ),

                  itemCount: purchases.requireData.length,

                  itemBuilder: (context, index){
                    String productName = "No name was assigned.";

                    for(var product in products.requireData){
                      if(product['id'] == purchases.requireData.elementAt(index)['productId']){
                        productName = product['productName'];
                        break;
                      }
                    }

                    return Card(
                      margin: EdgeInsets.all(cardsMargin),
                      shadowColor: boxShadowColor,
                      elevation: cardsElevation,
                      child: Container(
                        padding: EdgeInsets.all(cardsPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Jina la Bidhaa: $productName",
                            ),
                            Text(
                              "Kiasi: ${purchases.data!.elementAt(index)['quantity']}",
                            ),
                            Text(
                              "Gharama: ${purchases.data!.elementAt(index)['cost']}",
                            ),
                            Text(
                              "Muda: ${purchases.data!.elementAt(index)['createdAt']}",
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }else if(purchases.hasError){
                return Text(
                  "Error:"+purchases.error.toString(),
                  style: TextStyle(
                    color: errorColor,
                  ),
                );
              }

              return LoadingWidget("Hakuna manunuzi.");
            },
          );


        }else if(products.hasError){
          return Text(
            "Error: ${products.error}",
            style: TextStyle(
              color: Colors.red,
            ),
          );
        }
        return LoadingWidget("Hakuna bidhaa.");
      },
    );


  }
}