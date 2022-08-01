import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ParkedOrderHeaderData extends StatefulWidget {
  String? heading;
  String? content;
  Color? headingColor;
  Color? contentColor;
  CrossAxisAlignment crossAlign;

  ParkedOrderHeaderData(
      {Key? key,
      this.heading,
      this.content,
      this.crossAlign = CrossAxisAlignment.start,
      this.headingColor = BLACK_COLOR,
      this.contentColor = BLACK_COLOR})
      : super(key: key);

  @override
  State<ParkedOrderHeaderData> createState() => _ParkedOrderHeaderDataState();
}

class _ParkedOrderHeaderDataState extends State<ParkedOrderHeaderData> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: widget.crossAlign,
      children: [
        Text(widget.heading!,
            style: getTextStyle(
                fontWeight: FontWeight.w500, color: widget.headingColor)),
        hightSpacer5,
        Text(
          widget.content!,
          style: getTextStyle(
              fontSize: MEDIUM_MINUS_FONT_SIZE,
              color: widget.contentColor,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
