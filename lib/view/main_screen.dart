import 'package:bkconnect/view/components/button.dart';
import 'package:bkconnect/view/components/header_bar.dart';
import 'package:bkconnect/view/components/image.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  MainScreen() : super();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) return;
      this._selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: GeneralImage(
            75,
            'assets/images/BK image.png',
          ),
        ),
        title: HomeTitle(),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: 375,
              height: 74,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Button(
                    "Camera",
                    160,
                    48,
                    onTapFunction: () {},
                  ),
                  SizedBox(width: 30),
                  Button(
                    "Gallery",
                    160,
                    48,
                    color: Color(0xffe0e0e0),
                    onTapFunction: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
//        tooltip: 'Camera',
        child: Icon(Icons.camera),
        elevation: 2.0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xe5ffffff),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Nearby'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Camera'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('News'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
        ],
        currentIndex: this._selectedIndex,
        selectedItemColor: Color(0xff1588db),
        onTap: this._onItemTapped,
      ),
    );
  }
}
