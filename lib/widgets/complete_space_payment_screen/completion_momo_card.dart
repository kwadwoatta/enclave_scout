import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompletionMomoCard extends StatefulWidget {
  final String phoneNumber;
  final String logoPath;
  final Color brandColor;
  final Color backgroundColor;
  final String brandName;
  final String prefix;
  final String scoutName;

  CompletionMomoCard({
    @required this.phoneNumber,
    @required this.brandName,
    @required this.brandColor,
    @required this.logoPath,
    @required this.backgroundColor,
    @required this.prefix,
    @required this.scoutName,
  });

  @override
  _CompletionMomoCardState createState() => _CompletionMomoCardState();
}

class _CompletionMomoCardState extends State<CompletionMomoCard> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final accentColor = Theme.of(context).accentColor;
    print(widget.phoneNumber);

    return Card(
      elevation: 10,
      color: widget.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        splashColor: widget.brandColor,
        onTap: () {
          Navigator.of(context).pushNamed('/complete-space-payment');
        },
        child: Container(
          height: height * .06,
          width: width * .75,
          padding: EdgeInsets.only(
            top: height * .02,
            bottom: height * .01,
            left: width * .06,
            right: width * .06,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 7,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.brandName,
                              style: TextStyle(
                                color: widget.brandColor,
                                fontWeight: FontWeight.bold,
                                fontSize: width * .06,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Image.asset(
                                'assets/images/cards/emv.png',
                                height: height * .08,
                                width: width * .2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Image.asset(
                          widget.logoPath,
                          height: height * .07,
                          width: width * .07,
                        ),
                      ),
                    ]),
              ),
              //
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '+233',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: width * .06,
                      ),
                    ),
                    SizedBox(width: width * .04),
                    Text(
                      widget.phoneNumber.length <= 3
                          ? widget.prefix
                          : widget.phoneNumber.substring(0, 3),
                      style: TextStyle(
                        color: accentColor,
                        fontSize: width * .06,
                      ),
                    ),
                    SizedBox(width: width * .08),
                    Text(
                      widget.phoneNumber.length >= 6
                          ? widget.phoneNumber.substring(3, 6)
                          : '•••',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: width * .1,
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(width: width * .08),
                    Text(
                      widget.phoneNumber.length == 10
                          ? widget.phoneNumber.substring(6, 10)
                          : '••••',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: width * .1,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ),
              //
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.scoutName,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: width * .04,
                      ),
                    ),
                    Text(
                      DateFormat.yMMM().format(DateTime.now()),
                      // '01 / 2020',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: width * .04,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
