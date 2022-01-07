import 'package:flutter/material.dart';

import 'subwidgets/managemant_card.dart';
import 'subwidgets/team_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(top: screenSize.width * .05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(screenSize.width * .05),
            child: Text(
                'Ullamco excepteur duis pariatur consectetur exercitation duis deserunt. Voluptate est proident occaecat culpa fugiat est. Nisi esse laborum sint velit velit dolor commodo occaecat esse consectetur consequat ullamco cupidatat excepteur. Aliqua laborum fugiat voluptate deserunt voluptate enim labore. Officia tempor excepteur commodo duis aliqua cupidatat proident duis cillum cupidatat. Occaecat veniam ipsum Lorem dolor ipsum occaecat sint labore occaecat ut aliquip occaecat. Aute qui mollit sit deserunt labore cillum sint magna.'),
          ),
          // SizedBox(height: screenSize.height * .1),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * .05),
                      child: Text(
                        'EXECUTIVE MANAGEMENT',
                        style: TextStyle(
                          fontSize: screenSize.width * .05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Management(),
                  ],
                ),
                // SizedBox(height: screenSize.height * .1),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * .05),
                      child: Text(
                        'DEVELOPMENT TEAM',
                        style: TextStyle(
                          fontSize: screenSize.width * .05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DevelopmentTeam(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Management extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // final primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: EdgeInsets.all(10),
      // color: Colors.green,
      height: screenSize.height * .25,
      child: ListView(
        children: <Widget>[
          ManagementCard(
            name: "Sedem Balfour",
            role: "CEO",
            email: 'sedem@enclave.space',
            twitterUrl: '',
            instaUrl: '',
            linkedinUrl: '',
            assetImage: 'assets/images/team/sedem.png',
          ),
          ManagementCard(
            name: "Cecilia",
            role: "CFO",
            email: 'cecilia@enclave.space',
            twitterUrl: '',
            instaUrl: '',
            linkedinUrl: '',
            assetImage: 'assets/images/team/amos.png',
          ),
          ManagementCard(
            name: "Amos Aidoo",
            role: "COO",
            email: "amos@enclave.spacee",
            twitterUrl: '',
            instaUrl: '',
            linkedinUrl: '',
            assetImage: 'assets/images/team/amos.png',
          ),
          ManagementCard(
            name: "Prince Ofori",
            role: "CTO",
            email: 'prince@enclave.space',
            instaUrl: 'https://instagram.com/_codejo',
            linkedinUrl: 'https://linkedin.com/in/prince-ofori',
            twitterUrl: 'https://twitter.com/_codejo',
            assetImage: 'assets/images/team/prince.png',
          )
        ],
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class DevelopmentTeam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // final primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: EdgeInsets.all(10),
      height: screenSize.height * .25,
      child: ListView(
        children: <Widget>[
          TeamCard(
            name: "Prince Ofori",
            role: "Front End Developer",
            instaUrl: 'https://instagram.com/_codejo',
            linkedinUrl: 'https://linkedin.com/in/prince-ofori',
            twitterUrl: 'https://twitter.com/_codejo',
            assetImage: 'assets/images/team/prince.png',
          ),
          TeamCard(
            name: "Prince Ofori",
            role: "Back End Developer",
            instaUrl: 'https://instagram.com/_codejo',
            linkedinUrl: 'https://linkedin.com/in/prince-ofori',
            twitterUrl: 'https://twitter.com/_codejo',
            assetImage: 'assets/images/team/prince.png',
          ),
          TeamCard(
            name: "Prince Ofori",
            role: "Software Architect",
            instaUrl: 'https://instagram.com/_codejo',
            linkedinUrl: 'https://linkedin.com/in/prince-ofori',
            twitterUrl: 'https://twitter.com/_codejo',
            assetImage: 'assets/images/team/prince.png',
          ),
          TeamCard(
            name: "Prince Ofori",
            role: "Software Tester",
            instaUrl: 'https://instagram.com/_codejo',
            linkedinUrl: 'https://linkedin.com/in/prince-ofori',
            twitterUrl: 'https://twitter.com/_codejo',
            assetImage: 'assets/images/team/prince.png',
          ),
          TeamCard(
            name: "Prince Ofori",
            role: "Mobile UI/UX Designer",
            instaUrl: 'https://instagram.com/_codejo',
            linkedinUrl: 'https://linkedin.com/in/prince-ofori',
            twitterUrl: 'https://twitter.com/_codejo',
            assetImage: 'assets/images/team/prince.png',
          )
        ],
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
