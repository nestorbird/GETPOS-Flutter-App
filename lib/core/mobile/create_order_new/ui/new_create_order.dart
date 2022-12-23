import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import '../../../../../utils/helper.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/custom_appbar.dart';
import '../../../../../widgets/item_options.dart';
import '../../../../../widgets/main_drawer.dart';
import '../../../../../widgets/product_shimmer_widget.dart';
import '../../../../../widgets/search_widget.dart';
import '../../select_customer/ui/new_select_customer.dart';
import 'cart_screen.dart';
import 'widget/category_item.dart';

// ignore: must_be_immutable
class NewCreateOrder extends StatefulWidget {
  ParkOrder? order;
  NewCreateOrder({Key? key, this.order}) : super(key: key);

  @override
  State<NewCreateOrder> createState() => _NewCreateOrderState();
}

class _NewCreateOrderState extends State<NewCreateOrder> {
  late TextEditingController searchProductCtrl;
  Customer? _selectedCust;
  List<Category> categories = [];
  List<Product> products = [];

  ParkOrder? parkOrder;

  // List<Product> cartProducts = [];

  @override
  void initState() {
    super.initState();
    searchProductCtrl = TextEditingController();
    if (widget.order != null) {
      _selectedCust = widget.order!.customer;
      parkOrder = widget.order!;
      _calculateOrderAmount();
      getProducts();
    }
    if (_selectedCust == null) {
      Future.delayed(Duration.zero, () => goToSelectCustomer());
    }
  }

  @override
  void dispose() {
    searchProductCtrl.dispose();
    super.dispose();
  }

  Widget get selectedCustomerSection => _selectedCust != null
      ? Padding(
          padding: paddingXY(x: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedCust!.name,
                style: getTextStyle(
                    fontSize: LARGE_FONT_SIZE,
                    color: MAIN_COLOR,
                    fontWeight: FontWeight.w500),
              ),
              InkWell(
                onTap: () {
                  goToSelectCustomer();
                },
                child: Padding(
                  padding: miniPaddingAll(),
                  child: SvgPicture.asset(
                    CROSS_ICON,
                    color: MAIN_COLOR,
                    width: 15,
                  ),
                ),
              )
            ],
          ),
        )
      : Container();

  Widget get searchBarSection => Padding(
      padding: mediumPaddingAll(),
      child: SearchWidget(
        searchHint: SEARCH_PRODUCT_HINT_TXT,
        searchTextController: searchProductCtrl,
        onTextChanged: (text) {
          // log('Changed text :: $text');
          // if (text.isNotEmpty) {
          //   filterCustomerData(text);
          // } else {
          //   getCustomersFromDB();
          // }
        },
        onSubmit: (text) {
          // if (text.isNotEmpty) {
          //   filterCustomerData(text);
          // } else {
          //   getCustomersFromDB();
          // }
        },
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainDrawer(
        menuItem: Helper.getMenuItemList(context),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
                child: Column(
              children: [
                const CustomAppbar(
                  title: "",
                ),
                selectedCustomerSection,
                searchBarSection,
                productCategoryList()
              ],
            )),
            parkOrder == null
                ? Container()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: morePaddingAll(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: MAIN_COLOR,
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CartScreen(order: parkOrder!)));
                        },
                        title: Text(
                          "${parkOrder!.items.length} Item",
                          style: getTextStyle(
                              fontSize: SMALL_FONT_SIZE,
                              color: WHITE_COLOR,
                              fontWeight: FontWeight.normal),
                        ),
                        subtitle: Text("₹ ${_getItemTotal()}",
                            style: getTextStyle(
                                fontSize: LARGE_FONT_SIZE,
                                fontWeight: FontWeight.w600,
                                color: WHITE_COLOR)),
                        trailing: Text("View Cart",
                            style: getTextStyle(
                                fontSize: LARGE_FONT_SIZE,
                                fontWeight: FontWeight.w400,
                                color: WHITE_COLOR)),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> getProducts() async {
    //Fetching data from DbProduct database
    // products = await DbProduct().getProducts();
    // categories = Category.getCategories(products);
    categories = await DbCategory().getCategories();
    setState(() {});
  }

  Widget productCategoryList() {
    return ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider(
            thickness: 1,
          );
        },
        shrinkWrap: true,
        itemCount: categories.isEmpty ? 10 : categories.length,
        primary: false,
        itemBuilder: (context, position) {
          if (categories.isEmpty) {
            return const ProductShimmer();
          } else {
            return Column(
              children: [
                // category tile for product
                InkWell(
                  onTap: () {
                    setState(() {
                      categories[position].isExpanded =
                          !categories[position].isExpanded;
                    });
                  },
                  child: Padding(
                    padding: mediumPaddingAll(),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categories[position].name,
                              style: categories[position].isExpanded
                                  ? getTextStyle(
                                      fontSize: LARGE_FONT_SIZE,
                                      color: DARK_GREY_COLOR,
                                      fontWeight: FontWeight.w500)
                                  : getTextStyle(
                                      fontSize: MEDIUM_PLUS_FONT_SIZE,
                                      fontWeight: FontWeight.w500,
                                    ),
                            ),
                            categories[position].isExpanded
                                ? Container()
                                : Padding(
                                    padding: verticalSpace(x: 5),
                                    child: Text(
                                      "${categories[position].items.length} items",
                                      style: getTextStyle(
                                          color: MAIN_COLOR,
                                          fontWeight: FontWeight.normal,
                                          fontSize: SMALL_PLUS_FONT_SIZE),
                                    ),
                                  ),
                          ],
                        ),
                        const Spacer(),
                        SvgPicture.asset(
                          categories[position].isExpanded
                              ? CATEGORY_OPENED_ICON
                              : CATEGORY_CLOSED_ICON,
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
                // Expanded panel for a category
                categories[position].isExpanded
                    ? productList(categories[position].items)
                    : Container()
              ],
            );
          }
        });
  }

  Widget productList(List<Product> prodList) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: prodList.isEmpty ? 10 : prodList.length,
        primary: false,
        itemBuilder: (context, position) {
          if (prodList.isEmpty) {
            return const ProductShimmer();
          } else {
            return InkWell(
              onTap: () {
                var item = OrderItem.fromJson(prodList[position].toJson());

                _openItemDetailDialog(context, item);
              },
              child: CategoryItem(
                product: prodList[position],
              ),
            );
          }
        });
  }

  void goToSelectCustomer() async {
    var data = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const NewSelectCustomer()));
    if (data != null) {
      getProducts();
      setState(() {
        _selectedCust = data;
      });
    } else {
      if (!mounted) return;
      Navigator.pop(context);
    }
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
      if (parkOrder == null) {
        HubManager manager = await DbHubManager().getManager() as HubManager;
        parkOrder = ParkOrder(
            id: _selectedCust!.id,
            date: Helper.getCurrentDate(),
            time: Helper.getCurrentTime(),
            customer: _selectedCust!,
            items: [],
            orderAmount: 0,
            manager: manager,
            transactionDateTime: DateTime.now());
      }

      setState(() {
        if (product.orderedQuantity > 0 &&
            !parkOrder!.items.contains(product)) {
          OrderItem newItem = product;
          parkOrder!.items.add(newItem);
          _calculateOrderAmount();
        } else if (product.orderedQuantity == 0) {
          parkOrder!.items.remove(product);
          _calculateOrderAmount();
        }
      });
      DbParkedOrder().saveOrder(parkOrder!);
    }
    return res;
  }

  double _getItemTotal() {
    double total = 0;
    for (OrderItem item in parkOrder!.items) {
      total = total + (item.orderedPrice * item.orderedQuantity);
    }
    return total;
  }

  void _calculateOrderAmount() {
    double amount = 0;
    for (var item in parkOrder!.items) {
      amount += item.orderedPrice * item.orderedQuantity;
    }
    parkOrder!.orderAmount = amount;
  }
}
