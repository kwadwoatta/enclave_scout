import 'package:flutter/material.dart';

class WaitingConnectionScreen extends StatelessWidget {
  static const routeName = '/waiting';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Connecting ...',
              style: TextStyle(
                fontSize: width * .06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: height * .05),
            CircularProgressIndicator(
              backgroundColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
