// Tạo ra image với các kích cỡ khác nhau, có thuộc tính vuồng, tròn
import 'package:flutter/material.dart';

class GeneralImage extends StatelessWidget {
  GeneralImage(double size, String image, {bool round = false}) {
    this.size = size;
    this.image = image;
    if (round == true) {
      this.roundRadius = 360.0;
    } else {
      this.roundRadius = 0.0;
    }
  }

  double size;
  String image;
  double roundRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.size,
      height: this.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(this.roundRadius),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(this.roundRadius),
        child: Image.asset(this.image),     
      ),
    );
  }
}
