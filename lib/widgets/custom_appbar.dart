import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../configs/theme_config.dart';
import '../constants/app_constants.dart';
import '../constants/asset_paths.dart';
import '../utils/ui_utils/padding_margin.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  final bool showBackBtn;
  final bool hideSidemenu;
  final Color backBtnColor;

  const CustomAppbar(
      {Key? key,
      required this.title,
      this.showBackBtn = true,
      this.hideSidemenu = false,
      this.backBtnColor = BLACK_COLOR})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle headerStyle =
        getTextStyle(fontSize: LARGE_MINUS_FONT_SIZE, color: DARK_GREY_COLOR);

    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5),
      child: showBackBtn
          ? Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: smallPaddingAll(),
                    child: SvgPicture.asset(
                      BACK_IMAGE,
                      color: backBtnColor,
                      width: 25,
                    ),
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
                Padding(
                  padding: smallPaddingAll(),
                  child: Text(
                    title,
                    style: headerStyle,
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
                hideSidemenu ? _getBlankSideMenu() : _getSideMenu(context)
              ],
            )
          : Center(
              child: Padding(
                padding: smallPaddingAll(),
                child: Text(
                  title,
                  style: headerStyle,
                ),
              ),
            ),
    );
  }

  _getBlankSideMenu() {
    // return Padding(
    //   padding: mediumPaddingAll(),
    //   child: SvgPicture.asset(
    //     MENU_ICON,
    //     color: WHITE_COLOR,
    //     width: 20,
    //   ),
    // );
    return Container(width: 30);
  }

  _getSideMenu(context) {
    return InkWell(
      onTap: () {
        debugPrint("Menu Clicked ");
        Scaffold.of(context).openEndDrawer();
      },
      child: Padding(
        padding: mediumPaddingAll(),
        child: SvgPicture.asset(
          MENU_ICON,
          color: backBtnColor,
          width: 20,
        ),
      ),
    );
  }
}
