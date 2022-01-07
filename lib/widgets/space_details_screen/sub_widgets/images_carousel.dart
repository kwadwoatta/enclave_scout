import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class ImagesCarousel extends StatefulWidget {
  final List<String> images;
  ImagesCarousel({@required this.images});

  @override
  _ImagesCarouselState createState() => _ImagesCarouselState();
}

class _ImagesCarouselState extends State<ImagesCarousel> {
  bool imageLoaded = false;
  bool imageFailed = false;
  Function reloadFunction;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final primaryColor = Theme.of(context).primaryColor;

    return CarouselSlider(
      items: <Widget>[
        ...widget.images.map((imageUrl) {
          return Container(
            color: Colors.white,
            // height: height * .4,
            width: width,
            child: TransitionToImage(
              image: AdvancedNetworkImage(
                imageUrl,
                loadedCallback: () {
                  setState(() => imageLoaded = true);
                },
                loadFailedCallback: () {
                  setState(() => imageFailed = true);
                },
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
              width: width,
              enableRefresh: true,
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
      // enlargeCenterPage: true,
      // onPageChanged: (int) {

      // },
    );
  }
}
