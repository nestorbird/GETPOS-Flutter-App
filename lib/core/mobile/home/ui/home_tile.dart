import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeTile extends StatelessWidget {
  final String title, asset;
  final Widget nextScreen;
  final Function onReturn;

  const HomeTile(
      {Key? key,
      required this.title,
      required this.asset,
      required this.nextScreen,
      required this.onReturn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => nextScreen));

        onReturn();
      },
      child: Container(
        decoration: BoxDecoration(
            color: OFF_WHITE_COLOR,
            border: Border.all(color: MAIN_COLOR, width: 0.4),
            borderRadius: BorderRadius.circular(BORDER_CIRCULAR_RADIUS_30)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: SvgPicture.asset(
                asset,
                height: HOME_TILE_ASSET_HEIGHT,
              ),
            ),
            hightSpacer20,
            Text(title,
                style: getTextStyle(
                    fontSize: MEDIUM_FONT_SIZE, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
