import 'package:flutter/material.dart';
import './body.dart';

class AddEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).accentColor;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: accentColor),
        backgroundColor: Colors.white,
        title: Text(
          'Post an advertisment',
          style: TextStyle(color: accentColor),
        ),
        centerTitle: true,
      ),
      body: Body(),
      backgroundColor: Colors.white,
    );
  }
}
