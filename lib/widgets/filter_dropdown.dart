import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/utils/ui_utils/text_styles/custom_text_style.dart';
import 'package:nb_posx/utils/ui_utils/text_styles/edit_text_hint_style.dart';
import '../constants/asset_paths.dart';

//WE CAN USE THIS DROP DOWN LATER IF THERE'LL WILL BE REQUIREMENT
// ignore: must_be_immutable
class FilterDropdown extends StatefulWidget {
  FilterDropdown({
    Key? key,
    this.dropdownValue,
    required this.item,
    this.height = 45,
    this.unitCtrl,
    this.width = 500,
    this.hint = "",
  }) : super(key: key);
  @override
  State<FilterDropdown> createState() => _FilterDropdownState();
  final List<String> item;
  final double? height;
  final double? width;
  String? dropdownValue;
  final String? hint;
  final TextEditingController? unitCtrl;
}
class _FilterDropdownState extends State<FilterDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.only(left: 16),
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          color: AppColors.getfontWhiteColor(),
          border: Border.all(color: AppColors.getAsset()),
          borderRadius: BorderRadius.circular(6.0)),
      // boxShadow: const [
      //   BoxShadow(
      //       color: Color.fromRGBO(0, 0, 0, 0.3),
      //       blurRadius: 1,
      //       spreadRadius: 1)
      // ],
      // borderRadius: BorderRadius.circular(8)),
      child: DropdownButton(
          icon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SvgPicture.asset(
              DROPDOWN_ICON,
              width: 20,
            ),
          ),
          hint: Text(
            widget.hint!,
            style: getHintStyle(),
          ),
          borderRadius: BorderRadius.circular(15),
          isExpanded: true,
          underline: const SizedBox(),
          value: widget.dropdownValue,
          // For now we use the String Static value
          items: widget.item.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
                value: value, child: Text(value, style: getNormalStyle()));
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              widget.dropdownValue = newValue!;
            });
          }),
    );
  }
}