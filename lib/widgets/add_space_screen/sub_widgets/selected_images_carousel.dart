import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImagesCarousel extends StatelessWidget {
  final List<File> imageFiles;
  final double height;

  ImagesCarousel({
    @required this.imageFiles,
    @required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return CarouselSlider(
      items: <Widget>[
        ...imageFiles.map((imageFile) {
          return Container(
            color: Colors.white,
            width: screenSize.width,
            child: FadeInImage(
              image: FileImage(
                imageFile,
              ),
              placeholder: AssetImage('assets/images/loading.gif'),
              fit: BoxFit.contain,
            ),
          );
        }).toList()
      ],
      height: height,
      enableInfiniteScroll: true,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 2),
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      pauseAutoPlayOnTouch: Duration(seconds: 10),
      viewportFraction: 1.0,
    );
  }
}
