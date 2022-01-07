import 'package:flutter/material.dart';
import 'package:scout/models/event.dart';

import './body.dart';

class AdDetail extends StatelessWidget {
  final Event event;
  AdDetail({@required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        event: event,
      ),
    );
  }
}
