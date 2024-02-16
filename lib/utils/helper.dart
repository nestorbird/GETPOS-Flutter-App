import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/core/mobile/create_order_new/ui/new_create_order.dart';
import 'package:nb_posx/database/models/park_order.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';

import '../constants/app_constants.dart';
import '../core/mobile/home/ui/home.dart';
import '../database/db_utils/db_constants.dart';
import '../database/db_utils/db_preferences.dart';
import '../database/models/hub_manager.dart';
import '../database/models/order_item.dart';
import '../database/models/sale_order.dart';
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
    for (var product in orderedProducts) {
      totalAmount =
          totalAmount + (product.orderedPrice * product.orderedQuantity);
    }
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
          color: AppColors.fontWhiteColor),
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

  //FIXME:: Fix the width of the popup for tablet here
  //Function to show the popup with one button with on pressed functionality to close popup.
  static showPopupForTablet(BuildContext context, String message) async {
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
            child: Padding(
              padding: const EdgeInsets.only(left: 400, right: 400),
              child: SimplePopup(
                message: message,
                buttonText: OPTION_OK.toUpperCase(),
                onOkPressed: () {
                  Navigator.pop(context);
                },
              ),
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
            height: 80,
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
    NumberFormat numberFormat = NumberFormat("00000");
    DateTime currentDateTime = DateTime.now();
    String orderNo = await DBPreferences().getPreference(CURRENT_ORDER_NUMBER);
    log('Order No::$orderNo');
    if (orderNo.isEmpty) {
      orderNo = "1";
      await DBPreferences().savePreference(CURRENT_ORDER_NUMBER, orderNo);
    }
    //  else {
    //  // orderNo = (int.parse(orderNo) + 1).toString();
    //  // await DBPreferences().savePreference(CURRENT_ORDER_NUMBER, orderNo);
    // }
    String orderSeries = await DBPreferences().getPreference(SalesSeries);
    print("ORDER SERIES :: $orderSeries");
    String orderId = orderSeries
        .replaceAll("YYYY", "${currentDateTime.year}")
        .replaceAll("MM", "${currentDateTime.month}")
        .replaceAll("#####", numberFormat.format(int.parse(orderNo)));
    print("NEXT ORDER NUMBER :: $orderId");
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
      return const Color(0xFF62B146);
    } else {
      return const Color(0xFFDC1E44);
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
            context,
            MaterialPageRoute(builder: (context) => const Home()));
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

  ///Function to check whether the input URL is valid or not
  static bool isValidUrl(String url) {
    // Regex to check valid URL
    String regex =
        "((http|https)://)(www.)?[a-zA-Z0-9@:%._\\+~#?&//=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%._\\+~#?&//=]*)";

    return RegExp(regex).hasMatch(url);
  }

  //TODO:: Need to handle the print receipt here
  ///Helper method to print the invoice in PDF format and through printer device.
  Future<bool> printInvoice(SaleOrder placedOrder) async {
    // final doc = pw.Document(
    //     pageMode: PdfPageMode.thumbs,
    //     title: "Invoice ${placedOrder.parkOrderId}");

    // doc.addPage(pw.Page(
    //     pageFormat: PdfPageFormat.roll57,
    //     build: ((context) => pw.Container(
    //         color: PdfColors.amber,
    //         child: pw.Center(
    //             child: pw.Column(children: [
    //           _getInvoiceItem('Date & Time', placedOrder.date),
    //           _getInvoiceItem('Customer Name', placedOrder.customer.name),
    //           _getInvoiceItem('Name', placedOrder.customer.name),
    //           _getInvoiceItem('Phone', placedOrder.customer.phone),
    //           _getInvoiceItem('Email', placedOrder.customer.email),
    //           _getInvoiceItem('Order ID', placedOrder.parkOrderId!),
    //           _getInvoiceItem(
    //               'Order Amount', placedOrder.orderAmount.toString()),
    //           pw.Text('Item(s) Summary'),
    //           pw.ListView.builder(
    //               itemCount: placedOrder.items.length,
    //               itemBuilder: ((context, index) => _getInvoiceItem(
    //                   placedOrder.items[index].name,
    //                   placedOrder.items[index].orderedPrice.toString()))),
    //         ]))))));

    // return await Printing.layoutPdf(
    //     name: 'Invoice ${placedOrder.parkOrderId}',
    //     format: PdfPageFormat.roll57,
    //     usePrinterSettings: true,
    //     onLayout: (PdfPageFormat format) async => doc.save());

    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res =
        await printer.connect('192.168.0.123', port: 9100);

    if (res == PosPrintResult.success) {
      final ByteData data = await rootBundle.load('assets/images/app_logo.png');
      final Uint8List bytes = data.buffer.asUint8List();
      final img.Image? image = img.decodeImage(bytes);

      printer.imageRaster(image!, imageFn: PosImageFn.graphics);
      printer.text('Prop: NestorBird Ltd.',
          styles: const PosStyles(fontType: PosFontType.fontA, bold: true));
      printer.text('49, Cumberland Drive, Flagstaff, Hamilton 3219',
          styles: const PosStyles(fontType: PosFontType.fontA, bold: true));
      printer.text('---------------------------------',
          styles: const PosStyles(align: PosAlign.center, bold: true));
      printer.text('Invoice', styles: const PosStyles(align: PosAlign.center));
      printer.text('---------------------------------',
          styles: const PosStyles(align: PosAlign.center, bold: true));
      printer.text('Order ID: ${placedOrder.parkOrderId}',
          styles: const PosStyles(fontType: PosFontType.fontA));
      printer.text('Invoice Date: ${placedOrder.tracsactionDateTime}',
          styles: const PosStyles(fontType: PosFontType.fontA));
      printer.text('Customer Name: ${placedOrder.customer.name}',
          styles: const PosStyles(fontType: PosFontType.fontA));
      printer.text('Customer Contact: ${placedOrder.customer.phone}',
          styles: const PosStyles(fontType: PosFontType.fontA));
      printer.text('Customer Email: ${placedOrder.customer.email}',
          styles: const PosStyles(fontType: PosFontType.fontA));
      printer.text('Customer Name: ${placedOrder.customer.name}',
          styles: const PosStyles(fontType: PosFontType.fontA));
      printer.text('---------------------------------',
          styles: const PosStyles(align: PosAlign.center, bold: true));

      PosColumn(
        text: "Item(s)",
        width: 6,
        styles: const PosStyles(align: PosAlign.left, underline: true),
      );

      PosColumn(
        text: "Qty",
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      );

      PosColumn(
        text: "Amount",
        width: 3,
        styles: const PosStyles(align: PosAlign.right, underline: true),
      );

      printer.text('---------------------------------',
          styles: const PosStyles(align: PosAlign.center, bold: true));

      for (var item in placedOrder.items) {
        printer.row([
          PosColumn(
            text: item.name,
            width: 6,
            styles: const PosStyles(align: PosAlign.left, underline: true),
          ),
          PosColumn(
            text: item.orderedQuantity.toString(),
            width: 6,
            styles: const PosStyles(align: PosAlign.center, underline: true),
          ),
          PosColumn(
            text: item.orderedPrice.toString(),
            width: 6,
            styles: const PosStyles(align: PosAlign.right, underline: true),
          )
        ]);
      }

      printer.row([
        PosColumn(
          text: 'Total',
          width: 6,
          styles: const PosStyles(align: PosAlign.left, underline: true),
        ),
        PosColumn(
          text: placedOrder.orderAmount.toString(),
          width: 6,
          styles: const PosStyles(align: PosAlign.right, underline: true),
        )
      ]);

      printer.text('Remarks: ________________________________');

      printer.text('For suggestions/complaint write us on: info@nestorbird.com',
          styles: const PosStyles(bold: true));

      printer.qrcode(instanceUrl);

      printer.text('Cashier: ${placedOrder.manager.name}');
      printer.disconnect();
      log('Print result: ${res.msg}');
      return true;
    } else {
      log('Print result: ${res.msg}');
      return false;
    }
  }

  ///Private helper method to display the item content of invoice
  // _getInvoiceItem(String keyName, String dataValue) {
  //   return pw.Row(
  //       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //       children: [pw.Text(keyName), pw.Text(dataValue)]);
  // }
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext getContext() {
    return navigatorKey.currentContext!;
  }
}
