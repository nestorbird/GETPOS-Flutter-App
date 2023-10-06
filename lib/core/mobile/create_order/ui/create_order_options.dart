import 'package:flutter/material.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../utils/ui_utils/card_border_shape.dart';
import '../../../../utils/ui_utils/padding_margin.dart';

import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';

// ignore: must_be_immutable
class CreateOrderOptions extends StatefulWidget {
  final String tileTile;
  Function? onTap;

  CreateOrderOptions({Key? key, required this.tileTile, required this.onTap})
      : super(key: key);

  @override
  State<CreateOrderOptions> createState() => _CreateOrderOptionsState();
}

class _CreateOrderOptionsState extends State<CreateOrderOptions> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: horizontalSpace(),
      child: Card(
        shape: cardBorderShape(),
        child: ListTile(
          title: Text(
            widget.tileTile,
            style: getTextStyle(
              fontWeight: FontWeight.w600,
              fontSize: MEDIUM_PLUS_FONT_SIZE,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded,
              color: AppColors.getTextandCancelIcon(), size: 15),
          onTap: () => widget.onTap!(),
        ),
      ),
    );
  }
}
