import 'package:desktop_controller/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import 'music_control.dart';
import 'power_control.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body:
      SafeArea(child: index==2 ? const ProfileScreen() : index == 0 ? const PowerControl() : const MusicControl(),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        backgroundColor: Color.fromARGB(255, 141, 135, 255),
        onPressed: () {
          setState(() {
            index = 2;
          });
        },
        // tooltip: 'Increment',
        child: const Icon(Icons.person),
      ),
      bottomNavigationBar: BottomNavigationBar
      (
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        currentIndex: index==2?0:index,
        elevation: 5,
        selectedItemColor: index==2?null: Color.fromARGB(255, 141, 135, 255),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.desktop_mac_sharp),
            label: 'Power',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow_sharp),
            label: 'Play',
          ),
      ]),
    );
  }
}