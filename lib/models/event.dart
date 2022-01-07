import 'package:flutter/foundation.dart';

class Event {
  String advertiserId;
  String advertistmentId;
  String adName;
  String description;
  String phoneNumber;
  String coverPhoto;
  // String eventLocation;
  String address;
  List<String> flyers;
  DateTime creationDate;
  DateTime eventDate;
  double price;
  bool isFavorite;
  String city;

  Event({
    @required this.advertistmentId,
    @required this.advertiserId,
    @required this.adName,
    @required this.creationDate,
    @required this.price,
    @required this.description,
    @required this.flyers,
    @required this.coverPhoto,
    @required this.phoneNumber,
    this.isFavorite = false,
    @required this.eventDate,
    @required this.address,
    // @required this.eventLocation,
    @required this.city,
  });
}
