// import 'package:nb_pos/configs/theme_config.dart';
// import 'package:nb_pos/constants/app_constants.dart';
// import 'package:nb_pos/core/add_products/ui/added_product_item.dart';
// import 'package:nb_pos/database/models/order_item.dart';
// import 'package:nb_pos/database/models/product.dart';
// import 'package:nb_pos/utils/ui_utils/padding_margin.dart';
// import 'package:nb_pos/utils/ui_utils/text_styles.dart/custom_text_style.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';

// // ignore: must_be_immutable
// class AddProductsWidget extends StatefulWidget {
//   Function(Product product)? onDelete;
//   Function(Product product)? onItemAdd;
//   Function(Product product)? onItemRemove;
//   Function? onAddMoreProducts;
//   List<OrderItem> orderedProducts;

//   AddProductsWidget(
//       {Key? key,
//       required this.onDelete,
//       required this.onItemAdd,
//       required this.onItemRemove,
//       required this.onAddMoreProducts,
//       required this.orderedProducts})
//       : super(key: key);

//   @override
//   _AddProductsWidgetState createState() => _AddProductsWidgetState();
// }

// class _AddProductsWidgetState extends State<AddProductsWidget> {
//   Widget dividerLine = Padding(
//       padding: topSpace(), child: const Divider(height: 1, color: GREY_COLOR));

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: horizontalSpace(),
//         child: Card(
//             elevation: 2.0,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
//               child: Column(
//                 children: [
//                   Align(
//                       alignment: AlignmentDirectional.topStart,
//                       child: Text(
//                         ADD_PRODUCT_TXT,
//                         style: getTextStyle(),
//                       )),
//                   ListView.separated(
//                       separatorBuilder: (context, index) {
//                         return dividerLine;
//                       },
//                       shrinkWrap: true,
//                       itemCount: widget.orderedProducts.length,
//                       primary: false,
//                       itemBuilder: (context, position) {
//                         return AddedProductItem(
//                           product: widget.orderedProducts[position],
//                           onDelete: () => widget
//                               .onDelete!(widget.orderedProducts[position]),
//                           onItemAdd: () => widget
//                               .onItemAdd!(widget.orderedProducts[position]),
//                           onItemRemove: () => widget
//                               .onItemRemove!(widget.orderedProducts[position]),
//                         );
//                       }),
//                   dividerLine,
//                   TextButton(
//                       onPressed: () => widget.onAddMoreProducts!(),
//                       child: Text(
//                         ADD_MORE_PRODUCTS,
//                         style: getTextStyle(color: MAIN_COLOR),
//                       ))
//                 ],
//               ),
//             )));
//   }
// }
