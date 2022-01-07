import 'package:flutter/material.dart';
import 'package:scout/models/request.dart';
import 'package:scout/widgets/requests_screen/sub_widgets/momo_card.dart';

class ShowPaymentBottomSheet {
  final BuildContext context;
  final Request request;

  ShowPaymentBottomSheet({
    @required this.context,
    @required this.request,
  });

  view() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final accentColor = Theme.of(context).accentColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white.withOpacity(0.7),
      builder: ((context) => Container(
            padding: EdgeInsets.all(height * .005),
            height: height * .25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: height * .01,
                    horizontal: width * .05,
                  ),
                  child: Text(
                    'CHOOSE PAYMENT OPTION',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: width * .045,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: height * .005,
                      horizontal: width * .02,
                    ),
                    child: ListView(
                      children: <Widget>[
                        MomoCard(
                          request: request,
                          brandName: 'Airtel Cash',
                          backgroundColor: Colors.white,
                          brandColor: Color(0xFFec1c24),
                          logoPath: 'assets/images/cards/airtel-logo.png',
                          prefix: '056',
                        ),
                        MomoCard(
                          request: request,
                          brandName: 'Tigo Cash',
                          backgroundColor: Colors.white,
                          brandColor: Color(0xFF01377a),
                          logoPath: 'assets/images/cards/tigo-logo.png',
                          prefix: '057',
                        ),
                        MomoCard(
                          request: request,
                          brandName: 'Vodafone Cash',
                          backgroundColor: Colors.white,
                          brandColor: Color(0xFFe60000),
                          logoPath: 'assets/images/cards/vodafone-logo-2.png',
                          prefix: '050',
                        ),
                        MomoCard(
                          request: request,
                          brandName: 'Mtn Mobile Money',
                          backgroundColor: Color(0xFFffcc00),
                          brandColor: Colors.white,
                          logoPath: 'assets/images/cards/mtn-logo.png',
                          prefix: '054',
                        ),
                      ],
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
