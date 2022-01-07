import 'package:flutter/cupertino.dart';

enum PaymentMethod { MTN, VODAFONE, TIGO, AIRTEL, ATM }
enum PaymentStatus { INITIATED, PENDING, CANCELED, ACCEPTED }

class EventPayment {
  final String paymentId;
  final String scoutId;
  final String scoutName;
  final DateTime eventDate;
  final DateTime creationDate;
  final String scoutPhotoUrl;
  final PaymentMethod method;
  final PaymentStatus status;
  double eventPostFee;
  double scoutTotal;
  double scoutTotalReceived;

  EventPayment({
    @required this.paymentId,
    @required this.eventDate,
    @required this.creationDate,
    @required this.scoutId,
    @required this.scoutName,
    @required this.scoutPhotoUrl,
    @required this.method,
    @required this.status,
  }) {
    // bookingFee = pricePerHour * hours;
    // bookProcessingFee = bookingFee * .01;
    // scoutTotal = bookingFee + bookProcessingFee;
    // appFee = bookingFee * .05;
    // appProcessingFee = appFee * .01;
    // scoutTotalReceived = bookingFee - appFee - appProcessingFee;
  }
}
