import 'package:bkconnect/view/camera.dart';
import 'package:bkconnect/view/components/header_bar.dart';
import 'package:bkconnect/view/home_page.dart';
import 'package:bkconnect/view/nearby_page.dart';
import 'package:bkconnect/view/news_page.dart';
import 'package:bkconnect/view/profile_page.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  MainScreen() : super();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> _pages;

  Function _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CameraView()),
        );
        return null;
      }
      this._selectedIndex = index;
    });
    return null;
  }

  @override
  void initState() {
    this._selectedIndex = 0;
    this._pages = [
      HomePage(),
      NearbyPage(),
      null,
      NewsPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(this._selectedIndex),
      body: this._pages[this._selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CameraView()),
          );
        },
        tooltip: 'Camera',
        child: Icon(Icons.camera_alt),
        elevation: 2.0,
        backgroundColor: const Color(0xff1588db),
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
        fixedColor: const Color(0xff1588db),
        onTap: this._onItemTapped,
      ),
    );
  }
}
