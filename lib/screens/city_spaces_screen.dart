import 'package:flutter/material.dart';
import 'package:scout/widgets/city_spaces_screen/city_spaces.dart';

class CitySpacesScreen extends StatelessWidget {
  static const routeName = '/city-spaces-screen';

  @override
  Widget build(BuildContext context) {
    final Map<String, String> city = ModalRoute.of(context).settings.arguments;
    return CitySpaces(
      cityImageUrl: city['imageUrl'],
      cityName: city['cityName'],
    );
  }
}
