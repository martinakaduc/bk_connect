// Bao gồm header trên Home và header bên notìication
import 'package:bkconnect/view/components/image.dart';
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

AppBar mainAppBar(int index) {
  if (index == 0) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: GeneralImage(
          75,
          'assets/images/BK_image.png',
        ),
      ),
      title: HomeTitle(),
    );
  } else if (index == 3) {
    return null;
  } else {
    return null;
  }
}
