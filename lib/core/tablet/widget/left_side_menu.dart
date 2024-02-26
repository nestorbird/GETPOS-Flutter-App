import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/constants/app_constants.dart';

import '../../../constants/asset_paths.dart';
import '../../../utils/ui_utils/padding_margin.dart';
import '../../../utils/ui_utils/spacer_widget.dart';
import '../../../utils/ui_utils/text_styles/custom_text_style.dart';

class LeftSideMenu extends StatelessWidget {
  final RxString selectedView;
  const LeftSideMenu({Key? key, required this.selectedView}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: Get.size.height,
      color: AppColors.fontWhiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            //padding: morePaddingAll(),
            decoration: const BoxDecoration(
                // color: MAIN_COLOR,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(15))),
            child: Padding(
              padding: verticalSpace(x: 0),
              child: Image.asset(
                App_ICON_TABLET,
                fit: BoxFit.fill,
              ),
              // child: Text(
              //   "POS",
              //   textAlign: TextAlign.center,
              //   style: getTextStyle(
              //       color: AppColors.fontWhiteColor, fontSize: LARGE_MINUS_FONT_SIZE),
              // ),
            ),
          ),
          hightSpacer15,
          /*    _leftMenuSectionItem("Home", HOME_TAB_ICON, 30, () {
            selectedView.value = "Home";
          }),*/
          // hightSpacer10,
          _leftMenuSectionItem("Order", ORDER_TAB_ICON, 30, () {
            selectedView.value = "Order";
            // debugPrint("order");
          }),
          /*   hightSpacer10,
          _leftMenuSectionItem("Product", PRODUCE_TAB_ICON, 30, () {
            selectedView.value = "Product";
          }),*/
          hightSpacer10,
          _leftMenuSectionItem("Customer", CUSTOMER_TAB_ICON, 30, () {
            selectedView.value = "Customer";
          }),
          hightSpacer10,
          _leftMenuSectionItem("History", HISTORY_TAB_ICON, 30, () {
            selectedView.value = "History";
          }),
          hightSpacer10,
          _leftMenuSectionItem("My Profile", PROFILE_TAB_ICON, 30, () {
            selectedView.value = "My Profile";
          }),
        //      hightSpacer10,
        //   _leftMenuSectionItem("Open Shift", PROFILE_TAB_ICON, 30, () {
        //     selectedView.value = "Open Shift";
        //  }),
        ],
      ),
    );
  }

  _leftMenuSectionItem(
      String title, String iconData, double width, Function() action) {
    return InkWell(
      onTap: () => action(),
      child: Obx(() => Container(
            margin: const EdgeInsets.fromLTRB(4, 1, 4, 5),
            // height: 75,
            decoration: BoxDecoration(
              color: title.toLowerCase() == selectedView.toLowerCase()
                  ? AppColors.getPrimary()
                  : AppColors.fontWhiteColor,
              borderRadius: BorderRadius.circular(12),
              // boxShadow: const [BoxShadow(blurRadius: 0.05)],
              border: Border.all(width: 1, color: AppColors.shadowBorder!),
            ),
            child: Wrap(
              // mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Center(
                    child: SvgPicture.asset(
                      iconData,
                      color: title.toLowerCase() == selectedView.toLowerCase()
                          ? AppColors.fontWhiteColor
                          : AppColors.getAsset(),
                      width: width,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 10),
                  child: Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: getTextStyle(
                        fontSize: MEDIUM_MINUS_FONT_SIZE,
                        fontWeight: FontWeight.w500,
                        color: title.toLowerCase() == selectedView.toLowerCase()
                            ? AppColors.fontWhiteColor
                            : AppColors.getTextandCancelIcon(),
                      ),
                    ),
                  ),
                ),
                Text(""),
                hightSpacer40,
              ],
            ),
          )),
    );
  }
}
