import 'package:flutter/foundation.dart';

class Scout {
  String scoutID;
  String name;
  String phoneNumber;
  String email;
  String photoUrl;
  String network;
  // List<Space> vendingSpaces;
  // List<Receipt> receipts;
  // Card card;
  // List<String> favoritesIDs;

  Scout({
    @required this.scoutID,
    @required this.name,
    @required this.phoneNumber,
    @required this.photoUrl,
    @required this.email,
    @required this.network,
    // this.favoritesIDs,
    // this.vendingSpaces,
    // this.receipts,
    // this.card,
  });
}
