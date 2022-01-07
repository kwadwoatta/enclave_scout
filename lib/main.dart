import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scout/providers/cities.dart';
import 'package:scout/providers/events.dart';
import 'package:scout/providers/request.dart';
import 'package:scout/providers/space.dart';
import 'package:scout/providers/user.dart';

import './services/userManagement.dart';
import './routes/routes.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(MyApp()),
  );
}

const Map<int, Color> color = {
  50: Color.fromRGBO(55, 200, 136, .1),
  100: Color.fromRGBO(55, 200, 136, .2),
  200: Color.fromRGBO(55, 200, 136, .3),
  300: Color.fromRGBO(55, 200, 136, .4),
  400: Color.fromRGBO(55, 200, 136, .5),
  500: Color.fromRGBO(55, 200, 136, .6),
  600: Color.fromRGBO(55, 200, 136, .7),
  700: Color.fromRGBO(55, 200, 136, .8),
  800: Color.fromRGBO(55, 200, 136, .9),
  900: Color.fromRGBO(55, 200, 136, 1),
};
MaterialColor customThemeColor = MaterialColor(0xFF37c888, color);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _fcm = FirebaseMessaging();

  // _saveDeviceToken() async {
  // try {
  //   final user = await FirebaseAuth.instance.currentUser();
  //   final token = await _fcm.getToken();
  //   if (token != null)
  //     Firestore.instance.collection('tokens').document(user.uid).setData({
  //       'createdAt': FieldValue.serverTimestamp(),
  //       'deviceToken': token,
  //       'platform': Platform.operatingSystem,
  //       'user': user.uid,
  //       'type': 'scout',
  //     });
  // } catch (error) {
  //   throw error;
  // }
  // }

  @override
  initState() {
    // _saveDeviceToken();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message);
      },
      // onBackgroundMessage: (Map<String, dynamic> message) async {
      //   print(message);
      // },
      onLaunch: (Map<String, dynamic> message) async {
        print(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print(message);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(create: (context) => CitiesProvider()),
        ChangeNotifierProvider(create: (context) => SpaceProvider()),
        ChangeNotifierProvider(create: (context) => RequestProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider()),
      ],
      child: MaterialApp(
        title: 'Enclave Scout',
        home: UserManagement().handleAuth(),
        initialRoute: '/',
        routes: routes,
        theme: ThemeData(
          primarySwatch: customThemeColor,
          accentColor: Color(0xFF696969),
          fontFamily: 'RobotoCondensed',
          scaffoldBackgroundColor: Colors.white,
        ),
      ),
    );
  }
}
