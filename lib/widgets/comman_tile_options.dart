import 'package:flutter/material.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';

import '../constants/app_constants.dart';
import '../database/models/customer.dart';
import '../utils/ui_utils/card_border_shape.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';

typedef OnCheckChangedCallback = void Function(bool isChanged);

// ignore: must_be_immutable
class CommanTileOptions extends StatefulWidget {
  bool? isCheckBoxEnabled;
  bool? isDeleteButtonEnabled;
  bool? isSubtitle;
  bool? checkCheckBox;
  bool? checkBoxValue;
  int? selectedPosition;
  Function(bool)? onCheckChanged;
  Customer? customer;

  CommanTileOptions(
      {Key? key,
      required this.isCheckBoxEnabled,
      required this.isDeleteButtonEnabled,
      required this.isSubtitle,
      required this.customer,
      this.checkCheckBox,
      this.checkBoxValue,
      this.onCheckChanged,
      this.selectedPosition})
      : super(key: key);

  @override
  State<CommanTileOptions> createState() => _CommanTileOptionsState();
}

class _CommanTileOptionsState extends State<CommanTileOptions> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Card(
        shape: cardBorderShape(),
        elevation: 2.0,
        child: ListTile(
          leading: SizedBox(
            height: 70,
            width: 70,
            child: Card(
              color:AppColors.getSecondary().withOpacity(.1),
              shape: cardBorderShape(),
              elevation: 0.0,
              child: Container(),
              // child: Padding(
              //     padding: mediumPaddingAll(),
              //     child: widget.customer!.customerImageUrl!.isNotEmpty
              //         ? Image.network(widget.customer!.customerImageUrl!)
              //         : widget.customer!.profileImage.isEmpty
              //             ? SvgPicture.asset(
              //                 HOME_CUSTOMER_IMAGE,
              //                 height: 30,
              //                 width: 30,
              //                 fit: BoxFit.contain,
              //               )
              //             : Image.memory(
              //                 widget.customer!.profileImage,
              //                 // height: widget.enableAddProductButton ? 60 : 70,
              //               )),
            ),
          ),
          title: Text(widget.customer!.name,
              style: getTextStyle(
                  fontSize: SMALL_PLUS_FONT_SIZE, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          subtitle: Visibility(
              visible: widget.isSubtitle!,
              child: Text(
                widget.customer!.phone,
                style: getTextStyle(
                    fontSize: SMALL_PLUS_FONT_SIZE,
                    fontWeight: FontWeight.w500),
              )),
          trailing: _getTrailingWidget,
        ),
      ),
    );
  }

  Widget? get _getTrailingWidget {
    if (widget.isCheckBoxEnabled!) {
      return InkWell(
        onTap: () => widget.onCheckChanged!(widget.checkBoxValue!),
        child: widget.checkBoxValue!
            ? Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(color:AppColors.getPrimary()),
                  // border: Border.all(color: Colors.yellow.shade800),
                  color: AppColors.getPrimary(),
                  // color: Colors.yellow.shade800,
                  borderRadius:
                      BorderRadius.circular(BORDER_CIRCULAR_RADIUS_06),
                ),
                child: Icon(
                  Icons.check,
                  size: 20.0,
                  color: AppColors.fontWhiteColor,
                ))
            : Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.getTextandCancelIcon()),
                  borderRadius:
                      BorderRadius.circular(BORDER_CIRCULAR_RADIUS_06),
                ),
                child: const Icon(
                  null,
                  size: 20.0,
                ),
              ),
      );
    } else {
      return const Icon(
        Icons.delete_outline_sharp,
        size: 1,
      );
    }
  }
}
