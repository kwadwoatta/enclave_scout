import 'package:flutter/material.dart';

class UnAuthorizedUserScreen extends StatelessWidget {
  static const routeName = '/unauthorized';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('UNAUTHORIZED'),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sorry, you are not authorized to use this app. Please try loging in to the scout app or signing up for this app.',
          ),
          FlatButton(
            child: Text('Sign Up'),
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/signup'),
          )
        ],
      ),
    );
  }
}
