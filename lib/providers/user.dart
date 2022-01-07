import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scout/widgets/showAlertDialog.dart';
import 'package:scout/widgets/show_alert_dialog.dart';
import 'package:scout/widgets/show_error_dialog.dart';

import '../services/userManagement.dart';
import '../models/scout.dart';

class UserProvider with ChangeNotifier {
  String verificationId;
  final userManagement = UserManagement();
  StreamController<Scout> userInfoController = BehaviorSubject();

  Stream<Scout> get user => userInfoController.stream;

  //* Retreive all of scout's spaces and serve as stream
  // Stream<StreamSubscription<List<DocumentSnapshot>>> retreiveUserSpaces() {
  Future<void> retreiveUserSpaces() async {
    final user = await FirebaseAuth.instance.currentUser();
    return userManagement.getUserInfo(user.uid).listen((snapshot) {
      final scout = Scout(
        name: snapshot.data['displayName'],
        email: snapshot.data['email'],
        phoneNumber: snapshot.data['phoneNumber'],
        scoutID: snapshot.data['uid'],
        photoUrl: user.photoUrl,
        network: snapshot.data['network'],
      );
      userInfoController.add(scout);
    });
  }

  //* log user in
  Future<void> logUserIn({
    @required String email,
    @required String password,
  }) {
    return userManagement.loginUser(
      email: email,
      password: password,
    );
  }

  Future<void> logUserInWithGoogle() {
    return userManagement.logUserInWithGoogle();
  }

  //* send opt manually
  Future<void> manualSendOPT({
    @required BuildContext context,
    @required String phoneNumber,
  }) {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (verId) {
      verificationId = verId;
      notifyListeners();
      print('autoretreival timed out');
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      verificationId = verId;

      showAlertDialog(
        context: context,
        type: "success",
        message: "We've sent you an SMS code. Please enter it below",
      );
      notifyListeners();
    };

    final PhoneVerificationCompleted verifySucceed = (AuthCredential authCred) {
      ShowAlertDialog(
          context: context, actionable: false, message: "Verifying ...");
      Navigator.of(context).pushReplacementNamed('/verify-card');
    };

    final PhoneVerificationFailed verifyFailed = (AuthException authEx) {
      throw Exception(authEx.message);
    };

    return FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: "+2330$phoneNumber",
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 30),
      verificationFailed: verifyFailed,
      verificationCompleted: verifySucceed,
    )
        .catchError((error) {
      print(error);
      ErrorDialog(context: context, error: error);

      throw Exception(error);
    });
  }

  //* sign user up
  Future<void> signUserUp({
    @required String userName,
    @required String phoneNumber,
    @required String password,
    @required String email,
    @required File profilePic,
  }) {
    return userManagement.signupUser(
      email: email,
      userName: userName,
      phoneNumber: phoneNumber,
      password: password,
      profilePic: profilePic,
    );
  }

  //* update user profile picture
  Future<void> updateProfilePic({@required File image}) {
    return userManagement.updateProfilePic(profilePic: image);
  }

  //* update user's phone number
  Future<void> updatePhoneNumber({
    @required String phoneNumber,
    @required AuthCredential credential,
  }) {
    try {
      return userManagement.updatePhoneNumber(
        phoneNumber: phoneNumber,
        credential: credential,
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  //* update user's email
  Future<void> addPhoneNumberAndDP({
    @required String phoneNumber,
    @required File photo,
  }) {
    return userManagement.addPhoneNumberAndDP(
      phoneNumber: phoneNumber,
      photo: photo,
    );
  }

  //* update user's email
  Future<void> updateEmail({@required String email}) {
    return userManagement.updateEmail(email: email);
  }

  //* verify user's email
  Future<void> verifyEmail({@required String email}) {
    return userManagement.verifyEmail(email: email);
  }

  //* update user's profile picture
  Future<void> uploadPicFunc({@required File picture}) async {
    return userManagement.updateProfilePic(profilePic: picture);
  }
}
