import 'package:flutter/material.dart';

import 'package:scout/models/payment.dart';
import 'package:scout/models/request.dart';
import 'package:scout/screens/complete_space_payment_screen.dart';

class MomoCard extends StatelessWidget {
  final String logoPath;
  final Color brandColor;
  final Color backgroundColor;
  final String brandName;
  final String prefix;
  final Request request;

  MomoCard({
    @required this.brandName,
    @required this.brandColor,
    @required this.logoPath,
    @required this.backgroundColor,
    @required this.prefix,
    @required this.request,
  });

  goToCompletePayment(context) {
    PaymentMethod method;

    switch (brandName) {
      case 'Airtel Cash':
        method = PaymentMethod.AIRTEL;
        break;
      case 'Tigo Cash':
        method = PaymentMethod.TIGO;
        break;
      case 'Vodafone Cash':
        method = PaymentMethod.VODAFONE;
        break;
      case 'Mtn Mobile Money':
        method = PaymentMethod.MTN;
        break;
      default:
    }

    final payment = Payment(
      requestId: request.requestId,
      scoutName: request.scoutName,
      scoutPhotoUrl: request.scoutPhotoUrl,
      vendorName: request.vendorName,
      scoutId: request.scoutId,
      spaceName: request.spaceName,
      vendorPhotoUrl: request.vendorPhotoUrl,
      vendorId: request.vendorId,
      pricePerHour: request.pricePerHour,
      method: method,
      maxCapacity: request.maxCapacity,
      hours: request.hours,
      eventDate: request.eventDate,
      creationDate: null,
      paymentId: null,
      status: null,
    );

    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => CompleteSpacePaymentScreen(
          payment: payment,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final accentColor = Theme.of(context).accentColor;

    return Card(
      elevation: 10,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        splashColor: brandColor,
        onTap: () => goToCompletePayment(context),
        child: Container(
          height: height * .06,
          width: width * .75,
          padding: EdgeInsets.symmetric(
            vertical: height * .01,
            horizontal: width * .06,
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
                              brandName,
                              style: TextStyle(
                                color: brandColor,
                                fontWeight: FontWeight.bold,
                                fontSize: width * .06,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Image.asset(
                                'assets/images/cards/emv.png',
                                height: height * .065,
                                width: width * .1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Image.asset(
                          logoPath,
                          height: height * .055,
                          width: width * .055,
                        ),
                        // Image.asset('assets/images/cards/airtel-logo-2.png'),
                        // Image.asset('assets/images/cards/vodafone-logo.png'),
                        // ,
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
                      prefix,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: width * .06,
                      ),
                    ),
                    SizedBox(width: width * .08),
                    Text(
                      '•••',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: width * .1,
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(width: width * .08),
                    Text(
                      '••••',
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
                      'Enclave Scout',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: width * .04,
                      ),
                    ),
                    Text(
                      '01 / 2020',
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
