import 'package:flutter/material.dart';
import 'package:scout/widgets/requests_screen/body.dart';

class Requests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Requests'),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: Body(),
    );
  }
}
