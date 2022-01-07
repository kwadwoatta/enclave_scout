import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:scout/custom_icons/custom_icons.dart';
import 'package:scout/widgets/show_exit_prompt.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  FirebaseUser user;

  @override
  initState() {
    FirebaseAuth.instance.currentUser().then((me) {
      user = me;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).accentColor;

    return Padding(
      padding: EdgeInsets.only(
        top: screenSize.height * .05,
        left: screenSize.width * .06,
        right: screenSize.width * .1,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Prince Ofori',
                    style: TextStyle(
                      fontSize: screenSize.width * .09,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'View and edit profile',
                    style: TextStyle(
                      fontSize: screenSize.width * .05,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Container(
                width: screenSize.width * .3,
                height: screenSize.width * .3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AdvancedNetworkImage(
                      user != null
                          ? user.photoUrl
                          : 'https://pixel.nymag.com/imgs/daily/vulture/2018/12/04/04-big-mouth.jpg',
                      loadedCallback: () {},
                      loadFailedCallback: () {},
                      loadingProgress: (double progress, dataInInt) {},
                      useDiskCache: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Setting(
            name: 'Change Password',
            icon: CustomIcons.reset_padlock,
            iconSize: screenSize.width * .09,
            routeName: '/change-password',
          ),
          Setting(
            name: 'Requests',
            icon: CustomIcons.email,
            iconSize: screenSize.width * .07,
            routeName: '/requests',
          ),
          Setting(
            name: 'Transactions',
            icon: CustomIcons.transaction,
            iconSize: screenSize.width * .1,
            routeName: '/payments',
          ),
          Setting(
            name: 'About',
            icon: CustomIcons.group,
            iconSize: screenSize.width * .1,
            routeName: '/about',
          ),
          InkWell(
            onTap: () => ShowExitPrompt(context: context),
            child: Column(
              children: <Widget>[
                SizedBox(height: screenSize.height * .05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Logout',
                      style: TextStyle(fontSize: screenSize.width * .05),
                    ),
                    Icon(
                      Icons.exit_to_app,
                      color: accentColor,
                      size: screenSize.width * .07,
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * .025),
                Divider(
                  color: Colors.grey,
                  height: 2,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Setting extends StatelessWidget {
  final String name;
  final String routeName;
  final IconData icon;
  final double iconSize;

  const Setting({
    @required this.name,
    @required this.icon,
    @required this.iconSize,
    @required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final accentColor = Theme.of(context).accentColor;

    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(routeName),
      child: Column(
        children: <Widget>[
          SizedBox(height: screenSize.height * .05),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                name,
                style: TextStyle(fontSize: screenSize.width * .05),
              ),
              Icon(
                icon,
                color: accentColor,
                size: iconSize,
              ),
            ],
          ),
          SizedBox(height: screenSize.height * .025),
          Divider(
            color: Colors.grey,
            height: 2,
          )
        ],
      ),
    );
  }
}
