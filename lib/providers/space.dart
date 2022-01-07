import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scout/models/space.dart';
import 'package:scout/services/spaceManagement.dart';

class SpaceProvider with ChangeNotifier {
  final spaceManagement = SpaceManagement();

  //* StreamController for all of listed spaces
  StreamController<List<Space>> allSpacesController = BehaviorSubject();

  //* StreamController for all of scout's spaces
  StreamController<List<Space>> scoutSpacesController = BehaviorSubject();

  //* StreamController for filtered spaces
  StreamController<List<Space>> filteredSpacesController = BehaviorSubject();

  //* StreamController for searched spaces
  StreamController<List<Space>> searchedSpacesController = BehaviorSubject();

  //* StreamController for length of all spaces
  StreamController<int> spacesLengthController = BehaviorSubject();

  //* StreamController for length of filtered spaces
  StreamController<int> filteredSpacesLengthController = BehaviorSubject();

  //* StreamController for length of searched spaces
  StreamController<int> searchedSpacesLengthController = BehaviorSubject();

  Stream<List<Space>> get mySpaces => scoutSpacesController.stream;
  Stream<List<Space>> get spaces => allSpacesController.stream;
  Stream<List<Space>> get filteredSpaces => filteredSpacesController.stream;
  Stream<List<Space>> get searchedSpaces => searchedSpacesController.stream;
  Stream<int> get spacesLength => spacesLengthController.stream;
  Stream<int> get filteredSpacesLength => filteredSpacesLengthController.stream;
  Stream<int> get searchedSpacesLength => searchedSpacesLengthController.stream;

//* Retreive all available spaces and serve as stream
  // Stream<StreamSubscription<List<DocumentSnapshot>>> retreiveAllSpaces() {
  void retreiveAllSpaces() async {
    // return
    FirebaseAuth.instance.currentUser().then((user) {
      // return
      spaceManagement.getAllSpaces(user.uid).listen((docList) {
        List<Space> spaceList = [];
        //* docList =
        //*     docList.where((snapshot) => snapshot.data['scoutId'] != user.uid);
        docList.forEach((snapshot) {
          var space = Space(
            name: snapshot.data['spaceName'],
            address: snapshot.data['address'],
            city: snapshot.data['city'],
            price: snapshot.data['price'],
            maxCapacity: snapshot.data['maxCapacity'],
            minCapacity: snapshot.data['minCapacity'],
            latitude: snapshot.data['latitude'],
            longitude: snapshot.data['longitude'],
            rating: snapshot.data['rating'],
            venueImages: List<String>.from([...snapshot.data['images']]),
            coverPhoto: snapshot.data['coverPhoto'],
            spaceId: snapshot.documentID,
            vendorId: snapshot.data['vendorId'],
            vendorName: snapshot.data['vendorName'],
            vendorImage: snapshot.data['vendorImage'],
            description: snapshot.data['description'],
            parkingLot: snapshot.data['parkingLots'],
            washroom: snapshot.data['washRooms'],
            verified: snapshot.data['verified'],
          );
          spaceList.add(space);
        });
        allSpacesController.add(spaceList);
        spacesLengthController.add(spaceList.length);
      });
    }).asStream();
  }

//* Filter spaces
  void filterSpaces({
    minCap = 1,
    maxCap = 100,
    city = 'Accra',
  }) {
    filteredSpacesController = BehaviorSubject();
    filteredSpacesLengthController = BehaviorSubject();

    spaces.listen((allSpaces) {
      List<Space> filtered = [];
      allSpaces.forEach((space) {
        if (space.city == city &&
            space.minCapacity >= minCap &&
            space.maxCapacity <= maxCap) filtered.add(space);
      });
      filteredSpacesController.add(filtered);
      filteredSpacesLengthController.add(filtered.length);
    });
  }

//* Search space
  void searchSpaces({
    String name,
  }) {
    searchedSpacesController = BehaviorSubject();
    searchedSpacesLengthController = BehaviorSubject();

    spaces.listen((allSpaces) {
      List<Space> searched = [];
      allSpaces.forEach((space) {
        if (space.name.toLowerCase() == name.toLowerCase()) searched.add(space);
      });
      searchedSpacesController.add(searched);
      searchedSpacesLengthController.add(searched.length);
    });
  }

//* Upload scout space to database
  Future<void> uploadSpace({
    @required Space space,
    @required List<File> imageFiles,
  }) {
    return spaceManagement.postEventSpace(
      space: space,
      imageFiles: imageFiles,
    );
  }

  //* List<Space> getSpaceByCity({String cityName}) {
  //*   return _spaces.where((space) {
  //*     return space.city == cityName;
  //*   });
  //* }
}
