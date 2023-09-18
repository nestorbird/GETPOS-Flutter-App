import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';

import '../configs/theme_config.dart';
import '../constants/app_constants.dart';
import '../constants/asset_paths.dart';
import '../utils/ui_utils/card_border_shape.dart';
import '../utils/ui_utils/padding_margin.dart';
import '../utils/ui_utils/spacer_widget.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';

// ignore: must_be_immutable
class LongButton extends StatefulWidget {
  final String buttonTitle;
  final bool isAmountAndItemsVisible;

  String? totalAmount;
  String? totalItems;

  Function? onTap;

  LongButton(
      {Key? key,
      required this.isAmountAndItemsVisible,
      required this.buttonTitle,
      this.totalAmount,
      this.totalItems,
      this.onTap})
      : super(key: key);

  @override
  State<LongButton> createState() => _LongButtonState();
}

class _LongButtonState extends State<LongButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: SizedBox(
            height: 60,
            child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: cardBorderShape(),
                child: Container(
                    decoration: BoxDecoration(
                        gradient: widget.isAmountAndItemsVisible
                            ? LinearGradient(
                                begin: const Alignment(0.0, 0.5),
                                end: const Alignment(0.5, 0.5),
                                stops: const [
                                    0.0,
                                    0.0,
                                  ],
                                colors: [
                                    AppColors.getPrimary(),
                                   AppColors.getPrimary().withOpacity(0.9)
                                  ])
                            :  LinearGradient(
                                begin:const Alignment(0.0, 0.5),
                                end:const Alignment(0.5, 0.5),
                                stops: const [0.0, 0.0],
                                colors: [AppColors.getPrimary(), AppColors.getPrimary()],
                              )),
                    child: Padding(
                      padding: mediumPaddingAll(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                              visible: widget.isAmountAndItemsVisible,
                              child: Expanded(
                                  flex: 20,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        CREATE_ORDER_BASKET_IMAGE,
                                        height: 25,
                                        width: 25,
                                        fit: BoxFit.contain,
                                      ),
                                      widthSpacer(5),
                                      Text(
                                        '${widget.totalItems}\n$ITEMS_TXT',
                                        style: getTextStyle(
                                            color: WHITE_COLOR,
                                            fontWeight: FontWeight.normal),
                                      )
                                    ],
                                  ))),
                          Visibility(
                              visible: widget.isAmountAndItemsVisible,
                              child: Expanded(
                                  flex: 25,
                                  child: Text(
                                    '$appCurrency${widget.totalAmount}',
                                    style: getTextStyle(
                                        fontSize: MEDIUM_PLUS_FONT_SIZE,
                                        color: WHITE_COLOR),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                          Expanded(
                            flex: 50,
                            child: TextButton(
                                onPressed: () => widget.onTap!(),
                                child: Text(widget.buttonTitle,
                                    style: getTextStyle(
                                      fontSize: MEDIUM_MINUS_FONT_SIZE,
                                      fontWeight: FontWeight.bold,
                                      color: WHITE_COLOR,
                                    ))),
                          )
                        ],
                      ),
                    )))));
  }
}
