import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class EventsCarousel extends StatelessWidget {
  final List<String> items;
  EventsCarousel({@required this.items});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;

    return CarouselSlider(
      items: <Widget>[
        ...items.map((imageUrl) {
          return Container(
            // color: Colors.white,
            // height: screenSize.height * .4,
            width: screenSize.width,
            child: TransitionToImage(
              image: AdvancedNetworkImage(
                imageUrl,
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
              fit: BoxFit.fill,
              placeholder: const Icon(Icons.refresh),
              enableRefresh: true,
            ),
          );
        }).toList()
      ],
      height: screenSize.height * .4,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 5),
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      pauseAutoPlayOnTouch: Duration(seconds: 10),
      viewportFraction: 1.0,
    );
  }
}
