import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../configs/theme_config.dart';
import '../../../constants/app_constants.dart';
import '../../../utils/ui_utils/padding_margin.dart';
import '../../../utils/ui_utils/spacer_widget.dart';
import '../../../utils/ui_utils/text_styles/custom_text_style.dart';

class AlertDialogWidget {
  Future show(String question, String positiveOption,
      {bool hasCancelAction = false}) {
    var body = Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: WHITE_COLOR),
      child: Column(
        children: [
          Text(
            question,
            style: getTextStyle(fontSize: LARGE_PLUS_FONT_SIZE),
          ),
          hightSpacer25,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.back(result: positiveOption.toLowerCase());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: MAIN_COLOR,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(positiveOption,
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                            fontSize: MEDIUM_PLUS_FONT_SIZE,
                            color: WHITE_COLOR)),
                  ),
                ),
              ),
              hasCancelAction ? widthSpacer(10) : const SizedBox(),
              hasCancelAction
                  ? Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back(result: "no");
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: DARK_GREY_COLOR.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text("No",
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                  fontSize: MEDIUM_PLUS_FONT_SIZE)),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          )
        ],
      ),
    );
    // return body;

    // return Future.delayed(Duration.zero, () {});
    return Get.defaultDialog(
      barrierDismissible: false,
      // contentPadding: paddingXY(x: 0, y: 0),
      title: "",
      titlePadding: paddingXY(x: 0, y: 0),
      // custom: Container(),
      content: body,
    );
  }
}
