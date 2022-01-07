import 'package:flutter/material.dart';

class NoConnectionScreen extends StatelessWidget {
  static const routeName = '/no-connection';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'No connection',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: width * .05,
              ),
            ),
            SizedBox(height: width * height * .06),
            Text(
              'Check your mobile data or Wi-Fi',
              style: TextStyle(
                color: Colors.grey,
                fontSize: width * .05,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: height * .08),
                child: Text('Logo Here'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
