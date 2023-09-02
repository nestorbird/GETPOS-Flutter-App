import 'package:flutter/material.dart';

import '../../configs/theme_config.dart';
import '../../constants/app_constants.dart';

BoxDecoration txtFieldBorderDecoration = BoxDecoration(
    border: Border.all(color: DARK_GREY_COLOR, width: BORDER_WIDTH),
    borderRadius: BorderRadius.circular(BORDER_CIRCULAR_RADIUS_08));

BoxDecoration searchTxtFieldBorderDecoration = BoxDecoration(
    border: Border.all(color: DARK_GREY_COLOR, width: BORDER_WIDTH),
    borderRadius: BorderRadius.circular(8));

BoxDecoration txtFieldBoxShadowDecoration = BoxDecoration(
    color: WHITE_COLOR,
    border: Border.all(color: DARK_GREY_COLOR, width: BORDER_WIDTH),
    boxShadow: const [
      BoxShadow(
        color: GREY_COLOR,
        spreadRadius: 1,
        blurRadius: 5,
        offset: Offset(0, 2),
      )
    ],
    borderRadius: BorderRadius.circular(BORDER_CIRCULAR_RADIUS_08));
