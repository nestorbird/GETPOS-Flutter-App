import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
//import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';

import '../../../../../database/db_utils/db_customer.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';

import '../../../../../widgets/customer_tile.dart';
import '../../../../../widgets/search_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';

import '../../../network/api_helper/api_status.dart';
import '../../service/select_customer/api/get_customer.dart';

// ignore: must_be_immutable
class SelectCustomerPopup extends StatefulWidget {
  Customer? customer;
  SelectCustomerPopup({Key? key, this.customer}) : super(key: key);

  @override
  State<SelectCustomerPopup> createState() => _SelectCustomerPopupState();
}

class _SelectCustomerPopupState extends State<SelectCustomerPopup> {
  late TextEditingController searchCtrl;
  // late TextEditingController _phoneCtrl;
  Customer? customer;
  List<Customer> customers = [];
  List<Customer> filteredCustomer = [];

  @override
  void initState() {
    searchCtrl = TextEditingController();
    if (widget.customer != null) {
      customer = widget.customer!;
    }

    // _phoneCtrl = TextEditingController();
    if (customer != null) {
      searchCtrl.text = customer!.phone;
    }
    super.initState();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    // _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                //on close
                // Get.back(result: null);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SvgPicture.asset(
                  CROSS_ICON,
                  color: AppColors.getTextandCancelIcon(),
                  width: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
            child: Column(
              children: [
                Container(
                    width: 400,
                    // height: 100,
                    padding: horizontalSpace(),
                    //changes needed to be done here(malvika)
                    child: SearchWidget(
                      searchHint: SEARCH_HINT_TXT,
                      searchTextController: searchCtrl,
                      onTextChanged: (text) {
                        if (text.isNotEmpty && text.length == 10) {
                          filterCustomerData(text);
                        }
                      },
                      onSubmit: (text) {
                        if (text.isNotEmpty && text.length == 10) {
                          filterCustomerData(text);
                        }
                      },
                    )),
                hightSpacer10,
                customer != null
                    ? CustomerTile(
                        isCheckBoxEnabled: false,
                        isDeleteButtonEnabled: false,
                        customer: customer,
                        isHighlighted: true,
                        isSubtitle: true,
                      )
                    : (customer == null && searchCtrl.text.length == 10)
                        ? Container(
                            width: 380,
                            height: 75,
                            padding: morePaddingAll(),
                            decoration: BoxDecoration(
                              color: AppColors.getPrimary().withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: AppColors.getPrimary().withOpacity(0.4),
                              ),
                            ),
                            child: Text(
                              "No records were found, please add the details below in order to continue",
                              style: getTextStyle(
                                  color: AppColors.getPrimary(),
                                  fontSize: MEDIUM_PLUS_FONT_SIZE,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.left,
                            ),
                          )
                        : Container(
                            width: 380,
                            height: 90, //65
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            padding: mediumPaddingAll(),
                            decoration: BoxDecoration(
                              color: AppColors.getPrimary().withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 0.5,
                                color: AppColors.getPrimary().withOpacity(0.4),
                              ),
                            )),
                hightSpacer10,
                InkWell(
                  onTap: () {
                    log(customer.toString());
                    if (customer != null) {
                      searchCtrl.text = customer!.phone;
                      Navigator.pop(context, customer);
                    } else if (customer == null) {
                      // Get.back(result: searchCtrl.text);
                      Navigator.pop(context, searchCtrl.text);
                    }
                  },
                  child: Container(
                    width: 380,
                    height: 48,
                    decoration: BoxDecoration(
                      color: searchCtrl.text.length == 10
                          ? AppColors.getPrimary()
                          : AppColors.getPrimary().withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Continue",
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                            fontSize: LARGE_FONT_SIZE,
                            color: AppColors.fontWhiteColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///Function to get the customer data from api
  ///If not available from api then load from local database
  Future<void> getCustomersFromDB(val) async {
    //Fetch the data from local database
    customers = await DbCustomer().getCustomer(searchCtrl.text);
    if (customers.isNotEmpty) {
      customer = customers.first;
    }

    if (val == 0) setState(() {});
  }

  void filterCustomerData(String searchText) async {
    // _phoneCtrl.text = searchText;
    await getCustomersFromDB(1);
    filteredCustomer = customers
        .where((element) =>
            element.name.toLowerCase().contains(searchText.toLowerCase()) ||
            element.phone.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    if (filteredCustomer.isEmpty) {
      await _askCustomerAPI(searchText);
    }

    setState(() {});
  }

  Future<void> _askCustomerAPI(String searchText) async {
    CommanResponse response = await GetCustomer().getByMobileno(searchText);
    if (response.status! && response.message == SUCCESS) {
      filterCustomerData(searchText);
    } else if (response.apiStatus == ApiStatus.NO_DATA_AVAILABLE) {
      setState(() {
        customer = null;
      });
    }
  }
}
