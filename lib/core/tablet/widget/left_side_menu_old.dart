// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:nb_posx/configs/theme_dynamic_colors.dart';

// import '../../../constants/app_constants.dart';
// import '../../../constants/asset_paths.dart';
// import '../../../utils/ui_utils/padding_margin.dart';
// import '../../../utils/ui_utils/spacer_widget.dart';
// import '../../../utils/ui_utils/text_styles/custom_text_style.dart';

// import '../home/home_landscape.dart';

// // ignore: must_be_immutable
// class LeftSideMenu extends StatefulWidget {
//   RxString selectedView;

//   LeftSideMenu({Key? key, required this.selectedView}) : super(key: key);

//   @override
//   State<LeftSideMenu> createState() => _LeftSideMenuState();
// }

// class _LeftSideMenuState extends State<LeftSideMenu> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 80,
//       height: Get.size.height,
//       color: AppColors.fontWhiteColor,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Container(
//             padding: morePaddingAll(),
//             decoration: BoxDecoration(
//                 color:AppColors.getPrimary(),
//                 borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(15),
//                     topRight: Radius.circular(15))),
//             child: Text(
//               "POS",
//               textAlign: TextAlign.center,
//               style: getTextStyle(
//                   color: AppColors.fontWhiteColor, fontSize: MEDIUM_PLUS_FONT_SIZE),
//             ),
//           ),
//           _leftMenuSectionItem("Home", CREATE_ORDER_IMAGE, 50, () {
//             debugPrint("Home");
//             Get.off(const HomeLandscape(),
//                 duration: const Duration(milliseconds: 0));
//           }),
//           _leftMenuSectionItem("Order", CREATE_ORDER_IMAGE, 50, () {
//             debugPrint("order");
//           }),
//           _leftMenuSectionItem("Product", PRODUCT_IMAGE, 50, () {}),
//           _leftMenuSectionItem("Customer", HOME_USER_IMAGE, 50, () {}),
//           _leftMenuSectionItem("History", SALES_IMAGE, 50, () {}),
//           _leftMenuSectionItem("Finance", FINANCE_IMAGE, 50, () {
//             // Get.off(const FinanceLandscape(),
//             //     duration: const Duration(milliseconds: 0));
//           }),
//           _leftMenuSectionItem("Logout", LOGOUT_IMAGE, 25, () {
//             Get.defaultDialog(
//                 onCancel: () => Get.back(),
//                 title: "Do you want to logout?",
//                 content: Container(),
//                 confirm: const Text("Yes"),
//                 confirmTextColor:AppColors.getPrimary(),
//                 cancel: const Text("Cancel"));
//           }),
//         ],
//       ),
//     );
//   }

//   _leftMenuSectionItem(
//       String title, String iconData, double width, Function() action) {
//     return InkWell(
//       onTap: () => action(),
//       child: Container(
//         margin: paddingXY(y: 5),
//         height: 75,
//         decoration: BoxDecoration(
//           color: title.toLowerCase() == widget.selectedView.toLowerCase()
//               ?  AppColors.getPrimary()
//               : AppColors.fontWhiteColor,
//           borderRadius: BorderRadius.circular(5),
//           boxShadow: const [BoxShadow(blurRadius: 0.05)],
//           border: Border.all(width: 1, color: AppColors.shadowBorder!),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SvgPicture.asset(
//               iconData,
//               // color: MAIN_COLOR,
//               width: width,
//             ),
//             Text(
//               title,
//               style: getTextStyle(
//                 fontWeight: FontWeight.w400,
//                 color: title.toLowerCase() == widget.selectedView.toLowerCase()
//                     ? AppColors.fontWhiteColor
//                     : AppColors.getTextandCancelIcon(),
//               ),
//             ),
//             hightSpacer10,
//           ],
//         ),
//       ),
//     );
//   }
// }
