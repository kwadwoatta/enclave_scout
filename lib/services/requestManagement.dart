import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:scout/models/request.dart';

class RequestManagement {
//*  GET USER REQUESTS
  Stream<List<DocumentSnapshot>> getScoutRequests(String userId) {
    return Firestore.instance
        .collection('requests')
        .where('scoutId', isEqualTo: userId)
        .snapshots()
        .map((qSnapshot) {
      return qSnapshot.documents;
    });
  }

//* ADD request
  Future<void> postRequest({
    @required Request request,
  }) async {
    try {
      final user = await FirebaseAuth.instance.currentUser();

      DocumentReference docRef =
          Firestore.instance.collection('/requests').document();

      String status;
      switch (request.status) {
        case RequestStatus.PENDING:
          status = 'pending';
          break;
        case RequestStatus.CANCELED:
          status = 'canceled';
          break;
        case RequestStatus.REJECTED:
          status = 'rejected';
          break;
        case RequestStatus.ACCEPTED:
          status = 'accepted';
          break;
      }

      Map<String, dynamic> newrequest = {
        'requestId': docRef.documentID,
        'spaceName': request.spaceName,
        'eventDate': request.eventDate.toIso8601String(),
        'creationDate': request.creationDate.toIso8601String(),
        'cancelationDate': null,
        'rejectionDate': null,
        'acceptanceDate': null,
        'maxCapacity': request.maxCapacity,
        'hours': request.hours,
        'status': status,
        'viewedByVendor': request.viewedByVendor,
        'viewedByScout': request.viewedByScout,
        'paid': request.paid,
        'pricePerHour': request.pricePerHour,
        'spaceImages': request.spaceImages,
        'scoutId': user.uid,
        'scoutName': user.displayName,
        'scoutPhotoUrl': user.photoUrl,
        'vendorId': request.vendorId,
        'vendorName': request.vendorName,
        'vendorPhotoUrl': request.vendorPhotoUrl,
      };
      return docRef.setData(newrequest);
    } catch (error) {
      print(error);
      throw error;
    }
  }

//* Toggle request view
  Future<void> toggleViewed({
    @required String id,
  }) async {
    try {
      DocumentReference docRef =
          Firestore.instance.collection('/requests').document(id);

      return docRef.updateData({'viewedByScout': true});
    } catch (error) {
      print(error);
      throw error;
    }
  }

//* Cancel request
  Future<void> cancelRequest({
    @required String id,
  }) async {
    try {
      DocumentReference docRef =
          Firestore.instance.collection('/requests').document(id);

      return docRef.updateData({
        'cancelationDate': DateTime.now().toIso8601String(),
        'status': 'canceled',
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
