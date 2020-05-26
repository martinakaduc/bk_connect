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
//          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 135),
            Container(
              width: 180,
              height: 180,
              child: Image(
                image: AssetImage('assets/images/BK image.png'),
              ),
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Container(
                width: 284,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(36)),
                    color: const Color(0xff1588db)),
                child: Text(
                  "START",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 36.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
