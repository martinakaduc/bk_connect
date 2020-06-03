// Bao gồm header trên Home và header bên notìication
import 'package:flutter/material.dart';

class HomeTitle extends StatelessWidget {
  HomeTitle() : super();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            style: const TextStyle(
              color: const Color(0xff042b92),
              fontWeight: FontWeight.w700,
              fontFamily: "Roboto",
              fontStyle: FontStyle.normal,
              fontSize: 36.0,
            ),
            text: "BK ",
          ),
          TextSpan(
            style: const TextStyle(
              color: const Color(0xff1588db),
              fontWeight: FontWeight.w700,
              fontFamily: "Roboto",
              fontStyle: FontStyle.normal,
              fontSize: 36.0,
            ),
            text: "Connect",
          )
        ],
      ),
    );
  }
}