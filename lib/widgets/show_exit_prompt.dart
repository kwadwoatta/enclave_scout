import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowExitPrompt {
  ShowExitPrompt({@required BuildContext context}) {
    showDialog(
      context: context,
      builder: ((context) {
        final screenSize = MediaQuery.of(context).size;
        final accentColor = Theme.of(context).accentColor;

        return Dialog(
          backgroundColor: Colors.white,
          elevation: 5,
          child: Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            height: screenSize.height * .1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Do you want to leave the app ?',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: screenSize.width * .04,
                  ),
                ),
                // SizedBox(width: screenSize.width * .01),
                InkWell(
                  child: Text(
                    'NO',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: screenSize.width * .05,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
                InkWell(
                  child: Text(
                    'YES',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenSize.width * .05,
                    ),
                  ),
                  onTap: () {
                    FirebaseAuth.instance.signOut().then((_) {
                      Navigator.of(context).pop();
                      // FirebaseAuth.instance.currentUser()
                    });
                  },
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
