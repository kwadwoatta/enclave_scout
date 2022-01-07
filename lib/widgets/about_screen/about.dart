import 'package:flutter/material.dart';

import 'body.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFf3f5f6),
        appBar: AppBar(
          title: Text(
            'THE ENCLAVERS',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Body());
  }
}
