import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/utils/ui_utils/spacer_widget.dart';
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
                  fontSize: LARGE_FONT_SIZE,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getAsset())),
          hightSpacer10,
          Text("$appCurrency $cashCollected",
              style: getTextStyle(
                  color: AppColors.getPrimary(),
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
