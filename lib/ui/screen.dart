import 'package:flutter/material.dart';
import 'add_post.dart';
import 'home_screen.dart';
import 'profile.dart';

class Screen extends StatefulWidget {
  const Screen({Key key}) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int selectedIndex = 0;

  final tabs = [
    Container(
        child: HomeScreen()
    ),
    Container(
        child: AddPost()
    ),
    Container(
        child: Profile()
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, color: Colors.black),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box, color: Colors.black),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: "Profile",
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: selectedIndex,
        iconSize: 30,
        onTap: (index){
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      body: tabs[selectedIndex],
    );
  }
}