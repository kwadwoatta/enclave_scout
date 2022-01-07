import 'package:flutter/material.dart';

import '../widgets/events_screen/events.dart';

class EventsScreen extends StatefulWidget {
  static const routeName = "/events-screen";

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Events();
  }
}
