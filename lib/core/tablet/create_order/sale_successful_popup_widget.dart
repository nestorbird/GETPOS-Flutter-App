import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import '../../../configs/theme_config.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/asset_paths.dart';
import '../../../utils/ui_utils/spacer_widget.dart';
import '../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../widgets/long_button_widget.dart';

class SaleSuccessfulPopup extends StatelessWidget {
  const SaleSuccessfulPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width / 2.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: InkWell(
                    onTap: () => Navigator.pop(context, "home"),
                    child: SvgPicture.asset(
                      CROSS_ICON,
                      height: 16,
                      width: 16,
                      color: BLACK_COLOR,
                    ),
                  ))),
          Center(
            child: Lottie.asset(SUCCESS_IMAGE,
                animate:
                    true), /*SvgPicture.asset(
              SUCCESS_IMAGE,
              height: SALE_SUCCESS_IMAGE_HEIGHT,
              width: SALE_SUCCESS_IMAGE_WIDTH,
              fit: BoxFit.contain,
            ),*/
          ),
          hightSpacer30,
          Text(
            "Order Successful",
            style: getTextStyle(
                fontSize: LARGE_PLUS_FONT_SIZE,
                color: BLACK_COLOR,
                fontWeight: FontWeight.w600),
          ),
          hightSpacer30,
          Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: LongButton(
                isAmountAndItemsVisible: false,
                buttonTitle: "Print Receipt",
                onTap: () {
                  Navigator.pop(context, "home");
                },
              )),
          Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: LongButton(
                isAmountAndItemsVisible: false,
                buttonTitle: RETURN_TO_HOME_TXT,
                onTap: () {
                  Navigator.pop(context, "home");
                },
              )),
          Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: LongButton(
                isAmountAndItemsVisible: false,
                buttonTitle: "New Order",
                onTap: () {
                  Navigator.pop(context, "new_order");
                },
              )),
        ],
      ),
    );
  }
}
