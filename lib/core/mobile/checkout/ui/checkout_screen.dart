import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/asset_paths.dart';
import '../../../../database/db_utils/db_hub_manager.dart';
import '../../../../database/models/hub_manager.dart';
import '../../../../database/models/park_order.dart';
import '../../../../database/models/sale_order.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../widgets/long_button_widget.dart';
import '../../sale_success/ui/sale_success_screen.dart';

// ignore: must_be_immutable
class CheckoutScreen extends StatefulWidget {
  // Customer? selectedCustomer;
  // List<OrderItem> orderedProducts;
  ParkOrder order;

  CheckoutScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isCODSelected = false;
  double totalAmount = 0.0;
  int totalItems = 0;
  late HubManager? hubManager;
  // String? transactionID;
  late String paymentMethod;
  // late TextEditingController _transactionIdCtrl;
  // bool _isEWalletEnabled = false;

  @override
  void initState() {
    super.initState();
    _getHubManager();
    totalAmount = Helper().getTotal(widget.order.items);
    totalItems = widget.order.items.length;
   
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const CustomAppbar(title: CHECKOUT_TXT_SMALL),
            // hightSpacer10,
            Padding(
              padding: paddingXY(x: 16),
              child: Row(
                children: [
                  getPaymentOption(
                      PAYMENT_CASH_ICON, CASH_PAYMENT_TXT, _isCODSelected),
                  widthSpacer(16),
                  getPaymentOption(
                      PAYMENT_CARD_ICON, CARD_PAYMENT_TXT, _isCODSelected),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: LongButton(
        buttonTitle: CONFIRM_PAYMENT,
        isAmountAndItemsVisible: true,
        totalAmount: '$totalAmount',
        totalItems: '$totalItems',
        onTap: () => createSale(_isCODSelected?"Card":"Cash"),
      ),
    );
  }

  getPaymentOption(String icon, String title, bool selected,) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            if (!selected) {
              _isCODSelected = !_isCODSelected;
            }
          });
        },
        child: Container(
          height: 180,
          decoration: BoxDecoration(
              color: selected ? OFF_WHITE_COLOR : WHITE_COLOR,
              border: Border.all(
                  color: selected ? MAIN_COLOR : DARK_GREY_COLOR, width: 0.4),
              borderRadius: BorderRadius.circular(BORDER_CIRCULAR_RADIUS_20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                height: 80,
              ),
              hightSpacer20,
              Text(title,
                  style: getTextStyle(
                      fontSize: LARGE_FONT_SIZE, color: DARK_GREY_COLOR)),
            ],
          ),
        ),
      ),
    );
  }

  createSale(String paymentMethod) async {
    paymentMethod =paymentMethod;
if(paymentMethod=="Card"){ return Helper.showPopup(context,
              "Comming soon" );

}else{
    DateTime currentDateTime = DateTime.now();
    String date =
        DateFormat('EEEE d, LLLL y').format(currentDateTime).toString();
    log('Date : $date');
    String time = DateFormat().add_jm().format(currentDateTime).toString();
    log('Time : $time');
    String orderId = await Helper.getOrderId();
    log('Order No : $orderId');

    SaleOrder saleOrder = SaleOrder(
        id: orderId,
        orderAmount: totalAmount,
        date: date,
        time: time,
        customer: widget.order.customer,
        manager: hubManager!,
        items: widget.order.items,
        transactionId: '',
        paymentMethod: paymentMethod,
        paymentStatus: "Paid",
        transactionSynced: false,
        parkOrderId:
            "${widget.order.transactionDateTime.millisecondsSinceEpoch}",
        tracsactionDateTime: currentDateTime);
    if (!mounted) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SaleSuccessScreen(placedOrder: saleOrder)));
  }}

  void _getHubManager() async {
    hubManager = await DbHubManager().getManager();
  }
}
