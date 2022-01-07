import 'package:flutter/material.dart';
import 'package:scout/models/payment.dart';
import 'package:scout/widgets/complete_space_payment_screen/body.dart';

class CompleteSpacePayment extends StatelessWidget {
  final Payment payment;
  CompleteSpacePayment({@required this.payment});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text(
          'Complete Payment',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: CompleteSpacePaymentBody(
        payment: payment,
      ),
    );
  }
}
