import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/ui_utils/card_border_shape.dart';

class ProductShimmer extends StatefulWidget {
  const ProductShimmer({Key? key}) : super(key: key);

  @override
  State<ProductShimmer> createState() => _ProductShimmerState();
}

class _ProductShimmerState extends State<ProductShimmer> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        shape: cardBorderShape(),
        elevation: 2.0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          height: 500,
        ),
      ),
    );
  }
}
