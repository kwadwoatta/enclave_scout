import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scout/models/payment.dart';
import 'package:scout/services/paymentManagement.dart';

class PaymentProvider with ChangeNotifier {
  final paymentManagement = PaymentManagement();
  StreamController<List<Payment>> allPaymentsController = BehaviorSubject();
  // StreamController<int> PaymentsLengthController = BehaviorSubject();
  StreamController<int> unviewedPaymentsLengthController = BehaviorSubject();

  StreamController<List<Payment>> spacePaymentsController = BehaviorSubject();
  StreamController<int> spacePaymentsLengthController = BehaviorSubject();

  Stream<List<Payment>> get scoutPayments => allPaymentsController.stream;
  // Stream<int> get scoutPaymentsLength => PaymentsLengthController.stream;
  Stream<int> get unviewedPaymentsLength =>
      unviewedPaymentsLengthController.stream;

  Stream<List<Payment>> get spacePayments => spacePaymentsController.stream;
  // Stream<int> get spacePaymentsLength => PaymentsLengthController.stream;

//* Retreive all of users's sent Payments and serve as stream
  Stream<StreamSubscription<List<DocumentSnapshot>>> retreiveScoutPayments() {
    return FirebaseAuth.instance.currentUser().then((user) {
      return paymentManagement.getScoutPayment(user.uid).listen((docList) {
        List<Payment> paymentList = [];

        docList.forEach((snapshot) {
          PaymentMethod method;
          switch (snapshot.data['method']) {
            case 'MTN':
              method = PaymentMethod.MTN;
              break;
            case 'VODAFONE':
              method = PaymentMethod.VODAFONE;
              break;
            case 'AIRTEL':
              method = PaymentMethod.AIRTEL;
              break;
            case 'TIGO':
              method = PaymentMethod.TIGO;
              break;
            case 'ATM':
              method = PaymentMethod.ATM;
              break;
          }

          final payment = Payment(
            scoutId: snapshot.data['scoutId'],
            requestId: snapshot.data['requestId'],
            scoutName: snapshot.data['scoutName'],
            creationDate: snapshot.data['creationDate'] != null
                ? DateTime.parse(snapshot.data['creationDate'])
                : null,
            eventDate: snapshot.data['eventDate'] != null
                ? DateTime.parse(snapshot.data['eventDate'])
                : null,
            vendorId: snapshot.data['vendorId'],
            vendorName: snapshot.data['vendorName'],
            spaceName: snapshot.data['spaceName'],
            hours: snapshot.data['hours'],
            maxCapacity: snapshot.data['maxCapacity'],
            viewed: snapshot.data['viewed'],
            scoutPhotoUrl: snapshot.data['scoutPhotoUrl'],
            vendorPhotoUrl: snapshot.data['vendorPhotoUrl'],
            pricePerHour: snapshot.data['pricePerHour'],
            paymentId: snapshot.data['paymentId'],
            status: snapshot.data['status'],
            method: method,
          );
          paymentList.add(payment);
        });
        allPaymentsController.add(paymentList);
        // PaymentsLengthController.add(paymentList.length);
      });
    }).asStream();
  }

//* Retreive all of scout's made Payments
  Stream<StreamSubscription<List<DocumentSnapshot>>> retreiveSpacePayments() {
    return FirebaseAuth.instance.currentUser().then((user) {
      return paymentManagement.getReceivedPayment(user.uid).listen((docList) {
        List<Payment> paymentList = [];
        List<Payment> unviewedPaymentList = [];

        docList.forEach((snapshot) {
          PaymentMethod method;
          switch (snapshot.data['status']) {
            case 'MTN':
              method = PaymentMethod.MTN;
              break;
            case 'VODAFONE':
              method = PaymentMethod.VODAFONE;
              break;
            case 'AIRTEL':
              method = PaymentMethod.AIRTEL;
              break;
            case 'TIGO':
              method = PaymentMethod.TIGO;
              break;
            case 'ATM':
              method = PaymentMethod.ATM;
              break;
          }

          final payment = Payment(
            scoutId: snapshot.data['scoutId'],
            requestId: snapshot.data['requestId'],
            scoutName: snapshot.data['scoutName'],
            creationDate: snapshot.data['creationDate'] != null
                ? DateTime.parse(snapshot.data['creationDate'])
                : null,
            eventDate: snapshot.data['eventDate'] != null
                ? DateTime.parse(snapshot.data['eventDate'])
                : null,
            vendorId: snapshot.data['vendorId'],
            vendorName: snapshot.data['vendorName'],
            spaceName: snapshot.data['spaceName'],
            hours: snapshot.data['hours'],
            maxCapacity: snapshot.data['maxCapacity'],
            viewed: snapshot.data['viewed'],
            scoutPhotoUrl: snapshot.data['scoutPhotoUrl'],
            vendorPhotoUrl: snapshot.data['vendorPhotoUrl'],
            pricePerHour: snapshot.data['pricePerHour'],
            paymentId: snapshot.data['paymentId'],
            method: method,
            status: snapshot.data['status'],
          );
          paymentList.add(payment);
          if (!payment.viewed) unviewedPaymentList.add(payment);
        });
        spacePaymentsController.add(paymentList);
        spacePaymentsLengthController.add(paymentList.length);
        unviewedPaymentsLengthController.add(unviewedPaymentList.length);
      });
    }).asStream();
  }

//* Submit user Payment to database
  Future<void> makePayment({@required Payment payment}) {
    return paymentManagement.makePayment(payment: payment);
  }

//* Toggle payment view status to true
  Future<void> toggleViewed({@required String paymentId}) {
    return paymentManagement.toggleViewed(id: paymentId);
  }
}
