import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scout/screens/enter_phone_number_screen.dart';

import 'package:scout/screens/no_connection_screen.dart';
import 'package:scout/screens/verify_email_screen.dart';
import 'package:scout/screens/verify_phone_screen.dart';
import 'package:scout/screens/waiting_connection_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class UserManagement {
//* INITIAL SCREEN AUTHENTICATION
  Widget handleAuth() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        FirebaseUser user = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting)
          return WaitingConnectionScreen();
        else if (snapshot.connectionState == ConnectionState.none)
          return NoConnectionScreen();
        else {
          if (user != null) {
            if (!user.isEmailVerified) return VerifyEmailScreen();

            return StreamBuilder(
              stream: Firestore.instance
                  .collection('scouts')
                  .document(user.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['phoneNumber'] == null) {
                    return EnterPhoneNumberScreen();
                  }
                  if (!snapshot.data['phoneNumberVerified']) {
                    return VerifyPhoneScreen();
                  }
                  return HomeScreen();
                } else
                  return LoginScreen();
              },
            );
          } else
            return LoginScreen();
        }
      },
    );
  }

//* GET USER DATA
  Stream<DocumentSnapshot> getUserInfo(String userId) {
    return Firestore.instance
        .collection('scouts')
        .document(userId)
        .snapshots()
        .map((docSnapshot) {
      return docSnapshot;
    });
  }

//* LOGIN FUNCTION
  Future<FirebaseUser> loginUser({
    @required String email,
    @required String password,
  }) async {
    try {
      final HttpsCallable canScoutSignIn = CloudFunctions.instance
          .getHttpsCallable(functionName: 'canScoutSignIn');

      final callResult =
          await canScoutSignIn.call(<String, String>{'email': email});
      if (callResult.data) {
        final response = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        final user = response.user;
        return user;
      } else
        throw Exception(
          'You are not signed up for this app. Try signing up or logging in to the vendor app.',
        );
    } catch (error) {
      throw error;
    }
  }

//* LOGIN WITH GOOGLE FUNCTION
  Future<void> logUserInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleSignInAccount = await googleSignIn.signIn();

      final auth = await googleSignInAccount.authentication;
      final result = await FirebaseAuth.instance
          .signInWithCredential(GoogleAuthProvider.getCredential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      ));

      final user = result.user;
      Firestore.instance.runTransaction((transactionHandler) async {
        final userDocRef =
            Firestore.instance.collection('scouts').document(user.uid);

        final userDoc = await transactionHandler.get(userDocRef);
        if (!userDoc.exists)
          return transactionHandler.set(userDocRef, {
            'uid': user.uid,
            'phoneNumber': null,
            'email': user.email,
            'displayName': user.displayName,
            'phoneNumberVerified': false
          });
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

//* SIGNUP FUNCTION
  Future<String> signupUser({
    @required String userName,
    @required String phoneNumber,
    @required String password,
    @required String email,
    @required File profilePic,
  }) async {
    try {
      final HttpsCallable createScout =
          CloudFunctions.instance.getHttpsCallable(functionName: 'createScout');

      String network;
      switch (phoneNumber.substring(0, 3)) {
        case '024':
          network = "MTN";
          break;
        case '054':
          network = "MTN";
          break;
        case '055':
          network = "MTN";
          break;
        case '059':
          network = "MTN";
          break;
        case '027':
          network = "TIGO";
          break;
        case '057':
          network = "TIGO";
          break;
        case '020':
          network = "VODAFONE";
          break;
        case '050':
          network = "VODAFONE";
          break;
        case '026':
          network = "AIRTEL";
          break;
        case '056':
          network = "AIRTEL";
          break;
        default:
      }

      final callResult = await createScout.call({
        'email': email,
        'userName': userName,
        'phoneNumber': phoneNumber,
        'password': password,
        'network': network
      });

      print(callResult.data);
      final userRecord = callResult.data;

      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      FirebaseUser user = result.user;
      final _fcm = FirebaseMessaging();
      final token = await _fcm.getToken();

      if (token != null)
        await Firestore.instance
            .collection('tokens')
            .document(user.uid)
            .setData({
          'createdAt': FieldValue.serverTimestamp(),
          'deviceToken': token,
          'platform': Platform.operatingSystem,
          'user': user.uid,
          'type': 'scout',
        });

      final storageRef = FirebaseStorage.instance.ref().child(
            '/profilePics/${user.uid}/${user.uid}.jpg',
          );

      StorageUploadTask task = storageRef.putFile(profilePic);

      StorageTaskSnapshot snapshot = await task.onComplete;
      final url = await snapshot.ref.getDownloadURL();

      final userUpdateInfo = UserUpdateInfo();

      userUpdateInfo.displayName = userName;
      userUpdateInfo.photoUrl = url.toString();

      await user.updateProfile(userUpdateInfo);

      return userRecord['uid'] as String;
    } catch (error) {
      throw error;
    }
  }

//* RESET FORGOTTEN PASSWORD FUNCTION

//* UPDATE PROFILE PICTURE FUNCTION
  Future<void> updateProfilePic({@required File profilePic}) async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final storageRef = FirebaseStorage.instance.ref().child(
            '/profilePics/${user.uid}/${user.uid}.jpg',
          );

      StorageUploadTask task = storageRef.putFile(profilePic);

      StorageTaskSnapshot snapshot = await task.onComplete;
      final url = await snapshot.ref.getDownloadURL();
      final userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.photoUrl = url;

      await user.updateProfile(userUpdateInfo);
      final query = await Firestore.instance
          .collection('scouts')
          .where('uid', isEqualTo: user.uid)
          .getDocuments();

      Firestore.instance
          .document('scouts/${query.documents[0].documentID}')
          .updateData({'photoUrl': url});
    } catch (error) {
      print(error);
      throw error;
    }
  }

//* ADD PHONE NUMBER AND PROFILE PIC FOR GOOGLE LOGGED IN USER
  Future<void> addPhoneNumberAndDP({
    @required String phoneNumber,
    @required File photo,
  }) async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      final qsnapshot = await Firestore.instance
          .collection('scouts')
          .where('uid', isEqualTo: user.uid)
          .getDocuments();

      await Firestore.instance
          .document('scouts/${qsnapshot.documents[0].documentID}')
          .updateData({
        'phoneNumber': phoneNumber,
        'phoneNumberVerified': false,
      });

      await updateProfilePic(profilePic: photo);
    } catch (error) {
      print(error);
      throw error;
    }
  }

//* UPDATE USERNAME FUNCTION
  Future<void> updateDisplayName({
    @required String displayName,
  }) async {
    try {
      final userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = displayName;

      final user = await FirebaseAuth.instance.currentUser();
      user.updateProfile(userUpdateInfo);
      final query = await Firestore.instance
          .collection('scouts')
          .where('uid', isEqualTo: user.uid)
          .getDocuments();
      Firestore.instance
          .document('scouts/${query.documents[0].documentID}')
          .updateData({'displayName': displayName});
    } catch (error) {
      print(error);
      throw error;
    }
  }

//* UPDATE EMAIL
  Future<void> updateEmail({
    @required String email,
    // @required AuthCredential credential,
  }) async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      user.updateEmail(email);
      final query = await Firestore.instance
          .collection('scouts')
          .where('uid', isEqualTo: user.uid)
          .getDocuments();
      Firestore.instance
          .document('scouts/${query.documents[0].documentID}')
          .updateData({
        'email': email,
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

//* VERIFY EMAIL
  Future<void> verifyEmail({
    @required String email,
  }) async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      await user.sendEmailVerification();
      await user.reload();
    } catch (error) {
      print(error);
      throw error;
    }
  }

//* UPDATE PHONE NUMBER
  Future<void> updatePhoneNumber({
    @required String phoneNumber,
    @required AuthCredential credential,
  }) async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      await user.updatePhoneNumberCredential(credential);
      await user.reload();

      final qsnapshot = await Firestore.instance
          .collection('scouts')
          .where('uid', isEqualTo: user.uid)
          .getDocuments();

      await Firestore.instance
          .document('scouts/${qsnapshot.documents[0].documentID}')
          .updateData({
        'phoneNumber': phoneNumber,
        'phoneNumberVerified': true,
      });

      user = await FirebaseAuth.instance.currentUser();
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
