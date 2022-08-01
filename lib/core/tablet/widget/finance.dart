import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';

// ignore: must_be_immutable
class FinanceView extends StatelessWidget {
  String? cashCollected;
  FinanceView({Key? key, this.cashCollected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height - 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Cash Balance",
              style: getTextStyle(
                  fontSize: LARGE_FONT_SIZE, fontWeight: FontWeight.w500)),
          Text("USD $cashCollected",
              style: getTextStyle(
                  color: MAIN_COLOR,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
