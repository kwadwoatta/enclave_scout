import 'package:flutter/material.dart';

Future showAlertDialog({
  @required String message,
  @required String type,
  @required BuildContext context,
  Function whenPressed,
  bool noAction,
}) {
  if (noAction == null) noAction = false;
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: type == "error" ? Colors.red : Color(0xff77a27a),
            ),
          ),
          actions: noAction
              ? null
              : <Widget>[
                  FlatButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 19,
                      ),
                    ),
                    onPressed: whenPressed != null
                        ? whenPressed
                        : () => Navigator.of(context).pop(),
                  )
                ],
        );
      });
}
