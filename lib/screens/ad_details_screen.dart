import 'package:flutter/material.dart';
import 'package:scout/models/event.dart';

import '../widgets/ad_detail_screen/ad_detail.dart';

class AdDetailScreen extends StatelessWidget {
  static const routeName = '/ad-detail-screen';

  final Event event;
  AdDetailScreen({@required this.event});

  @override
  Widget build(BuildContext context) {
    return AdDetail(event: event);
  }
}
