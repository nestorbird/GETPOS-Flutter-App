import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../utils/ui_utils/card_border_shape.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../utils/ui_utils/text_styles/edit_text_hint_style.dart';
import '../../../../utils/ui_utils/textfield_border_decoration.dart';

// ignore: must_be_immutable
class PaymentWidget extends StatefulWidget {
  final String? svgIconPath;
  final String? title;
  final bool? isCODPayment;
  final bool? isMPesa;
  final bool? isEWallet;
  bool? isChecked;
  TextEditingController? textEditingController;
  Function(bool isPaymentOptionChanged)? isSelected;

  PaymentWidget(
      {Key? key,
      this.svgIconPath,
      this.title,
      this.isCODPayment = false,
      this.isEWallet = false,
      this.isMPesa = false,
      this.isChecked,
      this.isSelected,
      this.textEditingController})
      : super(key: key);

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: cardBorderShape(radius: CARD_BORDER_SIDE_RADIUS_08),
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(
                height: 50,
                width: 50,
                child: Card(
                  elevation: 0.0,
                  color: WHITE_COLOR,
                  shape: cardBorderShape(radius: CARD_BORDER_SIDE_RADIUS_08),
                  child: Padding(
                      padding: mediumPaddingAll(),
                      child: SvgPicture.asset(
                        widget.svgIconPath!,
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      )),
                )),
            title: Text(
              widget.title!,
              style: getTextStyle(
                fontSize: SMALL_PLUS_FONT_SIZE,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: InkWell(
              onTap: () => widget.isSelected!(!widget.isChecked!),
              child: widget.isChecked!
                  ? Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        border: Border.all(color: MAIN_COLOR),
                        // border: Border.all(color: Colors.yellow.shade800),
                        color: MAIN_COLOR,
                        // color: Colors.yellow.shade800,
                        borderRadius:
                            BorderRadius.circular(BORDER_CIRCULAR_RADIUS_08),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 20.0,
                        color: WHITE_COLOR,
                      ))
                  : Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: BLACK_COLOR),
                        borderRadius:
                            BorderRadius.circular(BORDER_CIRCULAR_RADIUS_08),
                      ),
                      child: const Icon(
                        null,
                        size: 20.0,
                      ),
                    ),
            ),
          ),
          Visibility(
              visible: widget.isChecked!,
              child: SizedBox(
                height: 0.5,
                child: Container(
                  color: GREY_COLOR,
                ),
              )),
          Visibility(visible: widget.isChecked!, child: _getBottomWidget)
        ],
      ),
    );
  }

  Widget get _getBottomWidget {
    if (widget.isCODPayment!) {
      return Padding(
          padding: mediumPaddingAll(),
          child: Text(
            CASH_PAYMENT_MSG,
            style: getTextStyle(fontWeight: FontWeight.normal),
          ));
    } else if (widget.isMPesa!) {
      return Padding(
        padding: mediumPaddingAll(),
        child: SizedBox(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TRANSACTION_TXT,
                style: getTextStyle(fontSize: SMALL_PLUS_FONT_SIZE),
              ),
              Container(
                decoration: txtFieldBorderDecoration,
                child: TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-z,A-Z,0-9]")),
                    LengthLimitingTextInputFormatter(12)
                  ],
                  style: getTextStyle(
                      color: GREY_COLOR,
                      fontSize: MEDIUM_FONT_SIZE,
                      fontWeight: FontWeight.w600),
                  controller: widget.textEditingController,
                  cursorColor: LIGHT_GREY_COLOR,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: ENTER_UR_TRANSACTION_ID,
                    hintStyle: getHintStyle(),
                    focusColor: LIGHT_GREY_COLOR,
                    contentPadding: leftSpace(),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
