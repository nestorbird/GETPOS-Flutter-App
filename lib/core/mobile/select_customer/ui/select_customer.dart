import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../../constants/app_constants.dart';
import '../../../../database/db_utils/db_customer.dart';
import '../../../../database/models/customer.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/comman_tile_options.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../widgets/search_widget.dart';
import '../../../../widgets/shimmer_widget.dart';

// ignore: must_be_immutable
class SelectCustomerScreenOld extends StatefulWidget {
  const SelectCustomerScreenOld({Key? key}) : super(key: key);

  @override
  State<SelectCustomerScreenOld> createState() =>
      _SelectCustomerScreenOldState();
}

class _SelectCustomerScreenOldState extends State<SelectCustomerScreenOld> {
  // bool _value = false;
  int selectedPosition = -1;
  Customer? selectedCustomer;
  List<Customer> customers = [];
  TextEditingController searchCustomerController = TextEditingController();
  bool isCustomersFound = true;

  @override
  void initState() {
    super.initState();

    getCustomersFromDB();
  }

  @override
  void dispose() {
    searchCustomerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            physics: customers.isEmpty
                ? const NeverScrollableScrollPhysics()
                : const ScrollPhysics(),
            child: Column(children: [
              const CustomAppbar(title: SELECT_CUSTOMER_TXT),
              Padding(
                  padding: mediumPaddingAll(),
                  child: SearchWidget(
                    searchHint: SEARCH_HINT_TXT,
                    searchTextController: searchCustomerController,
                    onTextChanged: (text) {
                      log('Changed text :: $text');
                      if (text.isNotEmpty) {
                        filterCustomerData(text);
                      } else {
                        getCustomersFromDB();
                      }
                    },
                    onSubmit: (text) {
                      if (text.isNotEmpty) {
                        filterCustomerData(text);
                      } else {
                        getCustomersFromDB();
                      }
                    },
                  )),
              isCustomersFound
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: customers.isEmpty ? 10 : customers.length,
                      primary: false,
                      itemBuilder: (context, position) {
                        if (customers.isEmpty) {
                          return const ShimmerWidget();
                        } else {
                          return CommanTileOptions(
                            isCheckBoxEnabled: true,
                            isDeleteButtonEnabled: false,
                            isSubtitle: true,
                            checkBoxValue: selectedPosition == position,
                            customer: customers[position],
                            onCheckChanged: (value) {
                              selectedPosition = position;
                              selectedCustomer = customers[position];
                              setState(() {});
                            },
                          );
                        }
                      })
                  : Center(
                      child: Text(
                      NO_DATA_FOUND,
                      style: getTextStyle(
                          fontSize: SMALL_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.w600),
                    )),
            ])),
      ),
      bottomNavigationBar: Visibility(
        visible: selectedCustomer != null,
        child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: ButtonWidget(
                width: MediaQuery.of(context).size.width,
                onPressed: () {
                  Navigator.pop(context, selectedCustomer);
                },
                fontSize: MEDIUM_FONT_SIZE,
                title: SELECT_CONTINUE_TXT)),
      ),
    );
  }

  ///Function to get the customer data from api
  ///If not available from api then load from local database
  Future<void> getCustomersFromDB() async {
    //Fetch the data from local database
    customers = await DbCustomer().getCustomers();
    isCustomersFound = customers.isNotEmpty;

    setState(() {});
  }

  void filterCustomerData(String searchText) async {
    await getCustomersFromDB();
    customers = customers
        .where((element) =>
            element.name.toLowerCase().contains(searchText.toLowerCase()) ||
            element.phone.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    isCustomersFound = customers.isNotEmpty;

    setState(() {});
  }
}
