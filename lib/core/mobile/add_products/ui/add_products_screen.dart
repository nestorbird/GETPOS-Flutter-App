// import 'package:nb_pos/constants/app_constants.dart';
// import 'package:nb_pos/database/db_utils/db_product.dart';
// import 'package:nb_pos/database/models/product.dart';
// import 'package:nb_pos/utils/helper.dart';
// import 'package:nb_pos/utils/ui_utils/spacer_widget.dart';
// import 'package:nb_pos/utils/ui_utils/padding_margin.dart';
// import 'package:nb_pos/utils/ui_utils/text_styles.dart/custom_text_style.dart';
// import 'package:nb_pos/widgets/custom_appbar.dart';
// import 'package:nb_pos/widgets/long_button_widget.dart';
// import 'package:nb_pos/widgets/product_shimmer_widget.dart';
// import 'package:nb_pos/widgets/product_widget.dart';
// import 'package:nb_pos/widgets/search_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class AddProductsScreen extends StatefulWidget {
//   List<Product> orderedProducts;

//   AddProductsScreen({Key? key, required this.orderedProducts})
//       : super(key: key);

//   @override
//   _AddProductsScreenState createState() => _AddProductsScreenState();
// }

// class _AddProductsScreenState extends State<AddProductsScreen> {
//   List<Product> products = [];
//   List<Product> orderedProducts = [];
//   List<Product> productsToOrder = [];
//   late double totalAmount;
//   int totalItems = 0;
//   late TextEditingController searchProductsController;
//   bool isProductsFound = true;

//   @override
//   void initState() {
//     super.initState();
//     searchProductsController = TextEditingController();
//     getProducts(0);
//     orderedProducts.addAll(widget.orderedProducts);

//     totalItems = widget.orderedProducts.length;
//     totalAmount = 0.0;
//     orderedProducts.forEach((product) async {
//       totalAmount = totalAmount + (product.price * product.orderedQuantity);
//     });
//   }

//   @override
//   void dispose() {
//     searchProductsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: products.isEmpty
//               ? const NeverScrollableScrollPhysics()
//               : const ScrollPhysics(),
//           child: Column(
//             children: [
//               const CustomAppbar(title: ADD_PRODUCT_TXT),
//               hightSpacer10,
//               Container(
//                   margin: horizontalSpace(),
//                   child: SearchWidget(
//                     searchHint: ADD_PRODUCTS_SEARCH_TXT,
//                     searchTextController: searchProductsController,
//                     onTextChanged: (text) {
//                       if (text.isNotEmpty) {
//                         filterProductsData(text);
//                       } else {
//                         getProducts(0);
//                       }
//                     },
//                     onSubmit: (text) {
//                       if (text.isNotEmpty) {
//                         filterProductsData(text);
//                       } else {
//                         getProducts(0);
//                       }
//                     },
//                   )),
//               Visibility(
//                   visible: isProductsFound,
//                   child: Padding(
//                       padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//                       child: GridView.builder(
//                         itemCount: products.isEmpty ? 10 : products.length,
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                                 mainAxisSpacing: 16,
//                                 crossAxisSpacing: 16,
//                                 childAspectRatio: 0.80,
//                                 mainAxisExtent: 215),
//                         shrinkWrap: true,
//                         padding: bottomSpace(),
//                         physics: const BouncingScrollPhysics(),
//                         itemBuilder: (context, position) {
//                           if (products.isEmpty) {
//                             return const ProductShimmer();
//                           } else {
//                             return ProductWidget(
//                               title: ADD_PRODUCT_TITLE,
//                               asset: products[position].productImage,
//                               enableAddProductButton: true,
//                               product: products[position],
//                               onAddToCart: () {
//                                 Product product = products[position];
//                                 addProductIntoCart(product);
//                               },
//                             );
//                           }
//                         },
//                       ))),
//               Visibility(
//                   visible: !isProductsFound,
//                   child: Center(
//                       child: Text(
//                     NO_DATA_FOUND,
//                     style: getTextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: SMALL_PLUS_FONT_SIZE),
//                   )))
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: LongButton(
//         buttonTitle: ADD_CONTINUE,
//         isAmountAndItemsVisible: true,
//         totalAmount: '$totalAmount',
//         totalItems: '$totalItems',
//         onTap: () {
//           productsToOrder.clear();
//           productsToOrder.addAll(orderedProducts);
//           Navigator.pop(context, productsToOrder);
//         },
//       ),
//     );
//   }

//   Future<void> getProducts(val) async {
//     //Fetching data from DbProduct database
//     products = await DbProduct().getAllProducts();
//     isProductsFound = products.isNotEmpty;
//     if (val == 0) setState(() {});
//   }

//   void addProductIntoCart(Product product) async {
//     Product productData = product;

//     Product prod = orderedProducts.singleWhere(
//         (element) => element.id == product.id,
//         orElse: () => productData);

//     if (prod.orderedQuantity + 1 <= productData.stock) {
//       if (orderedProducts.any((element) => element.id == productData.id)) {
//         //productData.orderedQuantity = productData.orderedQuantity + 1;
//         int indexOfProduct = orderedProducts
//             .indexWhere((element) => element.id == productData.id);
//         Product tempProduct = orderedProducts.elementAt(indexOfProduct);
//         productData.orderedQuantity = tempProduct.orderedQuantity + 1;
//         orderedProducts.removeAt(indexOfProduct);
//         orderedProducts.insert(indexOfProduct, productData);
//       } else {
//         productData.orderedQuantity = productData.orderedQuantity + 1;
//         orderedProducts.add(productData);
//       }
//       totalItems = orderedProducts.length;
//       totalAmount = 0.0;
//       orderedProducts.forEach((product) {
//         totalAmount = totalAmount + (product.price * product.orderedQuantity);
//       });

//       setState(() {});
//     } else {
//       Helper.showSnackBar(context, INSUFFICIENT_STOCK_ERROR);
//     }
//   }

//   void filterProductsData(String searchText) async {
//     await getProducts(1);
//     products = products
//         .where((element) =>
//             element.name.toLowerCase().contains(searchText.toLowerCase()) ||
//             element.id.toLowerCase().contains(searchText.toLowerCase()))
//         .toList();
//     isProductsFound = products.isNotEmpty;
//     setState(() {});
//   }
// }
