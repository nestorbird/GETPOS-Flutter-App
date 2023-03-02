import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../configs/theme_config.dart';
import '../constants/app_constants.dart';
import '../constants/asset_paths.dart';
import '../utils/ui_utils/padding_margin.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';
import '../utils/ui_utils/text_styles/edit_text_hint_style.dart';
import '../utils/ui_utils/textfield_border_decoration.dart';

// ignore: must_be_immutable
class SearchWidget extends StatefulWidget {
  final String? searchHint;
  final TextEditingController? searchTextController;
  Function(String changedtext)? onTextChanged;
  Function(String text)? onSubmit;
  final TextInputType keyboardType;

  SearchWidget(
      {Key? key,
      this.searchHint,
      this.searchTextController,
      this.onTextChanged,
      this.onSubmit,
      this.keyboardType = TextInputType.text})
      : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: searchTxtFieldBorderDecoration,
      child: TextField(
        style: getTextStyle(
            fontSize: MEDIUM_FONT_SIZE, fontWeight: FontWeight.normal),
        cursorColor: BLACK_COLOR,
        controller: widget.searchTextController,
        keyboardType: widget.keyboardType,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.done,
        autocorrect: true,
        decoration: InputDecoration(
          hintText: widget.searchHint ?? SEARCH_HINT_TXT,
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          isDense: true,
          suffixIconColor: WHITE_COLOR,
          prefix: Padding(padding: leftSpace(x: 5)),
          suffixIcon: SvgPicture.asset(
            SEARCH_IMAGE,
            width: 30,
          ),
          // suffixIcon: widget.searchTextController!.text.isNotEmpty
          //     ? IconButton(
          //         onPressed: () {
          //           setState(() {
          //             widget.searchTextController!.text = "";
          //           });
          //         },
          //         icon: Padding(
          //           padding: rightSpace(),
          //           child: const Icon(
          //             Icons.close,
          //             color: DARK_GREY_COLOR,
          //           ),
          //         ))
          //     : null,
          hintStyle: getHintStyle(),
          focusColor: LIGHT_GREY_COLOR,
          border: InputBorder.none,
        ),
        onSubmitted: (text) => widget.onSubmit!(text),
        onChanged: (updatedText) {
          setState(() {
            widget.onTextChanged!(updatedText);
          });
        },
      ),
    );
  }
}
