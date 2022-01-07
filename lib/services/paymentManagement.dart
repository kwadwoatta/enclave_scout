import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scout/models/payment.dart';

class PaymentManagement {
//*  GET SCOUT TRANSACTIONS
  Stream<List<DocumentSnapshot>> getScoutPayment(String userId) {
    return Firestore.instance
        .collection('payments')
        .where('paymentId', isEqualTo: userId)
        .snapshots()
        .map((qSnapshot) {
      return qSnapshot.documents;
    });
  }

//*  GET VENDOR PAYMENT
  Stream<List<DocumentSnapshot>> getReceivedPayment(String userId) {
    return Firestore.instance
        .collection('payments')
        .where('scoutId', isEqualTo: userId)
        .snapshots()
        .map((qSnapshot) {
      return qSnapshot.documents;
    });
  }

//* MAKE PAYMENT
  Future<void> makePayment({
    @required Payment payment,
  }) async {
    try {
      String network;
      switch (payment.method) {
        case PaymentMethod.MTN:
          network = "MTN";
          break;
        case PaymentMethod.MTN:
          network = "MTN";
          break;
        case PaymentMethod.MTN:
          network = "MTN";
          break;
        case PaymentMethod.MTN:
          network = "MTN";
          break;
        case PaymentMethod.TIGO:
          network = "TGO";
          break;
        case PaymentMethod.TIGO:
          network = "TGO";
          break;
        case PaymentMethod.VODAFONE:
          network = "VDF";
          break;
        case PaymentMethod.VODAFONE:
          network = "VDF";
          break;
        case PaymentMethod.AIRTEL:
          network = "ATL";
          break;
        case PaymentMethod.AIRTEL:
          network = "ATL";
          break;
        default:
      }

      final HttpsCallable payForRequestedSpace = CloudFunctions.instance
          .getHttpsCallable(functionName: 'payForRequestedSpace');
      final user = await FirebaseAuth.instance.currentUser();

      DocumentReference paymentDocRef =
          Firestore.instance.collection('/payments').document();

      Map<String, dynamic> newPayment = {
        'paymentId': paymentDocRef.documentID,
        'spaceName': payment.spaceName,
        'eventDate': payment.eventDate.toIso8601String(),
        'creationDate': payment.creationDate.toIso8601String(),
        'scoutId': user.uid,
        'scoutName': user.displayName,
        'maxCapacity': payment.maxCapacity,
        'hours': payment.hours,
        'vendorId': payment.vendorId,
        'vendorName': payment.vendorName,
        'viewed': payment.viewed,
        'scoutPhotoUrl': user.photoUrl,
        'vendorPhotoUrl': payment.vendorPhotoUrl,
        'method': payment.method,
        'status': "INITIATED",
      };

      await paymentDocRef.setData(newPayment);

      final callRes = await payForRequestedSpace.call({
        "scoutID": user.uid,
        "requestID": payment.requestId,
        "totalAmount": payment.scoutTotal,
        "scoutPhoneNumber": '0${user.phoneNumber.substring(4)}',
        "vendorID": payment.vendorId,
        "scoutNetwork": network,
        "paymentID": paymentDocRef,
        "paymentFee": payment.bookProcessingFee,
        "spaceName": payment.spaceName,
        "scoutName": user.displayName,
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

//* Toggle payment view
  Future<void> toggleViewed({@required String id}) async {
    try {
      DocumentReference docRef =
          Firestore.instance.collection('/payments').document(id);

      return docRef.updateData({'viewed': true});
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
