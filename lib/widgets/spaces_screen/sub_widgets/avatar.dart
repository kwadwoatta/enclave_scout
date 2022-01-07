import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;

    return Positioned(
      top: screenSize.height * .05,
      right: screenSize.height * .02,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: AdvancedNetworkImage(
          'https://pixel.nymag.com/imgs/daily/vulture/2018/12/04/04-big-mouth.jpg',
          loadedCallback: () {},
          loadFailedCallback: () {},
          loadingProgress: (double progress, dataInInt) {},
          retryLimit: 10,
          retryDuration: Duration(seconds: 3),
          useDiskCache: true,
        ),
      ),
    );
  }
}
