import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*Error messages*/
const String errorMsg = "Kuna tatizo, tafadhali wasiliana na mtaalamu.";

//Decorations
const double borderRadius = 20.0;
const double formMargin   = 20.0;
const double formPadding  = 10.0;

/*Sized Box Constraint*/
const sizedHeight         = 10.0;
const sizedWidth          = 10.0;

const headFontSize        = 24.0;
const blurRadius          = 5.0;
const spreadRadius        = 5.0;
const contBorderRadius    = 10.0; //Container border radius
/*Cards Constraints*/
const cardsElevation      = 5.0;
const cardsMargin         = 10.0;
const cardsPadding        = 10.0;
const topBarElevation     = 0.0;

//Colors
const Color errorColor = Colors.red;
const Color headColor = Colors.green;
const Color boxShadowColor = Colors.lightGreenAccent;
const Color textColor = Colors.white;
const Color btnTxtColors = Colors.white;
const Color themeColor = Colors.lightGreen;

//Connections
/*Connection address*/
const String host = "192.168.43.207";

const String location = "http://$host/projects/business_tracker";

/*Invoices*/
/*Update invoice*/
const String updateInvoiceLink = "$location/update_invoice.php";
/*Invoices List Link*/
const String invoicesLink = "$location/get_invoices.php";
/*Creates an Invoice record*/
const String createInvoiceLink = "$location/create_invoice.php";

/*Sales*/
/*Sales List Link*/
const String salesLink = "$location/get_sales.php";
const String addSalesLink = "$location/add_sales.php";


/*Purchases*/
/*Purchases List Link*/
const String purchasesLink = "$location/get_purchases.php";
/*Purchases Add Link*/
const String purchaseAddLink = "$location/add_purchase.php";


/*Products*/
/*Products List Link*/
const String productsLink = "$location/get_products.php";
/*Product registration link*/
const String prodRegLink = "$location/register_products.php";


/*Login link*/
const String loginLink = "$location/login.php";
/*Registration link*/
const String regLink = "$location/register.php";
/*Users counter link*/
const String usrCounterLink = "$location/user_counter.php";
/*Finalize registration*/
const String finishRegLink = "$location/finalize_reg.php";

final namesValidators = (val){
  if(val == ""){
    return "Tafadhali jaza kwa herufi.";
  } else if(!val!.startsWith(RegExp(r"[A-Z]"))){
    return "Tafadhali anza na herufi kubwa.";
  }

  return null;
};

final namesFormatters = [
  FilteringTextInputFormatter.allow(RegExp(r"(\w)")),
  FilteringTextInputFormatter.deny(RegExp(r"\d")),
  FilteringTextInputFormatter.deny(RegExp(r"_")),
];

// SnackBar snack_bar = SnackBar(
//       content: Text(this.msg),
//
//       action: SnackBarAction(
//         label: "Ok",
//
//         onPressed: (){
//           Navigator.of(context).pop();
//         },
//       ),
//     );

/*Button Styles*/
final btnStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
);

/*Table Border*/
final tableBorderDeco = BorderSide(
color: Colors.black
);

/*Input Field Decorations*/
final inputDecoration = InputDecoration(
  contentPadding: EdgeInsets.only(
    left: 10.0,
  ),

  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: BorderSide(
      color: Colors.black,
    )
  ),

  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: Colors.black,
      )
  ),

  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: Colors.red,
      )
  ),

  focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: Colors.black,
      )
  ),
);