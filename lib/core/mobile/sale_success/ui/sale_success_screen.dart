import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_posx/utils/helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/asset_paths.dart';
import '../../../../database/db_utils/db_sale_order.dart';
import '../../../../database/models/sale_order.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../widgets/long_button_widget.dart';
import '../../../service/create_order/api/create_sales_order.dart';
import '../../create_order_new/ui/new_create_order.dart';

class SaleSuccessScreen extends StatefulWidget {
  final SaleOrder placedOrder;

  const SaleSuccessScreen({Key? key, required this.placedOrder})
      : super(key: key);

  @override
  State<SaleSuccessScreen> createState() => _SaleSuccessScreenState();
}

class _SaleSuccessScreenState extends State<SaleSuccessScreen> {
  @override
  void initState() {
    super.initState();
    log("${widget.placedOrder}");
    CreateOrderService().createOrder(widget.placedOrder).then((value) {
      if (value.status!) {
        // print("create order response::::YYYYY");
        SaleOrder order = widget.placedOrder;
        order.transactionSynced = true;
        order.id = value.message;
        //order.save();

        DbSaleOrder().createOrder(order).then((value) {
          debugPrint('order sync and saved to db');
          //Helper.showPopup(context, "Order synced and saved locally");
        });
      } else {
        DbSaleOrder().createOrder(widget.placedOrder).then((value) {
          debugPrint('order saved to db');
          Helper.showPopup(context,
              "Order saved locally, and will be synced when you restart the app.");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(
              SUCCESS_IMAGE,
              height: SALE_SUCCESS_IMAGE_HEIGHT,
              width: SALE_SUCCESS_IMAGE_WIDTH,
              fit: BoxFit.contain,
            ),
          ),
          hightSpacer30,
          Text(
            SALES_SUCCESS_TXT,
            style: getTextStyle(
                fontSize: LARGE_FONT_SIZE,
                color: BLACK_COLOR,
                fontWeight: FontWeight.w600),
          ),
          hightSpacer30,
          LongButton(
            isAmountAndItemsVisible: false,
            buttonTitle: "Print Receipt",
            onTap: () {
              _printInvoice();
            },
          ),
          LongButton(
            isAmountAndItemsVisible: false,
            buttonTitle: RETURN_TO_HOME_TXT,
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          LongButton(
            isAmountAndItemsVisible: false,
            buttonTitle: "New Order",
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => NewCreateOrder()),
                  (route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }

  //TODO:: Need to handle the print receipt here
  _printInvoice() async {
    final doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: ((context) => pw.Container(
                child: pw.Column(children: [
              _getInvoiceItem('Date & Time', widget.placedOrder.date),
              _getInvoiceItem(
                  'Customer Name', widget.placedOrder.customer.name),
              _getInvoiceItem('Name', widget.placedOrder.customer.name),
              _getInvoiceItem('Phone', widget.placedOrder.customer.phone),
              _getInvoiceItem('Email', widget.placedOrder.customer.email),
              _getInvoiceItem('Order ID', widget.placedOrder.parkOrderId!),
              _getInvoiceItem(
                  'Order Amount', widget.placedOrder.orderAmount.toString()),
              pw.Text('Item(s) Summary'),
              pw.ListView.builder(
                  itemCount: widget.placedOrder.items.length,
                  itemBuilder: ((context, index) => _getInvoiceItem(
                      widget.placedOrder.items[index].name,
                      widget.placedOrder.items[index].orderedPrice
                          .toString()))),
            ])))));

    await Printing.layoutPdf(
        format: PdfPageFormat.roll80,
        usePrinterSettings: true,
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  _getInvoiceItem(String keyName, String dataValue) {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [pw.Text(keyName), pw.Text(dataValue)]);
  }
}
