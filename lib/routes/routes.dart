import 'package:flutter/material.dart';

import 'package:scout/screens/about_screen.dart';
import 'package:scout/screens/add_event_screen.dart';
import 'package:scout/screens/add_space_screen.dart';
import 'package:scout/screens/complete_space_payment_screen.dart';
import 'package:scout/screens/confirm_ad_form_screen.dart';
import 'package:scout/screens/confirm_space_form_screen.dart';
import 'package:scout/screens/no_connection_screen.dart';
import 'package:scout/screens/payments_screen.dart';
import 'package:scout/screens/requests_screen.dart';
import 'package:scout/screens/search_spaces_screen.dart';
import 'package:scout/screens/space_details_screen.dart';
import 'package:scout/screens/waiting_connection_screen.dart';
import '../screens/ad_details_screen.dart';
import '../screens/city_spaces_screen.dart';
import '../screens/events_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  SignupScreen.routeName: (context) => SignupScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  EventsScreen.routeName: (context) => EventsScreen(),
  SettingsScreen.routeName: (context) => SettingsScreen(),
  CitySpacesScreen.routeName: (context) => CitySpacesScreen(),
  AdDetailScreen.routeName: (context) => AdDetailScreen(),
  SearchSpacesScreen.routeName: (context) => SearchSpacesScreen(),
  AddSpaceScreen.routeName: (context) => AddSpaceScreen(),
  AddEventScreen.routeName: (context) => AddEventScreen(),
  AboutScreen.routeName: (context) => AboutScreen(),
  ConfirmSpaceFormScreen.routeName: (context) => ConfirmSpaceFormScreen(),
  ConfirmAdFormScreen.routeName: (context) => ConfirmAdFormScreen(),
  SpaceDetailsScreen.routeName: (context) => SpaceDetailsScreen(),
  RequestsScreen.routeName: (context) => RequestsScreen(),
  WaitingConnectionScreen.routeName: (context) => WaitingConnectionScreen(),
  NoConnectionScreen.routeName: (context) => NoConnectionScreen(),
  PaymentsScreen.routeName: (context) => PaymentsScreen(),
  CompleteSpacePaymentScreen.routeName: (context) =>
      CompleteSpacePaymentScreen(),
};
