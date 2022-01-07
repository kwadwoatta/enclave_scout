import 'package:flutter/material.dart';

Widget errorSnackbar({@required String errorMessage}) {
  return SnackBar(
    backgroundColor: Colors.red,
    content: Text(
      errorMessage,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
    ),
    duration: Duration(seconds: 4),
    elevation: 10,
  );
}
