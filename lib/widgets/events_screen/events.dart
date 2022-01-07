import 'package:flutter/material.dart';
import 'package:scout/custom_icons/custom_icons.dart';

import './body.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Upcoming Events',
          style: TextStyle(color: primaryColor),
        ),
        actions: <Widget>[
          IconButton(
            color: primaryColor,
            icon: Icon(
              CustomIcons.event_ads,
              size: 30,
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed('/add-event-screen'),
          )
        ],
        elevation: 1,
      ),
      body: SingleChildScrollView(child: Body()),
    );
  }
}
