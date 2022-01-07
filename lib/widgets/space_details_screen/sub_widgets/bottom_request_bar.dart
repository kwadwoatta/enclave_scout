import 'package:flutter/material.dart';
import 'package:scout/models/space.dart';

class BottomRequestBar extends StatelessWidget {
  final Space space;
  final Function onPressed;
  BottomRequestBar({this.space, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final primaryColor = Theme.of(context).primaryColor;

    return Positioned(
      bottom: 0,
      child: Container(
        height: height * .07,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(space.vendorImage),
                  // backgroundImage: AssetImage('assets/images/team/prince.png'),
                  backgroundColor: primaryColor,
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        space.vendorName,
                        style: TextStyle(fontSize: width * .05),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            size: width * .045,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: width * .015,
                          ),
                          Text(
                            space.rating.toString(),
                            style: TextStyle(
                              fontSize: width * .05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                // child: Padding(
                //   padding: EdgeInsets.all(0),
                // ),
                child: RaisedButton(
                  color: primaryColor,
                  child: Text(
                    'Request to book',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: onPressed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: primaryColor),
                  ),
                ),
              )
              // Icon(
              //   Icons.favorite,
              //   color: Colors.grey,
              //   // color: space.verified ? primaryColor : Colors.red,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
