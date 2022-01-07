import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scout/custom_icons/custom_icons.dart';

import '../../show_error_dialog.dart';

class TeamCard extends StatelessWidget {
  final String assetImage;
  final String name;
  final String role;
  final String twitterUrl;
  final String instaUrl;
  final String linkedinUrl;

  TeamCard({
    @required this.assetImage,
    @required this.name,
    @required this.role,
    @required this.twitterUrl,
    @required this.instaUrl,
    @required this.linkedinUrl,
  });

  _launchURL({
    @required BuildContext context,
    @required String url,
  }) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ErrorDialog(context: context, error: 'Could not visit link').showError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final accentColor = Theme.of(context).accentColor;
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(right: 5, left: 1),
      margin: EdgeInsets.all(5),
      width: width * .8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(10),
                    //   topRight: Radius.circular(10),
                    // ),
                    color: accentColor,
                  ),
                  margin: EdgeInsets.only(
                    left: width * .05,
                    right: width * .02,
                    top: height * .05,
                    bottom: height * .01,
                  ),
                ),
                Container(
                  // color: Colors.red,
                  height: height * .5,
                  margin: EdgeInsets.only(
                    left: width * .05,
                    top: height * .01,
                    bottom: height * .01,
                  ),
                  child: Image.asset(
                    assetImage,
                    fit: BoxFit.fill,
                    // height: height * .6,
                    // width: width * .5,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(
                top: height * .02,
                left: width * .01,
                bottom: height * .02,
              ),
              child: Container(
                height: height * .2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Prince Ofori',
                      // style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      role,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: width * .04,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 1.5,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(
                                CustomIcons.mail,
                                size: width * .03,
                              ),
                              Text(
                                'prince@enclave.space',
                                style: TextStyle(fontSize: width * .03),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              InkWell(
                                onTap: () => _launchURL(
                                    context: context, url: twitterUrl),
                                child: Icon(
                                  CustomIcons.twitter_filled,
                                  size: width * .04,
                                  color: Color(0xFF38A1F3),
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    _launchURL(context: context, url: instaUrl),
                                child: Image.asset(
                                  'assets/images/instagram.png',
                                  height: height * .02,
                                  width: width * .045,
                                ),
                              ),
                              InkWell(
                                onTap: () => _launchURL(
                                  context: context,
                                  url: linkedinUrl,
                                ),
                                child: Icon(
                                  CustomIcons.linkedin,
                                  size: width * .04,
                                  color: Color(0xFF2867B2),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
