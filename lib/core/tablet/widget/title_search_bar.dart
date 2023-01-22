import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/button.dart';
import '../../../widgets/search_widget_tablet.dart';

// ignore: must_be_immutable
class TitleAndSearchBar extends StatelessWidget {
  final String title;
  final String? searchHint;
  final double? searchBoxWidth;
  final bool searchBoxVisible;
  final bool parkedOrderVisible;
  final TextEditingController? searchCtrl;
  final bool hideOperatorDetails;
  Function(String changedtext)? onTextChanged;
  Function(String text)? onSubmit;
  Function? parkOrderClicked;

  TitleAndSearchBar(
      {Key? key,
      required this.title,
      this.searchHint,
      this.searchCtrl,
      this.searchBoxWidth = 300,
      this.searchBoxVisible = true,
      this.parkedOrderVisible = false,
      this.hideOperatorDetails = false,
      this.onTextChanged,
      this.parkOrderClicked,
      this.onSubmit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: getTextStyle(
                  fontSize: LARGE_PLUS_FONT_SIZE, color: BLACK_COLOR),
            ),
            const Spacer(),
            Visibility(
              visible: searchBoxVisible,
              child: Container(
                width: searchBoxWidth,
                padding: horizontalSpace(x: 10),
                child: SearchWidgetTablet(
                  searchHint: searchHint,
                  searchTextController: searchCtrl,
                  onTextChanged: (val) => onTextChanged!(val),
                  onSubmit: (val) => onSubmit!(val),
                ),
              ),
            ),
            parkedOrderVisible ? const Spacer() : Container(),
            Visibility(
              visible: parkedOrderVisible,
              child: parkOrderBtnWidget,
            ),
          ],
        ),
        hightSpacer10,
        Visibility(
          visible: !hideOperatorDetails,
          child: Padding(
            padding: topSpace(y: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  MY_PROFILE_TAB_IMAGE,
                  // color: MAIN_COLOR,
                  width: 15,
                ),
                widthSpacer(10),
                Text(
                  Helper.hubManager != null
                      ? Helper.hubManager!.name
                      : "Hub manager",
                  style: getTextStyle(
                      fontSize: MEDIUM_PLUS_FONT_SIZE,
                      fontWeight: FontWeight.bold),
                ),
                widthSpacer(10)
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget get parkOrderBtnWidget => SizedBox(
        // width: double.infinity,
        child: ButtonWidget(
          onPressed: () => parkOrderClicked!(),
          title: "Parked Order",
          colorBG: BLACK_COLOR,
          width: 200,
          borderRadius: 15,
          fontSize: LARGE_MINUS_FONT_SIZE,
        ),
      );
}
