import 'package:flutter/cupertino.dart';

enum PaymentMethod { MTN, VODAFONE, TIGO, AIRTEL, ATM }
enum PaymentStatus { INITIATED, PENDING, CANCELED, ACCEPTED }

class Payment {
  final String paymentId;
  final String requestId;
  final String scoutId;
  final String scoutName;
  final String vendorId;
  final String vendorName;
  final String spaceName;
  final DateTime eventDate;
  final DateTime creationDate;
  final int hours;
  final int maxCapacity;
  bool viewed;
  final String scoutPhotoUrl;
  final String vendorPhotoUrl;
  final PaymentMethod method;
  final PaymentStatus status;
  final double pricePerHour;
  double bookingFee;
  double bookProcessingFee;
  double scoutTotal;
  double appFee;
  double appProcessingFee;
  double scoutTotalReceived;

  Payment({
    @required this.paymentId,
    @required this.requestId,
    @required this.spaceName,
    @required this.eventDate,
    @required this.creationDate,
    @required this.scoutId,
    @required this.scoutName,
    @required this.vendorId,
    @required this.vendorName,
    @required this.hours,
    @required this.maxCapacity,
    @required this.scoutPhotoUrl,
    @required this.vendorPhotoUrl,
    @required this.method,
    @required this.pricePerHour,
    @required this.status,
    this.viewed = false,
  }) {
    bookingFee = pricePerHour * hours;
    bookProcessingFee = bookingFee * .01;
    scoutTotal = bookingFee + bookProcessingFee;
    appFee = bookingFee * .05;
    appProcessingFee = appFee * .01;
    scoutTotalReceived = bookingFee - appFee - appProcessingFee;
  }
}
