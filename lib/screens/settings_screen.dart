import 'package:flutter/material.dart';

import '../widgets/settings_screen/settings.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = "/settings-screen";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Settings(),
    );
  }
}
