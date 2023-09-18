import 'package:flutter/material.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';

import '../configs/theme_config.dart';
import '../constants/app_constants.dart';
import '../utils/ui_utils/card_border_shape.dart';
import '../utils/ui_utils/padding_margin.dart';
import '../utils/ui_utils/spacer_widget.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';

class SimplePopup extends StatefulWidget {
  final String message;
  final String buttonText;
  final Function onOkPressed;
  final bool hasCancelAction;

  const SimplePopup(
      {Key? key,
      required this.message,
      required this.buttonText,
      required this.onOkPressed,
      this.hasCancelAction = false})
      : super(key: key);

  @override
  State<SimplePopup> createState() => _SimplePopupState();
}

class _SimplePopupState extends State<SimplePopup> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        margin: morePaddingAll(x: 20),
        child: Center(
            child: Card(
          shape: cardBorderShape(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              hightSpacer15,
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: getTextStyle(fontSize: MEDIUM_PLUS_FONT_SIZE),
              ),
              hightSpacer20,
              const Divider(),
              widget.hasCancelAction
                  ? SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                              onTap: () => widget.onOkPressed(),
                              child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  child: Center(
                                      child: Text(
                                    widget.buttonText,
                                    style: getTextStyle(
                                        fontSize: MEDIUM_MINUS_FONT_SIZE),
                                  )))),
                          const VerticalDivider(
                            thickness: 1,
                          ),
                          InkWell(
                              onTap: () => Navigator.of(context)
                                  .pop(OPTION_CANCEL.toLowerCase()),
                              child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  child: Center(
                                      child: Text(
                                    OPTION_CANCEL,
                                    style: getTextStyle(
                                        fontSize: MEDIUM_MINUS_FONT_SIZE,
                                        color: AppColors.getAsset()),
                                  ))))
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () => widget.onOkPressed(),
                      child: SizedBox(
                          height: 20,
                          width: MediaQuery.of(context).size.width - 30,
                          child: Center(
                              child: Text(
                            widget.buttonText,
                            style:
                                getTextStyle(fontSize: MEDIUM_MINUS_FONT_SIZE),
                          )))),
              hightSpacer10
            ],
          ),
        )));
  }
}
