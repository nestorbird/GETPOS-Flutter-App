import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import '../../../../constants/app_constants.dart';

import '../../../../database/db_utils/db_customer.dart';
import '../../../../database/models/customer.dart';
import '../../../../network/api_helper/comman_response.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../utils/ui_utils/textfield_border_decoration.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../widgets/customer_tile.dart';
import '../../../../widgets/search_widget.dart';
import '../../../../widgets/shimmer_widget.dart';
import '../../../../widgets/text_field_widget.dart';
import '../../../service/select_customer/api/create_customer.dart';
import '../../../service/select_customer/api/get_customer.dart';

class NewSelectCustomer extends StatefulWidget {
 
  const NewSelectCustomer({Key? key}) : super(key: key);

  @override
  State<NewSelectCustomer> createState() => _NewSelectCustomerState();
}

class _NewSelectCustomerState extends State<NewSelectCustomer> {
  Customer? selectedCustomer;
  List<Customer> customers = [];
  List<Customer> filteredCustomer = [];
  late TextEditingController searchCtrl;
  late TextEditingController _emailCtrl, _phoneCtrl, _nameCtrl;

  @override
  void initState() {
    searchCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _nameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    // getCustomersFromDB(0);
    super.initState();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // hightSpacer40,
              const CustomAppbar(title: CUSTOMERS_TXT, hideSidemenu: true),
              hightSpacer30,
              Padding(
                padding: horizontalSpace(),
                child: SearchWidget(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(12)],
                  searchHint: SEARCH_HINT_TXT,
                  searchTextController: searchCtrl,
                  keyboardType: TextInputType.phone,
                  onTextChanged: (text) {
                    if (text.isNotEmpty && text.isNotEmpty) {
                      filterCustomerData(text);
                    }
                    //else {
                    //   getCustomersFromDB(0);
                    // }
                  },
                  onSubmit: (text) {
                    if (text.isNotEmpty && text.isNotEmpty) {
                      filterCustomerData(text);
                    }
                    //else {
                    //   getCustomersFromDB(0);
                    // }
                  },
                ),
              ),
              hightSpacer15,
              filteredCustomer.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: customers.isEmpty ? 10 : customers.length,
                      primary: false,
                      itemBuilder: (context, position) {
                        if (customers.isEmpty) {
                          return const ShimmerWidget();
                        } else {
                          return CustomerTile(
                            isCheckBoxEnabled: true,
                            isDeleteButtonEnabled: false,
                            customer: customers[position],
                            isSubtitle: true,
                            isHighlighted: true,
                            onCheckChanged: (p0) {
                                 Navigator.pop(context, customers[position]);
           },
                          );
                        }
                      })
                  : customers.isEmpty && searchCtrl.text.length < 10
                      ? Container()
                      // ? Center(
                      //     child: Text(
                      //     SEARCH_CUSTOMER_MSG_TXT,
                      //     style: getTextStyle(
                      //       fontSize: SMALL_PLUS_FONT_SIZE,
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ))
                      : _addNewCustomerUI(),
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
    customers = await DbCustomer().getCustomerNo(searchCtrl.text);

    if (val == 0) setState(() {});
  }

  void filterCustomerData(String searchText) async {
    _phoneCtrl.text = searchText;
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

  _addNewCustomerUI() {
    return Column(
      children: [
        Center(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
          child: Text(
            "No records were found. Please add the details below in order to continue.",
            style: getTextStyle(
                fontSize: MEDIUM_PLUS_FONT_SIZE,
                fontWeight: FontWeight.w500,
                color:  AppColors.getPrimary()),
          ),
        )),
        Center(
            child: Text(
          "Add Customer",
          style: getTextStyle(
            fontSize: LARGE_MINUS_FONT_SIZE,
            fontWeight: FontWeight.w600,
          ),
        )),
        hightSpacer20,
        Padding(
          padding: horizontalSpace(x: 20),
          child: TextFieldWidget(
              boxDecoration: txtFieldBorderDecoration,
              txtCtrl: _phoneCtrl,
              hintText: "Phone No.",
              txtColor: AppColors.getTextandCancelIcon()),
        ),
        hightSpacer20,
        Padding(
          padding: horizontalSpace(x: 20),
          child: TextFieldWidget(
              boxDecoration: txtFieldBorderDecoration,
              txtCtrl: _nameCtrl,
              hintText: "Enter Name",
              txtColor: AppColors.getTextandCancelIcon()),
        ),
        hightSpacer20,
        Padding(
          padding: horizontalSpace(x: 20),
          child: TextFieldWidget(
              boxDecoration: txtFieldBorderDecoration,
              txtCtrl: _emailCtrl,
              hintText: "Enter Email (optional)",
              txtColor: AppColors.getTextandCancelIcon()),
        ),
        hightSpacer30,
        SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            child: ButtonWidget(
              onPressed: () {
                if (_nameCtrl.text.isNotEmpty && _phoneCtrl.text.isNotEmpty) {
                  _newCustomerAPI();
                }
              },
              title: "Add and Create Order",
              primaryColor:  AppColors.getPrimary(),
            )),
        hightSpacer20,
        SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            child: ButtonWidget(
              onPressed: () {
                Navigator.pop(context);
              },
              primaryColor:  AppColors.getAsset(),
              title: "Cancel",
            )),
      ],
    );
  }

  Future<void> _newCustomerAPI() async {
    CommanResponse response = await CreateCustomer()
        .createNew(_phoneCtrl.text, _nameCtrl.text, _emailCtrl.text);
    if (response.status!) {
      filterCustomerData(_phoneCtrl.text);
    }
    //  else {
    //   Customer tempCustomer = Customer(
    //       // profileImage: image,
    //       // ward: Ward(id: "1", name: "1"),
    //       email: _emailCtrl.text.trim(),
    //       id: _phoneCtrl.text.trim(),
    //       name: _nameCtrl.text.trim(),
    //       phone: _phoneCtrl.text.trim(),
    //       isSynced: false,
    //       modifiedDateTime: DateTime.now());
    //   List<Customer> customers = [];
    //   customers.add(tempCustomer);
    //   await DbCustomer().addCustomers(customers);
    //   filterCustomerData(_phoneCtrl.text);
    // }
  }

  Future<void> _askCustomerAPI(String searchText) async {
    CommanResponse response = await GetCustomer().getByMobileno(searchText);
    if (response.status! && response.message == SUCCESS) {
      filterCustomerData(searchText);
    }
  }
}
