import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/ui_utils/card_border_shape.dart';

class ShimmerWidget extends StatefulWidget {
  const ShimmerWidget({Key? key}) : super(key: key);

  @override
  ShimmerWidgetState createState() => ShimmerWidgetState();
}

class ShimmerWidgetState extends State<ShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: true,
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Card(
              shape: cardBorderShape(),
              elevation: 2.0,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                color: Colors.grey[300]!,
                child: SizedBox(
                  height: 65,
                  width: MediaQuery.of(context).size.width,
                ),
              ))),
    );
  }
}
