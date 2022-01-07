import 'package:flutter/material.dart';
import 'package:scout/custom_icons/custom_icons.dart';

class InvisibleNavBar extends StatelessWidget {
  final String spaceName;
  final bool verified;
  InvisibleNavBar({
    @required this.spaceName,
    @required this.verified,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FloatingActionButton(
              heroTag: '$spaceName-verified-floater',
              backgroundColor: Colors.white,
              mini: true,
              elevation: 0,
              onPressed: () => {},
              child: Icon(
                CustomIcons.verified,
                // color: primaryColor,
                color: verified ? primaryColor : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
