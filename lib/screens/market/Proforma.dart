import 'dart:convert';
import 'package:business_tracker/customs/CustomSnackBar.dart';
import 'package:business_tracker/customs/LoadingWidget.dart';
import 'package:business_tracker/database/streams.dart';
import 'package:business_tracker/models/FeedBack.dart';
import 'package:business_tracker/models/Sale.dart';
import 'package:business_tracker/models/User.dart';
import 'package:business_tracker/shared/Methods.dart';
import 'package:business_tracker/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Proforma extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  Proforma({required this.scaffoldKey});

  @override
  _ProformaState createState() => _ProformaState();
}

class _ProformaState extends State<Proforma>{

  bool _canSave = false;
  bool _isLoading = false;
  bool viewProforma = false;//We set it to false because initially we show adding items to proforma
  String proformaBtnTxt = "Angalia Profoma";
  List<TextEditingController> qtyControllers = [];
  List<Sale> sales = [];

  String invoiceId = "";

  Future<void> updateInvoice(String type, String invoiceId) async {
    try{
      var url = Uri.parse(updateInvoiceLink+"?type=$type&invoice_id=$invoiceId");

      var response = await http.post(url);

      if(response.body == "true"){
        feedBack = {
          "hasError": false,
          "msg": "Imefanikiwa.",
        };
      }else{
        feedBack = {
          "hasError": true,
          "msg": response.body,
        };
      }
    }catch($e){
      print($e.toString());
      feedBack = {
        "hasError": true,
        "msg": "Kuna shida, tafadhali wasiliana na mtaalamu.",
      };
    }
  }

  void addSale(Map<String, dynamic> body) async {
    try{
      var url = Uri.parse(addSalesLink);

      var response = await http.post(url, body: body,);
    }catch($e){
      print($e.toString());
      // FeedBack = {
      //   'hasError':true,
      //   'msg': $e.toString(),
      // };
    }
  }

  Future<void> _saveProforma(List<Sale> sales) async {
    try{
      var url = Uri.parse(createInvoiceLink);

      Map<String, dynamic> body = {
        'userId': User.getUserId(),
      };

      var response = await http.post(url, body: body);

      invoiceId = json.decode(response.body);

      for(Sale sale in sales){
        if(sale.getQuantity() > 0){
          Map<String, dynamic> body = {
            "productId": sale.getProductId(),
            "cost": sale.getCost().toString(),
            "quantity": sale.getQuantity().toString(),
            "invoiceId": invoiceId,
          };

          addSale(body);
        }
      }
    }catch($e){
      print($e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final qtyWidth            = MediaQuery.of(context).size.height*0.2;
    final invoicesListHeight  = MediaQuery.of(context).size.height*0.25;
    final salesViewHeight     = MediaQuery.of(context).size.height*0.35;
    final proformaHeight      = MediaQuery.of(context).size.height*0.65;

    Methods.getProducts();

    qtyControllers.clear();

    return StreamBuilder<List>(
      stream: productsStream.stream,

      builder: (context, products){
        if(products.hasData){
          Methods.getInvoices("proforma");

          if(!_isLoading){
            sales.clear();
            products.requireData.forEach((product){
              Sale sale = new Sale();

              sale.setProductId(product['id']);
              sale.setCost(double.parse(product['price']));
              sale.setQuantity(0);

              sales.add(sale);
            });
          }

          return (_isLoading)?LoadingWidget("Inalifanyia kazi, tafadhali subiri."):
          Container(
            margin: EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text(
                        proformaBtnTxt,
                        style: TextStyle(
                          color: btnTxtColors,
                        ),
                      ),

                      onPressed: (){
                        setState(() {
                          viewProforma = !viewProforma;
                          (viewProforma)?proformaBtnTxt="Tengeneza Profoma":proformaBtnTxt="Angalia Profoma";
                        });
                      },
                    ),

                    AnimatedOpacity(
                      opacity: (viewProforma)?0:1,
                      duration: Duration(
                        seconds: 1,
                      ),
                      child: ElevatedButton(
                        child: Row(
                          children: [
                            Icon(
                                Icons.save,
                              color: btnTxtColors,
                            ),

                            Text(
                              "Hifadhi",
                              style: TextStyle(
                                color: btnTxtColors,
                              ),
                            ),
                          ],
                        ),

                        onPressed: () async {
                          SnackBar snackBar = CustomSnackBar(msg: errorMsg).getSnackBar(context);

                          sales.forEach((sale) {
                            if(sale.getQuantity() > 0){
                              _canSave = true;
                            }
                          });

                          if(!_canSave){
                            snackBar = CustomSnackBar(msg: "Tafadhali weka idadi ya bidhaa.").getSnackBar(context);
                          }else{
                            setState(() {
                              _isLoading = true;
                            });

                            snackBar = CustomSnackBar(msg: "Imehifadhi kikamilifu.").getSnackBar(context);

                            await _saveProforma(sales);

                            setState(() {
                              _isLoading = false;
                              _canSave = false;
                            });
                          }

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                      ),
                    ),
                  ],
                ),

                Stack(
                  children: [
                    /*Create Proforma*/
                    Container(
                      height: proformaHeight,

                      child: AnimatedOpacity(
                        duration: Duration(seconds: 1),

                        opacity: (viewProforma)?0:1,

                        child: (products.requireData.length < 1)?LoadingWidget("Hakuna bidhaa."):
                        ListView.builder(
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()
                          ),

                          itemCount: products.requireData.length,

                          itemBuilder: (context, index) {
                            TextEditingController controller = TextEditingController();
                            qtyControllers.add(controller);
                            qtyControllers[index].text = sales.elementAt(index).getQuantity().toString();

                            return Card(
                              shadowColor: themeColor,
                              elevation: cardsElevation,
                              child: ListTile(
                                title: Text(
                                  products.requireData.elementAt(index)['productName'],
                                ),

                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Maelezo: "+products.data!.elementAt(index)['description'],
                                    ),
                                    Text(
                                      "Bei: "+products.data!.elementAt(index)['price'],
                                    ),
                                    Text(
                                      "Vilivyopo: "+products.data!.elementAt(index)['quantity'],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        //Left button
                                        IconButton(
                                          icon: Icon(Icons.arrow_left),
                                          onPressed: (){
                                            try{
                                              int value = (int.parse(qtyControllers[index].text)-1);

                                              if(value < 0){
                                                qtyControllers[index].text = "0";
                                              }else{
                                                qtyControllers[index].text = value.toString();
                                              }
                                              sales.elementAt(index).setQuantity(int.parse(qtyControllers[index].text));
                                            }catch($e){
                                              print($e.toString());
                                            }
                                          },
                                        ),

                                        //TextField
                                        Container(
                                          width: qtyWidth,
                                          child: TextFormField(
                                            decoration: inputDecoration,
                                            controller: qtyControllers[index],
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                      r'\d'
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),

                                        //Right button
                                        IconButton(
                                          icon: Icon(Icons.arrow_right),

                                          onPressed: (){
                                            try{
                                              int value = (int.parse(qtyControllers[index].text)+1);

                                              if(value > int.parse(products.data!.elementAt(index)['quantity'])){
                                                qtyControllers[index].text = products.data!.elementAt(index)['quantity'];
                                              }else{
                                                qtyControllers[index].text = value.toString();
                                              }
                                              sales.elementAt(index).setQuantity(int.parse(qtyControllers[index].text));
                                            }catch($e){
                                              print($e.toString());
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    /*View Proforma*/
                    AnimatedContainer(
                      duration: Duration(seconds: (viewProforma)?3:1,),
                      height: (viewProforma)?proformaHeight:0,

                      child: AnimatedOpacity(
                        duration: Duration(seconds: (viewProforma)?5:1),

                        opacity: (viewProforma)?1:0,

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
                                                  (User.getRoleId() == "RL1" || (User.getRoleId() != "RL1" && User.getUserId() == invoices.data![item]['customerId']))?
                                                  TextButton(
                                                    child: Text(
                                                      "Kubali"
                                                    ),

                                                    onPressed: () async {
                                                      SnackBar snackBar = CustomSnackBar(msg: errorMsg,).getSnackBar(context);
                                                      setState((){
                                                        _isLoading = true;
                                                      });

                                                      await updateInvoice("proforma", invoices.requireData[item]['id']);
                                                      snackBar = CustomSnackBar(msg: feedBack['msg']).getSnackBar(context);
                                                      widget.scaffoldKey.currentState!.showSnackBar(snackBar);

                                                      setState((){
                                                        _isLoading = false;
                                                      });
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

                                                        (User.getRoleId() != "RL3")?
                                                        DataCell(
                                                          Text(
                                                              sale['cost']
                                                          ),

                                                          onTap: (){

                                                          },

                                                          showEditIcon: true,
                                                        ):
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
                      ),
                    ),
                  ],
                ),
              ],
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