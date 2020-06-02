import 'package:bkconnect/view/components/button.dart';
import 'package:bkconnect/view/components/image.dart';
import 'package:bkconnect/view/components/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen() : super();

  @override
  State<StatefulWidget> createState() {
    return _ForgotPasswordScreenState();
  }
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: <Widget>[
        SizedBox(height: 30),
        GeneralImage(
          128,
          'assets/images/BK image.png',
        ),
        SizedBox(height: 80),
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              InputField(
                "Email",
                "Enter email",
                'assets/images/Username icon.png',
              ),
              SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Button(
                    "Cancel",
                    124,
                    48,
                    fontSize: 20,
                    onTapFunction: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 50),
                  Button(
                    "Send",
                    124,
                    48,
                    fontSize: 20,
                    onTapFunction: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    )));
  }
}
