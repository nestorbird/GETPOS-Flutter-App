import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';

ShapeBorder cardBorderShape({radius = CARD_BORDER_SIDE_RADIUS_10}) =>
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
