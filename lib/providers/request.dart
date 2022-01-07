import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scout/models/request.dart';
import 'package:scout/services/requestManagement.dart';

class RequestProvider with ChangeNotifier {
  final requestManagement = RequestManagement();

  StreamController<int> viewedRequestsLengthController = BehaviorSubject();
  StreamController<List<Request>> scoutRequestsController = BehaviorSubject();
  StreamController<int> scoutRequestsLengthController = BehaviorSubject();

  Stream<int> get viewedRequestsLength => viewedRequestsLengthController.stream;
  Stream<List<Request>> get scoutRequests => scoutRequestsController.stream;
  Stream<int> get scoutRequestsLength => scoutRequestsLengthController.stream;

//* Retreive all of users's sent requests and serve as stream
  Stream<StreamSubscription<List<DocumentSnapshot>>> retreiveScoutRequests() {
    return FirebaseAuth.instance.currentUser().then((user) {
      return requestManagement.getScoutRequests(user.uid).listen((docList) {
        List<Request> requestList = [];
        List<Request> viewedRequestList = [];

        docList.forEach((snapshot) {
          RequestStatus status;
          switch (snapshot.data['status']) {
            case 'pending':
              status = RequestStatus.PENDING;
              break;
            case 'canceled':
              status = RequestStatus.CANCELED;
              break;
            case 'rejected':
              status = RequestStatus.REJECTED;
              break;
            case 'accepted':
              status = RequestStatus.ACCEPTED;
              break;
          }

          final request = Request(
            scoutId: snapshot.data['scoutId'],
            scoutName: snapshot.data['scoutName'],
            acceptanceDate: snapshot.data['acceptanceDate'] != null
                ? DateTime.parse(snapshot.data['acceptanceDate'])
                : null,
            cancelationDate: snapshot.data['cancelationDate'] != null
                ? DateTime.parse(snapshot.data['cancelationDate'])
                : null,
            creationDate: snapshot.data['creationDate'] != null
                ? DateTime.parse(snapshot.data['creationDate'])
                : null,
            eventDate: snapshot.data['eventDate'] != null
                ? DateTime.parse(snapshot.data['eventDate'])
                : null,
            rejectionDate: snapshot.data['rejectionDate'] != null
                ? DateTime.parse(snapshot.data['rejectionDate'])
                : null,
            requestId: snapshot.data['requestId'],
            vendorId: snapshot.data['vendorId'],
            vendorName: snapshot.data['vendorName'],
            spaceName: snapshot.data['spaceName'],
            status: status,
            hours: snapshot.data['hours'],
            maxCapacity: snapshot.data['maxCapacity'],
            viewedByScout: snapshot.data['viewedByScout'],
            viewedByVendor: snapshot.data['viewedByVendor'],
            paid: snapshot.data['paid'],
            scoutPhotoUrl: snapshot.data['scoutPhotoUrl'],
            spaceImages: List<String>.from([...snapshot.data['spaceImages']]),
            vendorPhotoUrl: snapshot.data['vendorPhotoUrl'],
            pricePerHour: snapshot.data['pricePerHour'],
          );
          requestList.add(request);
          if (request.viewedByScout) viewedRequestList.add(request);
        });
        scoutRequestsController.add(requestList);
        scoutRequestsLengthController.add(requestList.length);
        viewedRequestsLengthController.add(viewedRequestList.length);
      });
    }).asStream();
  }

//* Submit user request to database
  Future<void> sendRequest({@required Request request}) {
    return requestManagement.postRequest(request: request);
  }

//* Toggle request view status to true
  Future<void> toggleViewed({@required String requestId}) {
    return requestManagement.toggleViewed(id: requestId);
  }

//* Cancel request
  Future<void> cancelRequest({@required String requestId}) {
    return requestManagement.cancelRequest(id: requestId);
  }
}
