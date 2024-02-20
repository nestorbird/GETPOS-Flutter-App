import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/constants/asset_paths.dart';
import 'package:nb_posx/core/tablet/open_shift/open_shift_management_landscape.dart';
import 'package:nb_posx/utils/helper.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../database/db_utils/db_categories.dart';
import '../../../../../database/models/category.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../database/models/park_order.dart';
import '../../../../../database/models/product.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../widget/create_customer_popup.dart';
import '../widget/select_customer_popup.dart';
import '../widget/title_search_bar.dart';

class HomeLandscape extends StatefulWidget {
  const HomeLandscape({Key? key}) : super(key: key);

  @override
  HomeLandscapeState createState() => HomeLandscapeState();
}

class HomeLandscapeState extends State<HomeLandscape> {
  late TextEditingController searchCtrl;
  Customer? customer;
  List<Product> products = [];
  List<Category> categories = [];
  ParkOrder? parkOrder;
  bool isInternetAvailable = true;

  @override
  void initState() {
    searchCtrl = TextEditingController();
    super.initState();
    getProducts();
    checkInternetAvailability();
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> checkInternetAvailability() async {
    try {
      bool internetAvailable = await Helper.isNetworkAvailable();
      setState(() {
        isInternetAvailable = internetAvailable;
      });
    } catch (error) {
      // Handle the error if needed
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleAndSearchBar(
            title: "Choose Category",
            onSubmit: (text) {},
            onTextChanged: (changedtext) {},
            searchCtrl: searchCtrl,
            searchHint: "Search products / Category",
          ),
          hightSpacer20,
          getCategoryListWidget(),
          hightSpacer20,
          categories.isEmpty
              ? const Center(
                  child: Text(
                  "No items found",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
              : Expanded(
                  child: ListView.builder(
                      primary: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return getCategoryItemsWidget(categories[index]);
                      }),
                ),
        ],
      ),
    );
  }

  getCategoryItemsWidget(Category cat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cat.name,
          style: getTextStyle(
            fontSize: SMALL_PLUS_FONT_SIZE,
          ),
        ),
        hightSpacer10,
        SizedBox(
          height: 140,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cat.items.length,
              itemBuilder: (BuildContext context, index) {
                return cat.items.isEmpty
                    ? const Center(
                        child: Text(
                        "No items found",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                    : InkWell(
                        onTap: () {
                          //TODO:: SS - Need to add the logic for the category tap
                          // var item = OrderItem.fromJson(cat.items[index].toJson());
                          // _openItemDetailDialog(context, item);
                          // debugPrint("Item clicked $index");
                        },
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                margin: paddingXY(x: 5, y: 5),
                                padding: paddingXY(y: 0, x: 10),
                                width: 145,
                                height: 105,
                                decoration: BoxDecoration(
                                    color: AppColors.fontWhiteColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    hightSpacer20,
                                    SizedBox(
                                      height: 40,
                                      child: Text(
                                        cat.items[index].name,
                                        style: getTextStyle(
                                            // color: DARK_GREY_COLOR,
                                            fontWeight: FontWeight.w500,
                                            fontSize: MEDIUM_FONT_SIZE),
                                      ),
                                    ),
                                    hightSpacer5,
                                    Text(
                                      "$appCurrency ${cat.items[index].price}",
                                      textAlign: TextAlign.right,
                                      style: getTextStyle(
                                          color: AppColors.getPrimary(),
                                          fontSize: MEDIUM_FONT_SIZE),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: (isInternetAvailable &&
                                      categories[index]
                                          .items
                                          .first
                                          .productImageUrl!
                                          .isNotEmpty)
                                  ? Image.network(
                                      categories[index]
                                          .items
                                          .first
                                          .productImageUrl!,
                                      fit: BoxFit.fill,
                                    )
                                  : (isInternetAvailable &&
                                          categories[index]
                                              .items
                                              .first
                                              .productImage
                                              .isEmpty)
                                      ? Image.asset(
                                          NO_IMAGE,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.asset(
                                          NO_IMAGE,
                                          fit: BoxFit.fill,
                                        ),
                              //    Image.memory(cat.items[index].productImage),
                            ),
                          ],
                        ),
                      );
              }),
        ),
      ],
    );
  }

  getCategoryListWidget() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, index) {
            return categories.isEmpty
                ? const Center(
                    child: Text(
                    "No items found",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
                : InkWell(
                    onTap: () => _handleCustomerPopup(),
                    
                     
                    child: Container(
                      margin: paddingXY(y: 5),
                      width: 80,
                      decoration: BoxDecoration(
                        color: AppColors.fontWhiteColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //  Image.memory(categories[index].image),
                          (isInternetAvailable &&
                                  categories[index]
                                      .items
                                      .first
                                      .productImageUrl!
                                      .isNotEmpty)
                              ? Image.network(
                                  categories[index]
                                      .items
                                      .first
                                      .productImageUrl!,
                                  fit: BoxFit.fill,
                                )
                              : (isInternetAvailable &&
                                      categories[index]
                                          .items
                                          .first
                                          .productImage
                                          .isEmpty)
                                  ? Image.asset(
                                      NO_IMAGE,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      NO_IMAGE,
                                      fit: BoxFit.fill,
                                    ),
                          hightSpacer4,
                          Text(
                            categories[index].name,
                            style: getTextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          }),
    );
  }

  _handleCustomerPopup() async {
    final result = await Get.defaultDialog(
      // contentPadding: paddingXY(x: 0, y: 0),
      title: "",
      titlePadding: paddingXY(x: 0, y: 0),
      // custom: Container(),
      content: SelectCustomerPopup(
        customer: customer,
      ),
    );
    if (result.runtimeType == String) {
      customer = await Get.defaultDialog(
        // contentPadding: paddingXY(x: 0, y: 0),
        title: "",
        titlePadding: paddingXY(x: 0, y: 0),
        // custom: Container(),
        content: CreateCustomerPopup(
          phoneNo: result,
        ),
      );
    }
    if (customer != null) {
      debugPrint("Customer selected");
    }
    //malvika
    setState(() {});
  }

  Future<void> getProducts() async {
    //Fetching data from DbProduct database
    categories = await DbCategory().getCategories();
    setState(() {});
  }
}
