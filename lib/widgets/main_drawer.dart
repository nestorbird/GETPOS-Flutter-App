import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../configs/theme_config.dart';
import '../constants/app_constants.dart';
import '../constants/asset_paths.dart';
import '../utils/ui_utils/padding_margin.dart';
import '../utils/ui_utils/spacer_widget.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';

// ignore: must_be_immutable
class MainDrawer extends StatelessWidget {
  List<Map> menuItem;
  MainDrawer({Key? key, required this.menuItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            color: MAIN_COLOR,
            padding: morePaddingAll(),
            child: Row(
              children: [
                SvgPicture.asset(
                  MENU_ICON,
                  color: WHITE_COLOR,
                  width: 20,
                ),
                widthSpacer(10),
                Text(
                  "Menu",
                  style: getTextStyle(
                      color: WHITE_COLOR,
                      fontSize: LARGE_FONT_SIZE,
                      fontWeight: FontWeight.w400),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: miniPaddingAll(),
                    child: SvgPicture.asset(
                      CROSS_ICON,
                      color: WHITE_COLOR,
                      width: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
          hightSpacer20,
          ListView.builder(
              itemCount: menuItem.length,
              shrinkWrap: true,
              itemBuilder: (context, position) {
                return _buildMenuItem(context, menuItem[position]["title"],
                    menuItem[position]["action"]);
              }),
          // _buildMenuItem(context, "Create new sale", () async {
          //   Navigator.pop(context);
          //   Navigator.popUntil(context, (route) => route.isFirst);
          //   Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => NewCreateOrder()));
          // }),
          // _buildMenuItem(context, "Parked orders", () async {
          //   Navigator.pop(context);
          //   // Navigator.popUntil(context, (route) => route.isFirst);
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => const OrderListScreen()));
          // }),
          // _buildMenuItem(context, "Home", () {
          //   Navigator.popUntil(context, (route) => route.isFirst);
          // }),
        ],
      ),
    );
  }

  _buildMenuItem(BuildContext context, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: paddingXY(x: 15),
        child: Text(
          title,
          style: getTextStyle(
              fontWeight: FontWeight.w400,
              color: DARK_GREY_COLOR,
              fontSize: MEDIUM_FONT_SIZE),
        ),
      ),
    );
  }
}
