import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/utils/helper.dart';
import 'package:nb_posx/utils/ui_utils/text_styles/custom_text_style.dart';

import '../../../../../database/db_utils/db_parked_order.dart';
import '../../../../../database/models/park_order.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../widgets/shimmer_widget.dart';
import '../../../network/api_helper/comman_response.dart';
import '../../service/login/api/verify_instance_service.dart';
import '../widget/title_search_bar.dart';
import 'parked_data_item_landscape.dart';

class OrderListParkedLandscape extends StatefulWidget {
  final RxString selectedView;
  const OrderListParkedLandscape({Key? key, required this.selectedView})
      : super(key: key);

  @override
  State<OrderListParkedLandscape> createState() =>
      _OrderListParkedLandscapeState();
}

class _OrderListParkedLandscapeState extends State<OrderListParkedLandscape> {
  late TextEditingController searchCtrl;
  List<ParkOrder> orderFromLocalDB = [];
  List<ParkOrder> parkedOrders = [];
  late bool fetchingData;

  @override
  void initState() {   verify();
    fetchingData = true;
    searchCtrl = TextEditingController();
    super.initState();
    getParkedOrders();
  }


  
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child:GestureDetector (onTap: _handleTap,child: Column(
          children: [
            TitleAndSearchBar(focusNode: _focusNode,
              inputFormatter: [FilteringTextInputFormatter.digitsOnly],
              title: "Parked Orders",
              onSubmit: (text) {
                if (text.length >= 3) {
                  _filterProductsCategories(text);
                } else {
                  getParkedOrders();
                }
              },
              onTextChanged: (changedtext) {
                if (changedtext.length >= 3) {
                  _filterProductsCategories(changedtext);
                } else {
                  getParkedOrders();
                }
              },
              searchCtrl: searchCtrl,
              searchHint: "Enter customer mobile number",
            ),
            hightSpacer20,
            parkedOrders.isEmpty
                ? const Center(
                    child: Text("No order found ",
                        style: TextStyle(fontWeight: FontWeight.bold)))
                : Expanded(
                    child: productGrid(),
                  ),
          ],
        )));
  }

  Widget productGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: GridView.builder(
        itemCount: parkedOrders.isEmpty ? 1 : parkedOrders.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: parkedOrders.isEmpty ? 1 : 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 5,
        ),
        shrinkWrap: true,
        primary: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, position) {
          if (orderFromLocalDB.isEmpty && fetchingData) {
            return const ShimmerWidget();
          } else if (orderFromLocalDB.isEmpty && !fetchingData) {
            return Text(
              "No orders found",
              textAlign: TextAlign.center,
              style: getTextStyle(fontSize: LARGE_FONT_SIZE),
            );
          } else {
            return ParkedDataItemLandscape(
              order: parkedOrders[position],
              onDelete: () => getParkedOrders(),
              onSelect: () => makeActiveOrder(parkedOrders[position]),
            );
          }
        },
      ),
    );
  }

  Future<void> getParkedOrders() async {
    orderFromLocalDB = await DbParkedOrder().getOrders();

    parkedOrders = orderFromLocalDB.reversed.toList();
    fetchingData = false;
    setState(() {});
  }

  makeActiveOrder(ParkOrder parkedOrder) {
    Helper.activateParkedOrder(parkedOrder);
    DbParkedOrder().deleteOrder(parkedOrder);
    widget.selectedView.value = "Order";
  }

  void _filterProductsCategories(String searchTxt) {
    parkedOrders = parkedOrders
        .where((element) => element.customer.phone
            .toLowerCase()
            .contains(searchTxt.toLowerCase()))
        .toList();

    setState(() {});
  }verify() async {
    CommanResponse res = await VerificationUrl.checkAppStatus();
    if (res.message == true) {
    } else {
      Helper.showPopup(context, "Please update your app to latest version",
          barrierDismissible: true);
    }
  }
}
