import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/database/db_utils/db_product.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/asset_paths.dart';

import '../../../../database/db_utils/db_categories.dart';
import '../../../../database/models/category.dart';
import '../../../../database/models/product.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../widgets/product_shimmer_widget.dart';
import '../../../../widgets/product_widget.dart';
import '../../../../widgets/search_widget.dart';
import '../../create_order_new/ui/widget/category_item.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<Product> products = [];
  List<Category> categories = [];
  late TextEditingController searchProductCtrl;
  bool isProductGridEnable = true;

  @override
  void initState() {
    super.initState();
    searchProductCtrl = TextEditingController();
    getProducts();
    // ProductsService().getCategoryProduct();
  }

  @override
  void dispose() {
    searchProductCtrl.dispose();
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
          physics: categories.isEmpty
              ? const NeverScrollableScrollPhysics()
              : const ScrollPhysics(),
          child: Column(
            children: [
              const CustomAppbar(title: PRODUCTS_TXT),
              hightSpacer15,
              Padding(
                padding: horizontalSpace(),
                child: SearchWidget(
                  searchHint: SEARCH_PRODUCT_TXT,
                  searchTextController: searchProductCtrl,
                  onTextChanged: (text) {
                    if (text.isNotEmpty) {
                      debugPrint("entered text1: $text");
                    }
                  },
                  onSubmit: (text) {
                    if (text.isNotEmpty) {
                      debugPrint("entered text2: $text");
                    }
                  },
                ),
              ),
              hightSpacer15,
              isProductGridEnable ? productGrid() : productCategoryList(),
            ],
          ),
        ),
      ),
    );
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
                                      color: AppColors.getAsset(),
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
                                          color: AppColors.getPrimary(),
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

  Widget productList(prodList) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: prodList.isEmpty ? 10 : prodList.length,
        primary: false,
        itemBuilder: (context, position) {
          if (prodList.isEmpty) {
            return const ProductShimmer();
          } else {
            return CategoryItem(
              product: prodList[position],
            );
            // return SalesDetailsItems(
            //   product: prodList[position],
            // );
            // return ListTile(title: Text(prodList[position].name));
          }
        });
  }

  Widget productGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: GridView.builder(
        itemCount: products.isEmpty ? 10 : products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 16,
          childAspectRatio: 0.80,
        ),
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, position) {
          if (products.isEmpty) {
            return const ProductShimmer();
          } else {
            return ProductWidget(
              title: products[position].name,
              asset: products[position].productImage,
              enableAddProductButton: false,
              product: products[position],
            );
          }
        },
      ),
    );
  }

  Future<void> getProducts() async {
    //Fetching data from DbProduct database
    products = await DbProduct().getProducts();
    log("Taxes saved in DB with Product Stock and Product Price");
    // categories = Category.getCategories(products);
    categories = await DbCategory().getCategories();

    setState(() {});
  }
}
