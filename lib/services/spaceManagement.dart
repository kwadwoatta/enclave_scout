import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scout/models/space.dart';

class SpaceManagement {
//*  GET USER SPACES
  Stream<List<DocumentSnapshot>> getVendorSpaces(String userId) {
    return Firestore.instance
        .collection('spaces')
        .where('vendorId', isEqualTo: userId)
        .snapshots()
        .map((qSnapshot) {
      return qSnapshot.documents;
    });
  }

//*  GET ALL SPACES
  Stream<List<DocumentSnapshot>> getAllSpaces(String userId) {
    return Firestore.instance
        .collection('spaces')
        // .where(userId, isEqualTo: null)
        .snapshots()
        .map((qSnapshot) {
      return qSnapshot.documents;
    });
  }

//* ADD SPACE
  Future<void> postEventSpace({
    @required Space space,
    @required List<File> imageFiles,
  }) async {
    try {
      List<String> images = [];
      final user = await FirebaseAuth.instance.currentUser();

      DocumentReference docRef =
          Firestore.instance.collection('/spaces').document();

      List<Future> futures = [];

      imageFiles.asMap().forEach((index, file) async {
        final storageRef = FirebaseStorage.instance.ref().child(
              '/spaces/${docRef.documentID}/${docRef.documentID}_$index.jpg',
            );
        StorageUploadTask task = storageRef.putFile(file);

        futures.add(
          task.onComplete.then((snapshot) async {
            final url = await snapshot.ref.getDownloadURL();
            // print('url');
            // print(url);
            images.add(url.toString());
          }),
        );
      });

      return Future.wait(futures).then((_) {
        // print('images');
        // print(images);

        Map<String, dynamic> newSpace = {
          'vendorId': user.uid,
          'spaceName': space.name,
          'coverPhoto': images[0],
          'images': images,
          'maxCapacity': space.maxCapacity,
          'minCapacity': space.minCapacity,
          'price': space.price,
          'latitude': space.latitude,
          'longitude': space.longitude,
          'address': space.address,
          'rating': space.rating,
          'city': space.city,
          'vendorName': user.displayName,
          'washRooms': space.washroom,
          'parkingLots': space.parkingLot,
          'vendorImage': space.vendorImage,
          'description': space.description,
          'verified': false,
          user.uid: true,
        };

        return docRef.setData(newSpace);
      }).catchError((error) => throw error);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // return Firestore.instance.runTransaction((transactionHandler) {
  //   return transactionHandler.set(docRef, {
  //     'uid': user.uid,
  //     'phoneNumber': '+233$phoneNumber',
  //     'email': email,
  //     'displayName': userName,
  //   }).catchError((e) {
  //     print('addUserToFirestore error');
  //     throw e;
  //   });
  // }).then((_) {
  //   return user;
  // }).catchError((e) {
  //   print('run Transaction error');
  //   throw e;
  // });

// return loginUser(email: email, password: password).then((user) {
//       CollectionReference collectionRef =
//           Firestore.instance.collection('/users');
//       DocumentReference docRef = collectionRef.document('${user.uid}');

//       return Firestore.instance.runTransaction((transactionHandler) {
//         return transactionHandler.set(docRef, {
//           'uid': user.uid,
//           'phoneNumber': '+2330$phoneNumber',
//           'email': user.email,
//           'displayName': user.displayName,
//         }).catchError((e) {
//           print('addUserToFirestore error');
//           throw e;
//         });
//       }).then((_) {
//         return user;
//       }).catchError((e) {
//         print('run Transaction error');
//         throw e;
//       });
//     }).catchError((error) {
//       print(error.message);
//       throw Exception(error.message);
//     });
}
