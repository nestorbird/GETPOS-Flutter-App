import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:nb_posx/utils/helper.dart';

import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../database/db_utils/db_categories.dart';
import '../../../../../database/models/category.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../database/models/product.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../database/models/order_item.dart';
import '../../../widgets/item_options.dart';
import '../widget/title_search_bar.dart';
import 'cart_widget.dart';

class CreateOrderLandscape extends StatefulWidget {
  final RxString selectedView;
  const CreateOrderLandscape({Key? key, required this.selectedView})
      : super(key: key);

  @override
  State<CreateOrderLandscape> createState() => _CreateOrderLandscapeState();
}

class _CreateOrderLandscapeState extends State<CreateOrderLandscape> {
  late TextEditingController searchCtrl;
  late Size size;
  Customer? customer;
  List<Product> products = [];
  List<Category> categories = [];
  // ParkOrder? parkOrder;
  late List<OrderItem> items;

  @override
  void initState() {
    items = [];
    searchCtrl = TextEditingController();
    super.initState();
    getProducts();
    if (Helper.activeParkedOrder != null) {
      log("park order is active");
      customer = Helper.activeParkedOrder!.customer;
      items = Helper.activeParkedOrder!.items;
    }
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(
          width: size.width - 405,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TitleAndSearchBar(
                title: "Choose Category",
                onSubmit: (val) {},
                onTextChanged: (val) {},
                searchCtrl: searchCtrl,
                searchHint: "Search products",
                searchBoxWidth: size.width / 4,
              ),
              hightSpacer20,
              getCategoryListWidget(),
              hightSpacer20,
              SizedBox(
                height: 500,
                child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          getCategoryItemsWidget(categories[index]),
                          hightSpacer10
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
        Padding(
          padding: leftSpace(x: 5),
          child: CartWidget(
            customer: customer,
            orderList: items,
            onHome: () {
              widget.selectedView.value = "Home";
            },
            onPrintReceipt: () {
              widget.selectedView.value = "Home";
            },
            onNewOrder: () {
              customer = null;
              items = [];
              setState(() {});
            },
          ), //_cartWidget()
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
                    var item = OrderItem.fromJson(cat.items[index].toJson());
                    _openItemDetailDialog(context, item);
                    debugPrint("Item clicked $index");
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
                                "₹ ${cat.items[index].price}",
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

  _openItemDetailDialog(BuildContext context, OrderItem product) async {
    product.orderedPrice = product.price;
    if (product.orderedQuantity == 0) {
      product.orderedQuantity = 1;
    }
    var res = await showDialog(
        context: context,
        builder: (context) {
          return ItemOptions(orderItem: product);
        });
    if (res == true) {
      items.add(product);
    }
    setState(() {});
  }

  getCategoryListWidget() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, index) {
            return InkWell(
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
                    Text(
                      categories[index].name,
                      style: getTextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<void> getProducts() async {
    //Fetching data from DbProduct database
    categories = await DbCategory().getCategories();
    setState(() {});
  }
}
