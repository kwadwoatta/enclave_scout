import 'package:flutter/material.dart';
import 'package:scout/models/space.dart';

import 'body.dart';

class SpaceDetails extends StatelessWidget {
  final Space space;
  SpaceDetails({this.space});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Body(space: space),
    );
  }
}
