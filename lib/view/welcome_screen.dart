import 'package:bkconnect/view/components/button.dart';
import 'package:bkconnect/view/components/image.dart';
import 'package:bkconnect/view/login_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen() : super();

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 120),
            GeneralImage(
              180,
              'assets/images/BK_image.png',
            ),
            // BK Connect
            Text(
              "BK Connect",
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontFamily: "SegoePrint",
                  fontStyle: FontStyle.normal,
                  fontSize: 48.0),
            ),
            // Start button
            // Rectangle 4
            SizedBox(height: 200),
            Button(
              "START",
              284,
              48,
              fontSize: 36,
              onTapFunction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
