// Có info card trên Home, và các info filed, có sử dụng component image, menu
import 'package:flutter/material.dart';

class NormalText extends StatelessWidget {
  NormalText(String text, {double fontSize = 18, Color color = Colors.black}) {
    this.text = text;
    this.fontSize = fontSize;
    this.color = color;
  }

  String text;
  double fontSize;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: TextStyle(
        color: this.color,
        fontWeight: FontWeight.w400,
        fontFamily: "Roboto",
        fontStyle: FontStyle.normal,
        fontSize: this.fontSize,
      ),
    );
  }
}
