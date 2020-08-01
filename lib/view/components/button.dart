// Có button dài, button ngắn
import 'package:bkconnect/view/components/text.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button(String title, double width, double height,
      {double fontSize = 20,
      Function onTapFunction = null,
      Color color = const Color(0xff1588db)}) {
    this.title = title;
    this.width = width;
    this.height = height;
    this.fontSize = fontSize;
    this.onTapFunction = onTapFunction;
    this.color = color;
    if (color != const Color(0xff1588db)) {
      this.textColor = Colors.black;
    } else {
      this.textColor = Colors.white;
    }
  }

  String title;
  double width;
  double height;
  double fontSize;
  Function onTapFunction;
  Color color;
  Color textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapFunction,
      child: Container(
        width: this.width,
        height: this.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(36)),
          color: this.color,
        ),
        child: Text(
          this.title,
          style: TextStyle(
            color: this.textColor,
            fontWeight: FontWeight.w700,
            fontFamily: "Roboto",
            fontStyle: FontStyle.normal,
            fontSize: this.fontSize,
          ),
        ),
      ),
    );
  }
}

class TextButton extends StatelessWidget {
  TextButton(String title,
      {double fontSize = 18, Function onTapFunction = null}) {
    this.title = title;
    this.fontSize = fontSize;
    this.onTapFunction = onTapFunction;

    if (this.onTapFunction != null) {
      this.color = Colors.blue;
    } else {
      this.color = Colors.black;
    }
  }

  String title;
  double fontSize;
  Color color;
  Function onTapFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapFunction,
      child: NormalText(
        this.title,
        fontSize: this.fontSize,
        color: this.color,
      ),
    );
  }
}