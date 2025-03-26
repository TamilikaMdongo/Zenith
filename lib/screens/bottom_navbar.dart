import 'package:flutter/material.dart';
import 'package:app/screens/create_event.dart';
import 'package:app/screens/discover.dart';

import 'package:app/screens/my_events.dart';
import 'package:app/screens/profile.dart';

import 'package:app/screens/home.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> _screens = [
    Home(),
    Discover(),
    CreateEvent(),
    MyEvents(),
    Profile()
  ];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: Colors.black, 
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.greenAccent,
  unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: 'Home',backgroundColor: Colors.white
            ),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search', backgroundColor: Colors.white),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_view_month_rounded), label: 'Events'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
          ]),
    );
  }
}
