import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/asset_paths.dart';
import '../../../../database/models/customer.dart';
import '../../../../utils/ui_utils/card_border_shape.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class SelectedCustomerWidget extends StatefulWidget {
  Function? onDelete;
  Function? onTapChangeCustomer;
  Customer? selectedCustomer;

  SelectedCustomerWidget(
      {Key? key,
      this.onDelete,
      this.onTapChangeCustomer,
      this.selectedCustomer})
      : super(key: key);

  @override
  State<SelectedCustomerWidget> createState() => _SelectedCustomerWidgetState();
}

class _SelectedCustomerWidgetState extends State<SelectedCustomerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: horizontalSpace(),
        child: Card(
          child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
              child: Column(
                children: [
                  Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        SELECT_CUSTOMER_TXT,
                        style: getTextStyle(),
                      )),
                  hightSpacer10,
                  ListTile(
                    contentPadding: horizontalSpace(x: 0),
                    leading: SizedBox(
                      height: 70,
                      width: 70,
                      child: Card(
                        color: MAIN_COLOR.withOpacity(0.1),
                        shape: cardBorderShape(),
                        elevation: 0.0,
                        child: Container(),
                        // child: Padding(
                        //     padding: mediumPaddingAll(),
                        //     child: widget.selectedCustomer!.profileImage.isEmpty
                        //         ? SvgPicture.asset(
                        //             HOME_CUSTOMER_IMAGE,
                        //             height: 35,
                        //             width: 35,
                        //             fit: BoxFit.contain,
                        //           )
                        //         : Image.memory(
                        //             widget.selectedCustomer!.profileImage,
                        //           )),
                      ),
                    ),
                    title: Text(
                      widget.selectedCustomer!.name,
                      style: getTextStyle(
                          fontSize: SMALL_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      widget.selectedCustomer!.phone,
                      style: getTextStyle(
                          fontSize: SMALL_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: IconButton(
                        onPressed: () => widget.onDelete!(),
                        icon: Padding(
                            padding: miniPaddingAll(),
                            child: SvgPicture.asset(
                              DELETE_IMAGE,
                              height: 35,
                              width: 35,
                              fit: BoxFit.contain,
                            ))),
                  ),
                  hightSpacer10,
                  const Divider(
                    height: 1,
                    color: GREY_COLOR,
                  ),
                  TextButton(
                      onPressed: () => widget.onTapChangeCustomer!(),
                      child: Text(
                        CHANGE_CUSTOMER_TXT,
                        style: getTextStyle(color: MAIN_COLOR),
                      ))
                ],
              )),
        ));
  }
}
