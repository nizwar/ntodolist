import 'package:flutter/material.dart'; 
import 'package:todolist/core/utils/utils.dart';
import 'package:todolist/ui/screens/taskFormScreen.dart';
import 'package:todolist/ui/pages/berandaPage.dart';
import 'package:todolist/ui/pages/friendListPage.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          [
            BerandaPage(),
            FriendListPage(),
          ][_currentIndex],
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.deepOrange, blurRadius: 10)],
          gradient: LinearGradient(colors: [
            Colors.red,
            Colors.orange,
          ]),
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: _addTaskClick,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: _changeIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Friends",
          ),
        ],
      ),
    );
  }

  void _addTaskClick() {
    startScreen(context, TaskFormScreen());
  }

  void _changeIndex(index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
