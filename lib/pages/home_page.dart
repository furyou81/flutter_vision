import 'package:flutter/material.dart';

import '../components/take_picture.dart';
import '../components/about.dart';

class HomePage extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      return _HomePageState();
    }
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    TakePicture(),
    About(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera', style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabTapped, // new
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.camera_enhance),
            title: new Text('Take a picture'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text('About the app'),
          ),
        ],
      ),
    );
  }
}
