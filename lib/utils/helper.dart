import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:nb_posx/core/mobile/create_order_new/ui/new_create_order.dart';
import 'package:nb_posx/core/mobile/parked_orders/ui/orderlist_screen.dart';
import 'package:nb_posx/database/models/park_order.dart';

import '../configs/theme_config.dart';
import '../constants/app_constants.dart';
import '../core/mobile/home/ui/home.dart';
import '../database/db_utils/db_constants.dart';
import '../database/db_utils/db_preferences.dart';
import '../database/models/hub_manager.dart';
import '../database/models/order_item.dart';
import '../widgets/popup_widget.dart';
import 'ui_utils/padding_margin.dart';
import 'ui_utils/text_styles/custom_text_style.dart';

class Helper {
  static HubManager? hubManager;
  static ParkOrder? activeParkedOrder;

  ///
  /// convert double amount value into currency type with 2 decimal places
  /// returns a string value to be used in UI
  ///
  String formatCurrency(double amount) {
    var currencyFormatter = NumberFormat("###0.00", "en_US");
    return currencyFormatter.format(amount);
  }

  double getTotal(List<OrderItem> orderedProducts) {
    double totalAmount = 0.0;
    orderedProducts.forEach((product) {
      totalAmount =
          totalAmount + (product.orderedPrice * product.orderedQuantity);
    });
    return totalAmount;
  }

  ///Function to check internet connectivity in app.
  static Future<bool> isNetworkAvailable() async {
    //Checking for the connectivity
    var connection = await Connectivity().checkConnectivity();

    //If connected to mobile data or wifi
    if (connection == ConnectivityResult.mobile ||
        connection == ConnectivityResult.wifi) {
      //Returning result as true
      return true;
    } else {
      //Returning result as false
      return false;
    }
  }

  static void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: leftSpace(x: 15),
              child: Text(PLEASE_WAIT_TXT,
                  style: getTextStyle(
                      fontSize: MEDIUM_MINUS_FONT_SIZE,
                      fontWeight: FontWeight.normal))),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  //Function to show the snackbar messages on UI.
  static showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
      style: getTextStyle(
          fontSize: MEDIUM_MINUS_FONT_SIZE,
          fontWeight: FontWeight.normal,
          color: WHITE_COLOR),
    ));
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar)
        .closed
        .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  }

  //Function to show the popup with one button with on pressed functionality to close popup.
  static showPopup(BuildContext context, String message) async {
    await showGeneralDialog(
        context: context,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return SizedBox(
            height: 100,
            child: SimplePopup(
              message: message,
              buttonText: OPTION_OK.toUpperCase(),
              onOkPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  //Function to show the popup with one button with on pressed functionality to close popup.
  static Future showConfirmationPopup(
      BuildContext context, String message, String btnTxt,
      {bool hasCancelAction = false}) async {
    var popup = await showGeneralDialog(
        context: context,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return SizedBox(
            height: 100,
            child: SimplePopup(
              message: message,
              buttonText: btnTxt,
              hasCancelAction: hasCancelAction,
              onOkPressed: () {
                Navigator.pop(context, btnTxt.toLowerCase());
              },
            ),
          );
        });
    return popup;
  }

  ///Function to fetch the image bytes from image url.
  static Future<Uint8List> getImageBytesFromUrl(String imageUrl) async {
    /* try {
      http.Response imageResponse = await http.get(
        Uri.parse(imageUrl),
      );
      log('Image data Response :: $imageResponse');
      return imageResponse.bodyBytes;
    } catch (e) {
      log('Exception occurred during image bytes fetching :: $e');
      return Uint8List.fromList([]);
    } */
    try {
      final ByteData imageData =
          await NetworkAssetBundle(Uri.parse(imageUrl)).load('');

      // log('Image : $imageData');

      final Uint8List bytes = imageData.buffer.asUint8List();

      return bytes;
    } catch (e) {
      log('Exception occurred during image bytes fetching :: $e');
      return Uint8List.fromList([]);
    }
  }

  ///ONLY FOR LOGGING PURPOSE - Function to print the JSON object in logs in proper format.
  ///[data] -> Decoded JSON body
  static printJSONData(var data) {
    final prettyString = const JsonEncoder.withIndent(' ').convert(data);
    log(prettyString);
  }

  static String getCurrentDateTime() {
    return DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
  }

  static String getCurrentDate() {
    return DateFormat("yyyy-MM-dd").format(DateTime.now());
  }

  static String getCurrentTime() {
    return DateFormat("HH:mm").format(DateTime.now());
  }

  static String getFormattedDateTime(DateTime dateTime) {
    return DateFormat('EEEE, d MMM yyyy, h:mm a').format(dateTime);
  }

  static Future<String> getOrderId() async {
    NumberFormat numberFormat = NumberFormat("0000");
    DateTime currentDateTime = DateTime.now();
    String orderNo = await DBPreferences().getPreference(CURRENT_ORDER_NUMBER);
    if (orderNo.isEmpty) orderNo = "1";
    String orderSeries = await DBPreferences().getPreference(SalesSeries);
    String orderId = orderSeries
        .replaceAll(".YYYY.", "${currentDateTime.year}")
        .replaceAll(".MM.", "${currentDateTime.month}")
        .replaceAll(".####", numberFormat.format(int.parse(orderNo)));

    return orderId;
  }

  static String getTime(String time) {
    List<String> splittedString = time.split(':');

    String temp = splittedString[0];

    if (temp.length == 1) {
      temp = "0$temp";

      splittedString.removeAt(0);
      splittedString.insert(0, temp);

      String finalTime = splittedString.join(':');

      return finalTime;
    } else {
      return time;
    }
  }

  static Color getPaymentStatusColor(String paymentStatus) {
    if (paymentStatus == "Unpaid") {
      return Colors.red;
    } else if (paymentStatus == "Paid") {
      return GREEN_COLOR;
    } else {
      return MAIN_COLOR;
    }
  }

  ///Siddhant : Commented code, as GetMaterialApp from GetX state management is not the root.
  ///
  // static List<Map> getMenuItemList() {
  //   List<Map> menuItems = [];
  //   Map<String, dynamic> homeMenu = {
  //     "title": "Home",
  //     "action": () {
  //       Get.offAll(() => const Home());
  //     }
  //   };
  //   Map<String, dynamic> createOrderMenu = {
  //     "title": "Create new sale",
  //     "action": () {
  //       Get.offAll(NewCreateOrder(), arguments: "create_new_order");
  //     }
  //   };
  //   Map<String, dynamic> parkOrderMenu = {
  //     "title": "Parked orders",
  //     "action": () {
  //       Get.offAll(const OrderListScreen(), arguments: "parked_order");
  //     }
  //   };
  //   menuItems.add(createOrderMenu);
  //   menuItems.add(parkOrderMenu);
  //   menuItems.add(homeMenu);
  //   return menuItems;
  // }

  static List<Map> getMenuItemList(BuildContext context) {
    List<Map> menuItems = [];
    Map<String, dynamic> homeMenu = {
      "title": "Home",
      "action": () {
        //Get.offAll(() => const Home());
        Navigator.push(
            // ignore: prefer_const_constructors
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    };
    Map<String, dynamic> createOrderMenu = {
      "title": "Create new sale",
      "action": () {
        //Get.offAll(NewCreateOrder(), arguments: "create_new_order");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NewCreateOrder()));
      }
    };
    Map<String, dynamic> parkOrderMenu = {
      "title": "Parked orders",
      "action": () {
        //Get.offAll(const OrderListScreen(), arguments: "parked_order");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NewCreateOrder()));
      }
    };
    menuItems.add(createOrderMenu);
    menuItems.add(parkOrderMenu);
    menuItems.add(homeMenu);
    return menuItems;
  }

  static void activateParkedOrder(ParkOrder parkedOrder) {
    activeParkedOrder = parkedOrder;
  }
}
