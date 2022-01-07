import 'package:flutter/cupertino.dart';

enum RequestStatus {
  PENDING,
  CANCELED,
  REJECTED,
  ACCEPTED,
}

class Request {
  final String requestId;
  final String spaceName;
  final DateTime eventDate;
  final DateTime creationDate;
  final DateTime cancelationDate;
  final DateTime rejectionDate;
  final DateTime acceptanceDate;
  final RequestStatus status;
  final String scoutId;
  final String scoutName;
  final String vendorId;
  final String vendorName;
  final int hours;
  final double pricePerHour;
  final int maxCapacity;
  final bool viewedByVendor;
  final bool viewedByScout;
  final bool paid;
  final String vendorPhotoUrl;
  final String scoutPhotoUrl;
  final List<String> spaceImages;

  Request({
    @required this.requestId,
    @required this.spaceName,
    @required this.eventDate,
    @required this.creationDate,
    @required this.cancelationDate,
    @required this.rejectionDate,
    @required this.acceptanceDate,
    @required this.status,
    @required this.scoutId,
    @required this.scoutName,
    @required this.vendorId,
    @required this.vendorName,
    @required this.hours,
    @required this.maxCapacity,
    @required this.scoutPhotoUrl,
    @required this.vendorPhotoUrl,
    @required this.spaceImages,
    @required this.pricePerHour,
    this.viewedByScout = false,
    this.viewedByVendor = false,
    this.paid = false,
  });
}
