import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_posx/core/service/customer/api/customer_api_service.dart';
import 'package:nb_posx/network/api_helper/comman_response.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../database/db_utils/db_customer.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/custom_appbar.dart';
import '../../../../../widgets/customer_tile.dart';
import '../../../../../widgets/search_widget.dart';
import '../../../../../widgets/shimmer_widget.dart';

class Customers extends StatefulWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  List<Customer> customers = [];
  late TextEditingController searchCustomerController;
  bool isCustomersFound = true;

  @override
  void initState() {
    super.initState();
    searchCustomerController = TextEditingController();
    getCustomersFromDB(0);
  }

  @override
  void dispose() {
    searchCustomerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // endDrawer: MainDrawer(
      //   menuItem: Helper.getMenuItemList(context),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
            // ignore: unnecessary_string_interpolations
           // AppBar(title: const Text("$CUSTOMERS_TXT"),leading: IconButton(icon: BackButton, onPressed: () {  },),)
              const CustomAppbar(title: CUSTOMER_TXT, hideSidemenu: true),
              hightSpacer30,
              Padding(
                padding: horizontalSpace(),
                child: SearchWidget(
                  searchHint: SEARCH_HINT_TXT,
                  searchTextController: searchCustomerController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(12)],
                  onTextChanged: (text) { (text) {
            if (text.length > 10) {
              searchCustomerController.text = text.substring(0, 10);
              searchCustomerController.selection = TextSelection.fromPosition(
                TextPosition(offset:  searchCustomerController.text.length),
              );
            }

                  };
            
        
         
                    if (text.isNotEmpty) {
                      filterCustomerData(text);
                    } else {
                      getCustomersFromDB(0);
                    }
                  },
                  onSubmit: (text) {
                    if (text.isNotEmpty) {
                      filterCustomerData(text);
                    } else {
                      getCustomersFromDB(0);
                    }
                  },
                ),
              ),
              hightSpacer15,
              isCustomersFound
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: customers.isEmpty ? 10 : customers.length,
                      primary: false,
                      itemBuilder: (context, position) {
                        if (customers.isEmpty) {
                          return const ShimmerWidget();
                        } else {
                          return CustomerTile(
                            isCheckBoxEnabled: false,
                            isDeleteButtonEnabled: false,
                            customer: customers[position],
                            isSubtitle: true,
                            isHighlighted: true,
                          );
                        }
                      })
                  : Center(
                      child: Text(
                      NO_DATA_FOUND,
                      style: getTextStyle(
                        fontSize: SMALL_PLUS_FONT_SIZE,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              // Visibility(
              //     visible: isCustomersFound,
              //     child: ListView.builder(
              //         shrinkWrap: true,
              //         itemCount: customers.isEmpty ? 10 : customers.length,
              //         primary: false,
              //         itemBuilder: (context, position) {
              //           if (customers.isEmpty) {
              //             return const ShimmerWidget();
              //           } else {
              //             return CustomerTile(
              //               isCheckBoxEnabled: false,
              //               isDeleteButtonEnabled: false,
              //               customer: customers[position],
              //               isSubtitle: true,
              //             );
              //           }
              //         })),
              // Visibility(
              //     visible: !isCustomersFound,
              //     child: Center(
              //         child: Text(
              //       NO_DATA_FOUND,
              //       style: getTextStyle(
              //         fontSize: SMALL_PLUS_FONT_SIZE,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ))),
            ],
          ),
        ),
      ),
    );
  }

  ///Function to get the customer data from api
  ///If not available from api then load from local database
  Future<void> getCustomersFromDB(val) async {
    //Fetch the data from local database
    customers = await DbCustomer().getCustomers();
    isCustomersFound = customers.isNotEmpty;
    if (val == 0) setState(() {});
  }

  void filterCustomerData(String searchText) async {
    await getCustomersFromDB(1);
    customers = customers
        .where((element) =>
            //element.name.toLowerCase().contains(searchText.toLowerCase()) ||
            element.phone.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    isCustomersFound = customers.isNotEmpty;

    if (!isCustomersFound) {
      CommanResponse response =
          await CustomerService().getCustomers(searchTxt: searchText);
    }

    setState(() {});
  }
}
