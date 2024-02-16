import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';

import '../constants/app_constants.dart';
import '../constants/asset_paths.dart';
import '../utils/ui_utils/padding_margin.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';
import '../utils/ui_utils/text_styles/edit_text_hint_style.dart';
import '../utils/ui_utils/textfield_border_decoration.dart';

// ignore: must_be_immutable
class SearchWidgetTablet extends StatefulWidget {
  final String? searchHint;
  final TextEditingController? searchTextController;
  Function(String changedtext)? onTextChanged;
  Function(String text)? onSubmit;
  TextInputType keyboardType;
  List<TextInputFormatter>? inputFormatter;
 VoidCallback? onTap;
  SearchWidgetTablet(
      {Key? key,
      this.searchHint,
      this.onTap,
      this.searchTextController,
      this.onTextChanged,
      this.onSubmit,
      this.keyboardType = TextInputType.text,
      this.inputFormatter})
      : super(key: key);

  @override
  State<SearchWidgetTablet> createState() => _SearchWidgetTabletState();
}

class _SearchWidgetTabletState extends State<SearchWidgetTablet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: searchTxtFieldBorderDecoration,
      child: TextField(
          onTap: widget.onTap,
        style: getTextStyle(
            fontSize: MEDIUM_FONT_SIZE, fontWeight: FontWeight.normal),
        cursorColor: AppColors.getTextandCancelIcon(),
        controller: widget.searchTextController,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.done,
        autocorrect: true,
        decoration: InputDecoration(
          hintText: widget.searchHint ?? SEARCH_HINT_TXT,
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          isDense: true,
          prefixIconColor: AppColors.fontWhiteColor,
          prefix: Padding(padding: leftSpace(x: 10)),
          prefixIcon: SvgPicture.asset(
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
          focusColor: AppColors.hintText,
          border: InputBorder.none,
        ),
        onSubmitted: (text) => widget.onSubmit!(text),
        onChanged: (updatedText) => widget.onTextChanged!(updatedText),
        inputFormatters: widget.inputFormatter,
      ),
    );
  }
}
