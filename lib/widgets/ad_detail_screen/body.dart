import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scout/models/event.dart';

import '../../custom_icons/custom_icons.dart';
import '../../widgets/ad_detail_screen/sub_widgets/floating_container.dart';

class Body extends StatefulWidget {
  final Event event;
  Body({@required this.event});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // List<String> _items = [
  //   'https://pbs.twimg.com/media/EE9sDOiWkAAc0qn.jpg',
  //   'https://pbs.twimg.com/media/EFy1jGkWoAEwhav.jpg',
  //   'https://pbs.twimg.com/media/D-tFLafXYAAumg4.jpg',
  //   'https://pbs.twimg.com/media/D-tFLacXkAMGR3E.jpg',
  //   'https://culartblog.files.wordpress.com/2015/08/poets1.jpg',
  //   'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
  // ];
  bool readMode = true;
  bool imageLoaded = false;
  bool imageFailed = false;
  // bool dialogShown = false;

  toggleDetailsVisibility() {
    setState(() => readMode = !readMode);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;
    final event = widget.event;

    // if (!dialogShown)
    //   Future.delayed(Duration(seconds: 3), () {
    //     setState(() => dialogShown = true);
    //     showAlertDialog(
    //       context: context,
    //       message:
    //           "You can zoom in or out and slide left or right through images",
    //       type: "success",
    //     );
    //   });

    return Container(
      height: screenSize.height,
      width: screenSize.width,
      child: Stack(
        children: <Widget>[
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            itemCount: event.flyers.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: AdvancedNetworkImage(
                  event.flyers[index],
                  loadedCallback: () {
                    setState(() => imageLoaded = true);
                  },
                  loadFailedCallback: () {
                    setState(() => imageFailed = true);
                  },
                  loadingProgress: (double progress, dataInInt) {
                    // print('Now Loading: $progress');
                  },
                  retryDuration: Duration(seconds: 2),
                  useDiskCache: true,
                ),
                // NetworkImage(event.flyers[index]),
                heroAttributes: PhotoViewHeroAttributes(tag: event.coverPhoto),
                initialScale: PhotoViewComputedScale.contained * 2.2,
              );
            },
            backgroundDecoration: BoxDecoration(color: primaryColor),
            gaplessPlayback: true,
            scrollDirection: Axis.horizontal,
          ),
          //
          AnimatedPositioned(
            duration: Duration(milliseconds: 2000),
            curve: Curves.elasticInOut,
            top: readMode ? screenSize.height * .4 : screenSize.height,
            left: screenSize.width * .05,
            right: screenSize.width * .05,
            child: FloatingContainer(event: event),
          ),
          Positioned(
            top: screenSize.height * .05,
            left: screenSize.width * .02,
            child: FloatingActionButton(
              heroTag: 'btn1',
              mini: true,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_back,
                color: primaryColor,
                size: 25,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            bottom: screenSize.height * .05,
            right: screenSize.width * .02,
            child: FloatingActionButton(
              heroTag: 'btn2',
              backgroundColor: Colors.white.withOpacity(0.9),
              child: Icon(
                readMode ? CustomIcons.eye : CustomIcons.reading,
                color: primaryColor,
                size: 30,
              ),
              onPressed: toggleDetailsVisibility,
            ),
          )
        ],
      ),
    );
  }
}
