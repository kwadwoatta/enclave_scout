import 'package:flutter/material.dart';

import './sub_widgets/hero_page.dart';

class CitySpaces extends StatelessWidget {
  final String cityName;
  final String cityImageUrl;

  CitySpaces({
    @required this.cityName,
    @required this.cityImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HeroPage(
        cityName: cityName,
        cityImageUrl: cityImageUrl,
      ),
    );
  }
}
