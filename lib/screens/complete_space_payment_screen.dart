import 'package:flutter/material.dart';
import 'package:scout/models/payment.dart';
import 'package:scout/widgets/complete_space_payment_screen/complete_space_payment.dart';

class CompleteSpacePaymentScreen extends StatelessWidget {
  static const routeName = '/complete-space-payment';

  final Payment payment;
  CompleteSpacePaymentScreen({@required this.payment});

  @override
  Widget build(BuildContext context) {
    return CompleteSpacePayment(
      payment: payment,
    );
  }
}
