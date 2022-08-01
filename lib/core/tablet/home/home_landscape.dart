import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';

import '../../../../../database/db_utils/db_categories.dart';
import '../../../../../database/db_utils/db_hub_manager.dart';
import '../../../../../database/db_utils/db_parked_order.dart';
import '../../../../../database/models/category.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../database/models/hub_manager.dart';
import '../../../../../database/models/order_item.dart';
import '../../../../../database/models/park_order.dart';
import '../../../../../database/models/product.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/item_options.dart';
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

  @override
  void initState() {
    searchCtrl = TextEditingController();
    super.initState();
    getProducts();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSearchBar(
          title: "Choose Category",
          onSubmit: (val) {},
          onTextChanged: (val) {},
          searchCtrl: searchCtrl,
          searchHint: "Search products",
        ),
        hightSpacer20,
        getCategoryListWidget(),
        hightSpacer20,
        Expanded(
          child: ListView.builder(
              primary: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return getCategoryItemsWidget(categories[index]);
              }),
        ),
      ],
    );
  }

  getCategoryItemsWidget(Category cat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cat.name,
          style: getTextStyle(
            fontSize: LARGE_FONT_SIZE,
          ),
        ),
        hightSpacer10,
        SizedBox(
          height: 140,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cat.items.length,
              itemBuilder: (BuildContext context, index) {
                return InkWell(
                  onTap: () {
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
                              color: WHITE_COLOR,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                "USD ${cat.items[index].price}",
                                textAlign: TextAlign.right,
                                style: getTextStyle(
                                    color: MAIN_COLOR,
                                    fontSize: MEDIUM_FONT_SIZE),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: Image.asset(
                            index % 2 == 0 ? BURGAR_IMAGE : PIZZA_IMAGE),
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
            return InkWell(
              // onTap: () => _handleCustomerPopup(),
              child: Container(
                margin: paddingXY(y: 5),
                width: 80,
                decoration: BoxDecoration(
                  color: WHITE_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(index % 2 == 0 ? BURGAR_IMAGE : PIZZA_IMAGE),
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
    setState(() {});
  }

  Future<void> getProducts() async {
    //Fetching data from DbProduct database
    categories = await DbCategory().getCategories();
    setState(() {});
  }
}
