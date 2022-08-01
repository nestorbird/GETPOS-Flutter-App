import 'dart:io';

import 'package:flutter/material.dart';

import '../configs/theme_config.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';

// ignore: must_be_immutable
class HeaderCurveWidget extends StatelessWidget {
  late double _widgetHeight;
  late double _curveHeight;
  HeaderCurveWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _widgetHeight = Platform.isIOS ? 3.5 : 3.8;
    _curveHeight = Platform.isIOS ? 4.2 : 3.8;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / _widgetHeight,
      child: Stack(
        // overflow: Overflow.visible,
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height / _curveHeight),
            painter: HeaderCurve(),
          ),
          Center(
              child: Text(
            "POS",
            style: getTextStyle(color: WHITE_COLOR, fontSize: 40.0),
          ))
        ],
      ),
    );
  }
}

class HeaderCurve extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = MAIN_COLOR
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(size.width * 0.9988750, size.height * 0.0009600);
    path0.lineTo(size.width * 0.9989125, size.height * 0.6018400);
    path0.quadraticBezierTo(size.width * 0.4941750, size.height * 1.1578000,
        size.width * 0.0012500, size.height * 0.5960000);
    path0.quadraticBezierTo(
        size.width * 0.0009375, size.height * 0.4470000, 0, 0);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
