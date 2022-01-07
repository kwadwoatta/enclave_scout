import 'package:flutter/cupertino.dart';

enum Payment { FULL, PART }

enum PaymentMethod {
  MOBILE_MONEY,
  VISA,
}

class Receipt {
  String receiptId;
  Payment payment;
  PaymentMethod paymentMethod;
  String renterId;
  String renterName;
  String scoutId;
  // balance can negative(amount the scout owes the renter) or positive (amount the renter owes the scout)
  int balance;
  DateTime dateOfPayment;

  Receipt({
    @required this.receiptId,
    @required this.payment,
    @required this.paymentMethod,
    @required this.renterId,
    @required this.renterName,
    @required this.scoutId,
    @required this.balance,
    @required this.dateOfPayment,
  });
}

// Note: There can be multiple receipts for a single space being hired
// That is if payment were made in parts
