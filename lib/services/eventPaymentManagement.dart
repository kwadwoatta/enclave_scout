import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scout/models/eventPayment.dart';

class EventPaymentManagement {
//*  GET SCOUT EVENT PAYMENTS
  Stream<List<DocumentSnapshot>> getScoutPayment(String userId) {
    return Firestore.instance
        .collection('eventPayments')
        .where('scoutId', isEqualTo: userId)
        .snapshots()
        .map((qSnapshot) {
      return qSnapshot.documents;
    });
  }

//* MAKE PAYMENT
  Future<void> makePayment({
    @required EventPayment payment,
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
        'eventDate': payment.eventDate.toIso8601String(),
        'creationDate': payment.creationDate.toIso8601String(),
        'scoutId': user.uid,
        'scoutName': user.displayName,
        'scoutPhotoUrl': user.photoUrl,
        'method': payment.method,
        'status': "INITIATED",
      };

      await paymentDocRef.setData(newPayment);

      final callRes = await payForRequestedSpace.call({
        "scoutID": user.uid,
        "totalAmount": payment.scoutTotal,
        "scoutPhoneNumber": '0${user.phoneNumber.substring(4)}',
        "scoutNetwork": network,
        "paymentID": paymentDocRef,
        "scoutName": user.displayName,
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
