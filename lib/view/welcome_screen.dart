import 'package:bkconnect/view/components/button.dart';
import 'package:bkconnect/view/components/image.dart';
import 'package:bkconnect/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:bkconnect/controller/config.dart';
import 'package:bkconnect/view/main_screen.dart';

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
              onTapFunction: () async {
                var storage = FlutterSecureStorage();
                // storage.delete(key: "token");
                var token = await storage.read(key: "token");
                print(token);
                if (token == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
