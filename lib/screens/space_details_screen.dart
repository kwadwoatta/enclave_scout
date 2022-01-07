import 'package:flutter/material.dart';
import 'package:scout/models/space.dart';
import 'package:scout/widgets/space_details_screen/space_details.dart';

class SpaceDetailsScreen extends StatelessWidget {
  static const routeName = '/space-details';

  final Space space;
  SpaceDetailsScreen({@required this.space});

  @override
  Widget build(BuildContext context) {
    return SpaceDetails(space: space);
  }
}
