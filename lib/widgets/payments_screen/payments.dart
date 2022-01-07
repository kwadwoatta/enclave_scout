import 'package:flutter/material.dart';
import 'package:scout/widgets/payments_screen/body.dart';

class Payments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Payments'),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: PaymentsBody(),
    );
  }
}
