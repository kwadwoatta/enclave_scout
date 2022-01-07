import 'package:flutter/foundation.dart';

enum EventType {
  MEETING,
  DINNER,
  PARTY,
  TRADE_SHOW,
  CONFERENCE,
  SEMINAR,
  WORKSHOP,
}

enum Region {
  ASHANTI,
  GREATER_ACCRA,
  WESTERN,
  EASTERN,
  CENTRAL,
  NORTHERN,
  BRONG_AHAFO,
}

class Space {
  String spaceId;
  String name;
  String vendorName;
  String vendorId;
  int maxCapacity;
  int minCapacity;
  double price;
  String city;
  String address;
  double latitude;
  double longitude;
  String coverPhoto;
  List<String> venueImages;
  int rating;
  int parkingLot;
  int washroom;
  String description;
  String vendorImage;
  bool verified;
  // String district;
  // List<EventType> events;

  Space({
    this.spaceId,
    this.vendorId,
    this.venueImages,
    this.vendorName,
    this.coverPhoto,
    @required this.name,
    @required this.maxCapacity,
    @required this.minCapacity,
    @required this.price,
    @required this.city,
    @required this.address,
    @required this.rating,
    @required this.latitude,
    @required this.longitude,
    this.parkingLot,
    this.washroom,
    this.description,
    this.vendorImage,
    this.verified,
  });
}
