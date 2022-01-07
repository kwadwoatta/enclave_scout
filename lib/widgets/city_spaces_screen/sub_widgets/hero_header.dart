import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

import './layout_type.dart';

class HeroHeader implements SliverPersistentHeaderDelegate {
  HeroHeader({
    this.layoutGroup,
    this.onLayoutToggle,
    this.minExtent,
    this.maxExtent,
    @required this.cityName,
    @required this.cityImageUrl,
  });

  final String cityName;
  final String cityImageUrl;
  final LayoutGroup layoutGroup;
  final VoidCallback onLayoutToggle;
  double maxExtent;
  double minExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final primaryColor = Theme.of(context).primaryColor;

    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: cityName,
          child: TransitionToImage(
            image: AdvancedNetworkImage(
              cityImageUrl,
              loadedCallback: () {},
              loadFailedCallback: () {},
              loadingProgress: (double progress, dataInInt) {},
              useDiskCache: true,
            ),
            loadingWidgetBuilder: (_, double progress, __) => Center(
              child: CircularProgressIndicator(
                value: progress,
                backgroundColor: Theme.of(context).accentColor,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
            placeholderBuilder: ((_, refresh) {
              return Center(
                child: InkWell(
                  onTap: refresh,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.refresh),
                      Text(
                        'Tap to retry',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            fit: BoxFit.cover,
            placeholder: const Icon(Icons.refresh),
            // width: width,
            enableRefresh: true,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black54,
              ],
              stops: [0.5, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.repeated,
            ),
          ),
        ),
        Positioned(
          left: 4.0,
          top: 4.0,
          child: SafeArea(
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              mini: true,
              heroTag: 'exit',
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        Positioned(
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
          child: Text(
            cityName,
            style: TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  // TODO: implement stretchConfiguration
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;
}
