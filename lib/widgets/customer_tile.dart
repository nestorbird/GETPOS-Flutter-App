import 'package:flutter/material.dart';

import '../configs/theme_config.dart';
import '../constants/app_constants.dart';
import '../database/models/customer.dart';
import '../main.dart';
import '../utils/ui_utils/padding_margin.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';

typedef OnCheckChangedCallback = void Function(bool isChanged);

// ignore: must_be_immutable
class CustomerTile extends StatefulWidget {
  bool? isCheckBoxEnabled;
  bool? isDeleteButtonEnabled;
  bool? isSubtitle;
  bool? checkCheckBox;
  bool? checkBoxValue;
  bool? isHighlighted;
  int? selectedPosition;
  Function(bool)? onCheckChanged;
  Customer? customer;
  bool isNumVisible;

  CustomerTile(
      {Key? key,
      required this.isCheckBoxEnabled,
      required this.isDeleteButtonEnabled,
      required this.isSubtitle,
      required this.customer,
      this.checkCheckBox,
      this.checkBoxValue,
      this.onCheckChanged,
      this.isNumVisible = true,
      this.isHighlighted = false,
      this.selectedPosition})
      : super(key: key);

  @override
  State<CustomerTile> createState() => _CustomerTileState();
}

class _CustomerTileState extends State<CustomerTile> {
  bool isSelected = false;
  @override
  void initState() {
    isSelected = widget.isHighlighted!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var container = Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: mediumPaddingAll(),
      decoration: BoxDecoration(
          color: isTabletMode
              ? const Color(0xFFF9F8FB)
              : isSelected
                  ? OFF_WHITE_COLOR
                  : WHITE_COLOR,
          border: Border.all(
              color: isSelected ? MAIN_COLOR : GREY_COLOR,
              width: isSelected ? 0.3 : 1.0),
          borderRadius: BorderRadius.circular(BORDER_CIRCULAR_RADIUS_08)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: horizontalSpace(),
                  child: Text(
                      widget.customer != null ? widget.customer!.name : "",
                      style: getTextStyle(
                          fontSize: MEDIUM_PLUS_FONT_SIZE,
                          color: MAIN_COLOR,
                          fontWeight: widget.isHighlighted!
                              ? FontWeight.bold
                              : FontWeight.normal),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              Visibility(
                visible:widget.isNumVisible,
                child: Padding(
                  padding: miniPaddingAll(),
                  child: Text(
                    widget.customer != null ? widget.customer!.phone : "",
                    style: getTextStyle(
                        fontSize: MEDIUM_FONT_SIZE,
                        color: DARK_GREY_COLOR,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: horizontalSpace(),
            child: Text(
              widget.customer != null ? widget.customer!.email : "",
              style: getTextStyle(
                  color: BLACK_COLOR,
                  fontSize: SMALL_PLUS_FONT_SIZE,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
    return widget.isCheckBoxEnabled!
        ? InkWell(
            onTap: () {
              if (widget.isCheckBoxEnabled!) {
                setState(() {
                  isSelected = !isSelected;
                  widget.onCheckChanged!(isSelected);
                });
              }
            },
            child: container,
          )
        : container;
  }
}
