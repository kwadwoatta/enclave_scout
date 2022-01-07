import 'package:cloud_firestore/cloud_firestore.dart';

class CitiesManagement {
//  GET ALL CITIES IMAGES
  Future<List<DocumentSnapshot>> initGetData() {
    return Firestore.instance.collection('cities').getDocuments().then((query) {
      return query.documents;
    }).catchError((err) {
      throw err;
    });
  }
}
