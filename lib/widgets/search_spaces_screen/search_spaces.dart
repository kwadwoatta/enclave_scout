import 'package:flutter/material.dart';

import './body.dart';

class SearchSpaces extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Color(0xFFf6f6f6),
      // backgroundColor: Color(0xFFf3f7f8),
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: primaryColor),
      //   backgroundColor: Colors.white,
      //   centerTitle: true,
      //   title: Text(
      //     'Explore',
      //     style: TextStyle(
      //       color: primaryColor,
      //     ),
      //   ),
      //   elevation: 1,
      // ),
      body: SafeArea(child: Body()),
    );
  }
}
