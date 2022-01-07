import 'package:flutter/material.dart';

import './body.dart';
// import './top_bar.dart';

class Spaces extends StatefulWidget {
  @override
  _SpacesState createState() => _SpacesState();
}

class _SpacesState extends State<Spaces> {
  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    // final primaryColor = Theme.of(context).primaryColor;

    return SingleChildScrollView(
      child: Body(),
    );
  }
}
