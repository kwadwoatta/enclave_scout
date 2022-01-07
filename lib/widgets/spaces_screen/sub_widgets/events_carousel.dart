import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:scout/models/event.dart';
import 'package:scout/screens/ad_details_screen.dart';

class EventsCarousel extends StatefulWidget {
  final List<Event> events;
  EventsCarousel({@required this.events});

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
    final accentColor = Theme.of(context).accentColor;

    return CarouselSlider(
      items: <Widget>[
        ...widget.events.map((event) {
          return GestureDetector(
            onTap: imageLoaded
                ? () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AdDetailScreen(
                          event: event,
                        ),
                      ),
                    )
                : imageFailed ? reloadFunction : null,
            child: Container(
              color: accentColor,
              height: height * .5,
              width: width,
              child: Hero(
                tag: event.coverPhoto,
                child: TransitionToImage(
                  image: AdvancedNetworkImage(
                    event.coverPhoto,
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
              ),
            ),
          );
        }).toList()
      ],
      height: height * .5,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 5),
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      pauseAutoPlayOnTouch: Duration(seconds: 10),
      viewportFraction: 1.0,
      enlargeCenterPage: true,
      // onPageChanged: (int) {

      // },
    );
  }
}
