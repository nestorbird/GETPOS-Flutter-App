import 'package:flutter/material.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';

import '../../configs/theme_config.dart';
import '../../constants/app_constants.dart';

BoxDecoration txtFieldBorderDecoration = BoxDecoration(
    border: Border.all(color: AppColors.getAsset(), width: BORDER_WIDTH),
    borderRadius: BorderRadius.circular(BORDER_CIRCULAR_RADIUS_08));

BoxDecoration searchTxtFieldBorderDecoration = BoxDecoration(
    border: Border.all(color: AppColors.getAsset(), width: BORDER_WIDTH),
    borderRadius: BorderRadius.circular(8));

BoxDecoration txtFieldBoxShadowDecoration = BoxDecoration(
    color: AppColors.fontWhiteColor,
    border: Border.all(color: AppColors.getAsset(), width: BORDER_WIDTH),
    boxShadow:  [
      BoxShadow(
        color: AppColors.getshadowBorder(),
        spreadRadius: 1,
        blurRadius: 5,
        offset: Offset(0, 2),
      )
    ],
    borderRadius: BorderRadius.circular(BORDER_CIRCULAR_RADIUS_08));
