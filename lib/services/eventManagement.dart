import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scout/models/event.dart';

class EventManagement {
//*  GET USER EVENTS
  Stream<List<DocumentSnapshot>> getScoutEvents(String userId) {
    return Firestore.instance
        .collection('events')
        .where('scoutId', isEqualTo: userId)
        .snapshots()
        .map((qSnapshot) {
      return qSnapshot.documents;
    });
  }

//*  GET ALL EVENTS
  Stream<List<DocumentSnapshot>> getAllEvents(String userId) {
    return Firestore.instance.collection('events').snapshots().map((qSnapshot) {
      return qSnapshot.documents;
    });
  }

//* ADD EVENT
  Future<void> postEvent({
    @required Event event,
    @required List<File> imageFiles,
  }) async {
    try {
      List<String> images = [];
      final user = await FirebaseAuth.instance.currentUser();

      DocumentReference docRef =
          Firestore.instance.collection('/events').document();

      List<Future> futures = [];

      imageFiles.asMap().forEach((index, file) async {
        final storageRef = FirebaseStorage.instance.ref().child(
              '/spaces/${docRef.documentID}/${docRef.documentID}_$index.jpg',
            );
        StorageUploadTask task = storageRef.putFile(file);

        futures.add(
          task.onComplete.then((snapshot) async {
            final url = await snapshot.ref.getDownloadURL();
            images.add(url.toString());
          }),
        );
      });

      return Future.wait(futures).then((_) {
        Map<String, dynamic> newEvent = {
          'advertiserId': user.uid,
          'advertistmentId': docRef.documentID,
          'eventName': event.adName,
          'address': event.address,
          'city': event.city,
          'price': event.price,
          'coverPhoto': images[0],
          'creationDate': DateTime.now().toIso8601String(),
          'eventDate': event.eventDate.toIso8601String(),
          'description': event.description,
          'flyers': images,
          'isFavorite': event.isFavorite,
          'phoneNumber': event.phoneNumber,
        };

        return docRef.setData(newEvent);
      }).catchError((error) => throw error);
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
