import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class EventsCarousel extends StatefulWidget {
  final List<String> items;
  EventsCarousel({@required this.items});

  @override
  _EventsCarouselState createState() => _EventsCarouselState();
}

class _EventsCarouselState extends State<EventsCarousel> {
  bool imageLoaded = false;
  bool imageFailed = false;
  Function reloadFunction;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final primaryColor = Theme.of(context).primaryColor;
    // final accentColor = Theme.of(context).accentColor;

    return CarouselSlider(
      items: <Widget>[
        ...widget.items.map((imageUrl) {
          return Container(
            color: Colors.white,
            // height: height * .4,
            width: width,
            child: TransitionToImage(
              image: AdvancedNetworkImage(
                imageUrl,
                loadedCallback: () {
                  // print('$imageUrl loaded!');
                  setState(() => imageLoaded = true);
                },
                loadFailedCallback: () {
                  // print('$imageUrl failed!');
                  setState(() => imageFailed = true);
                },
                loadingProgress: (double progress, dataInInt) {
                  // print('Now Loading: $progress');
                },
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
              width: width,
              enableRefresh: true,
            ),
          );
        }).toList()
      ],
      height: height * .4,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 5),
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      pauseAutoPlayOnTouch: Duration(seconds: 10),
      viewportFraction: 1.0,
      // enlargeCenterPage: true,
      // onPageChanged: (int) {

      // },
    );
  }
}
