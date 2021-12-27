import 'dart:convert';
import 'package:business_tracker/customs/CustomSnackBar.dart';
import 'package:business_tracker/customs/LoadingWidget.dart';
import 'package:business_tracker/database/streams.dart';
import 'package:business_tracker/models/Sale.dart';
import 'package:business_tracker/models/User.dart';
import 'package:business_tracker/shared/Methods.dart';
import 'package:business_tracker/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class DeliveryNote extends StatefulWidget {
  const DeliveryNote({Key? key}) : super(key: key);

  @override
  _DeliveryNoteState createState() => _DeliveryNoteState();
}

class _DeliveryNoteState extends State<DeliveryNote>{

  bool _canSave = false;
  bool _isLoading = false;
  bool viewProforma = false;//We set it to false because initially we show adding items to proforma
  String proformaBtnTxt = "Angalia Profoma";
  List<Sale> sales = [];

  String invoiceId = "";

  void addSale(Map<String, dynamic> body) async {
    try{
      var url = Uri.parse(addSalesLink);

      var response = await http.post(url, body: body,);
      print(json.decode(response.body));
    }catch($e){
      print($e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoicesListHeight  = MediaQuery.of(context).size.height*0.25;
    final salesViewHeight     = MediaQuery.of(context).size.height*0.40;

    Methods.getProducts();

    return StreamBuilder<List>(
      stream: productsStream.stream,

      builder: (context, products){
        if(products.hasData){
          Methods.getInvoices("invoice");

          return (_isLoading)?LoadingWidget("Inahifadhi, tafadhali subiri."):
          Container(
            margin: EdgeInsets.all(5.0),
            child: StreamBuilder<List>(
              stream: invoicesStream.stream,

              builder: (context, invoices){
                if(invoices.hasData){
                  if(invoices.requireData.length < 1){
                    return LoadingWidget("Hakuna ankara.");
                  }else{
                    if(invoices.data!.length > 0)
                      Methods.getSales(invoices.data!.elementAt(0)['id']);

                    return Column(
                      children: [
                        /*Invoices*/
                        Container(
                          height: invoicesListHeight,

                          margin: EdgeInsets.all(
                              10.0
                          ),

                          child: ListView.builder(
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()
                            ),

                            scrollDirection: Axis.horizontal,
                            itemCount: invoices.requireData.length,

                            itemBuilder: (context, item){

                              return GestureDetector(
                                onTap: (){
                                  Methods.getSales(invoices.data!.elementAt(item)['id']);
                                },

                                child: Container(
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

                                  margin: EdgeInsets.all(
                                      formMargin
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
                                          "Namba ya Mauzo: "+invoices.data![item]['id']
                                      ),
                                      Text(
                                          "Mteja: "+invoices.data![item]['customerId']
                                      ),
                                      Text(
                                          "Muda: "+invoices.data![item]['createdAt']
                                      ),
                                      (User.getRoleId() != "RL3" )?
                                      TextButton(
                                        child: Text(
                                            "Kubali"
                                        ),

                                        onPressed: (){
                                          print("accepted");
                                        },
                                      ):SizedBox(height: 0.0, width: 0.0,),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        /*Sales*/
                        Container(
                          height: salesViewHeight,

                          child: StreamBuilder<List>(
                            stream: salesStream.stream,

                            builder: (context, sales){
                              if(sales.hasData){

                                return ListView(

                                  children: [
                                    DataTable(
                                      horizontalMargin: 1.0,

                                      columnSpacing: 50.0,

                                      columns: <DataColumn>[
                                        DataColumn(
                                          label: Text(
                                              "Idadi"
                                          ),
                                        ),

                                        DataColumn(
                                          label: Text(
                                              "Maelezo"
                                          ),
                                        ),

                                        DataColumn(
                                          label: Text(
                                              "Bei"
                                          ),
                                        ),

                                        DataColumn(
                                          label: Text(
                                              "Kiasi"
                                          ),
                                        )
                                      ],

                                      rows: sales.requireData.map((sale) {
                                        String productName = "No name was assigned.";

                                        products.requireData.map((product){
                                          if(product['id'] == sale['productId']){
                                            productName = product['productName'];
                                          }
                                        }).toList();

                                        return DataRow(
                                          cells: <DataCell>[
                                            DataCell(
                                              Text(
                                                  sale['quantity']
                                              ),
                                            ),

                                            DataCell(
                                              Text(
                                                  productName
                                              ),
                                            ),

                                            DataCell(
                                              Text(
                                                  sale['cost']
                                              ),
                                            ),

                                            DataCell(
                                              Text(
                                                  (int.parse(sale['cost'])*int.parse(sale['quantity'])).toString()
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                );
                              } else if(sales.hasError){
                                return Text(
                                  "Error: "+invoices.error.toString(),
                                  style: TextStyle(
                                    color: errorColor,
                                  ),
                                );
                              }

                              return LoadingWidget("Hakuna mauzo.");
                            },
                          ),
                        ),
                      ],
                    );
                  }

                } else if(invoices.hasError){
                  return Text(
                    "Error: "+invoices.error.toString(),
                    style: TextStyle(
                      color: errorColor,
                    ),
                  );
                }

                return LoadingWidget(
                    "Hakuna ankara."
                );
              },
            ),
          );
        }else if(products.hasError){
          return Text(
            "Error:"+products.error.toString(),
            style: TextStyle(
              color: errorColor,
            ),
          );
        }

        return LoadingWidget(
            "Hakuna bidhaa."
        );
      },
    );
  }
}