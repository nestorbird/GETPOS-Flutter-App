import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          Center(
            child: SvgPicture.asset(
              SUCCESS_IMAGE,
              height: SALE_SUCCESS_IMAGE_HEIGHT,
              width: SALE_SUCCESS_IMAGE_WIDTH,
              fit: BoxFit.contain,
            ),
          ),
          hightSpacer30,
          Text(
            SALES_SUCCESS_TXT,
            style: getTextStyle(
                fontSize: LARGE_FONT_SIZE,
                color: DARK_GREY_COLOR,
                fontWeight: FontWeight.w500),
          ),
          hightSpacer30,
          LongButton(
            isAmountAndItemsVisible: false,
            buttonTitle: "Print Reciept",
            onTap: () {
              Navigator.pop(context, "print_receipt");
            },
          ),
          LongButton(
            isAmountAndItemsVisible: false,
            buttonTitle: RETURN_TO_HOME_TXT,
            onTap: () {
              Navigator.pop(context, "home");
            },
          ),
          LongButton(
            isAmountAndItemsVisible: false,
            buttonTitle: "New Order",
            onTap: () {
              Navigator.pop(context, "new_order");
            },
          ),
        ],
      ),
    );
  }
}
