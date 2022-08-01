import 'package:flutter/material.dart';

EdgeInsets miniPaddingAll() => const EdgeInsets.all(5.0);
EdgeInsets smallPaddingAll() => const EdgeInsets.all(8.0);
EdgeInsets mediumPaddingAll() => const EdgeInsets.all(10.0);
EdgeInsets morePaddingAll({x = 15}) => EdgeInsets.all(x.toDouble());
EdgeInsets paddingXY({x = 10, y = 10}) =>
    EdgeInsets.symmetric(horizontal: x.toDouble(), vertical: y.toDouble());

EdgeInsets leftSpace({x = 16}) => EdgeInsets.only(left: x.toDouble());
EdgeInsets topSpace({y = 8}) => EdgeInsets.only(top: y.toDouble());
EdgeInsets rightSpace({x = 16.0}) => EdgeInsets.only(right: x.toDouble());
EdgeInsets bottomSpace({y = 15.0}) => EdgeInsets.only(bottom: y.toDouble());

EdgeInsets horizontalSpace({x = 10}) =>
    EdgeInsets.symmetric(horizontal: x.toDouble());

EdgeInsets verticalSpace({x = 10}) =>
    EdgeInsets.symmetric(vertical: x.toDouble());
