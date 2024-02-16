import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widget/parked_data_item.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../database/db_utils/db_parked_order.dart';
import '../../../../../database/models/park_order.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/custom_appbar.dart';
import '../../../../../widgets/search_widget.dart';
import 'order_detail_screen.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late TextEditingController searchCtrl;
  List<ParkOrder> orderFromLocalDB = [];
  List<ParkOrder> parkedOrders = [];

  @override
  void initState() {
    searchCtrl = TextEditingController();
    super.initState();
    getParkedOrders();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        primary: true,
        child: Column(
          children: [
            const CustomAppbar(
              title: "Parked Orders",
              hideSidemenu: true,
            ),
            hightSpacer10,
            Padding(
                padding: horizontalSpace(),
                child: SearchWidget(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12)
                  ],
                  searchHint: 'Enter customer mobile no.',
                  searchTextController: searchCtrl,
                  onTextChanged: (text) {
                    if (text.length >= 3) {
                      filterSalesData(text);
                    } else {
                      getParkedOrders();
                    }
                  },
                  onSubmit: (text) {
                    if (text.length >= 3) {
                      filterSalesData(text);
                    } else {
                      getParkedOrders();
                    }
                  },
                )),
            hightSpacer10,
            parkedOrders.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    primary: false,
                    itemCount: parkedOrders.length,
                    itemBuilder: (context, position) {
                      return ParkedDataItem(
                          saleOrder: parkedOrders[position],
                          onClick: () async {
                            var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetailScreen(
                                  order: parkedOrders[position],
                                ),
                              ),
                            );
                            if (res == "reload") {
                              getParkedOrders();
                            }
                          },
                          onDelete: () =>
                              _handleDelete(context, parkedOrders[position]));
                    })
                : Center(
                    child: Text(
                      NO_ORDERS_FOUND_MSG,
                      style: getTextStyle(fontSize: MEDIUM_FONT_SIZE),
                    ),
                  ),
          ],
        ),
      )),
    );
  }

  Future<void> getParkedOrders() async {
    orderFromLocalDB = await DbParkedOrder().getOrders();

    parkedOrders = orderFromLocalDB.reversed.toList();

    setState(() {});
  }

  ///Function to filter the orders as per the search keyword.
  void filterSalesData(String searchText) {
    if (searchText.trim().isEmpty) {
      parkedOrders = orderFromLocalDB.reversed.toList();
    } else {
      parkedOrders = orderFromLocalDB.where((element) =>
          //element.id.toLowerCase().contains(searchText) ||
          //element.customer.name.toLowerCase().contains(searchText) ||
          element.customer.phone.toLowerCase().contains(searchText)).toList();
      parkedOrders = parkedOrders.reversed.toList();
    }
    setState(() {});
  }

  Future<void> _handleDelete(BuildContext context, ParkOrder order) async {
    var res = await Helper.showConfirmationPopup(
        context, "Do you want to delete this parked order", OPTION_YES,
        hasCancelAction: true);
    if (res != OPTION_CANCEL.toLowerCase()) {
      bool result = await DbParkedOrder().deleteOrder(order);
      if (result) {
        if (!mounted) return;
        await Helper.showConfirmationPopup(
            context, "Parked Order Deleted Successfully", OPTION_OK);
        getParkedOrders();
      } else {
        if (!mounted) return;
        await Helper.showConfirmationPopup(
            context, SOMETHING_WENT_WRONG, OPTION_OK);
      }
    }
  }
}
