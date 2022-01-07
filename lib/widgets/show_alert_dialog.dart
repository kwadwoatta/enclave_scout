import 'package:flutter/material.dart';

class ShowAlertDialog {
  String message;
  BuildContext context;
  bool actionable;
  Function onOkPressed;

  ShowAlertDialog({
    @required this.context,
    @required this.message,
    @required this.actionable,
    this.onOkPressed,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        final height = MediaQuery.of(context).size.height;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 5, top: 10),
            height: height * .1,
            child: Column(
              children: <Widget>[
                Text(
                  this.message,
                  style: TextStyle(
                    color: Color(0xff77a27a),
                  ),
                ),
                actionable
                    ? FlatButton(
                        child: Text(
                          'OK',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 19,
                          ),
                        ),
                        onPressed: onOkPressed != null
                            ? onOkPressed
                            : () => Navigator.of(context).pop(),
                      )
                    : Text(''),
              ],
            ),
          ),
        );
      },
    );
  }
}
