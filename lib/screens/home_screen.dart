import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../screens/events_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/spaces_screen.dart';

import '../custom_icons/custom_icons.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: IndexedStack(
        index: _page,
        children: <Widget>[
          SpacesScreen(),
          EventsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(CustomIcons.building, size: 25, color: Colors.white),
          Icon(CustomIcons.event_calender, size: 25, color: Colors.white),
          Icon(CustomIcons.settings, size: 25, color: Colors.white),
        ],
        height: screenSize.height * .06,
        animationDuration: Duration(milliseconds: 300),
        buttonBackgroundColor: primaryColor,
        backgroundColor: Colors.white,
        color: primaryColor,
        index: _page,
        onTap: (index) {
          setState(() => _page = index);
        },
      ),
    );
  }
}
