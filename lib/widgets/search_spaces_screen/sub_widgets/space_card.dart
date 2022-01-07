import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:scout/custom_icons/custom_icons.dart';
import 'package:scout/models/space.dart';
import 'package:scout/screens/space_details_screen.dart';

import 'attribute_chip.dart';
import 'spaces_carousel.dart';

class SpaceCard extends StatelessWidget {
  final Space space;

  SpaceCard({
    @required this.space,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SpaceDetailsScreen(
            space: space,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.only(
          left: width * .02,
          right: width * .02,
          bottom: height * .01,
        ),
        height: height * .33,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Stack(
            children: <Widget>[
              GridTile(
                child: EventsCarousel(
                  items: space.venueImages,
                ),
                footer: Container(
                  // color: Color(0xFFf1f0ee),
                  color: Colors.white,
                  height: height * .114,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 2,
                      bottom: 0,
                      left: 0,
                      right: 0,
                    ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 7,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 7,
                                                child: Text(
                                                  space.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: width * .06,
                                                    fontWeight: FontWeight.w500,
                                                    wordSpacing: 1.5,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: width * .001),
                                              Text(
                                                '¢ ${space.price}/Hour',
                                                style: TextStyle(
                                                  fontSize: width * .045,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Icon(
                                                CustomIcons.house_location,
                                                size: width * .038,
                                              ),
                                              SizedBox(width: width * .03),
                                              Text(
                                                '${space.address}, ${space.city}',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: width * .04,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              AttributeChip(
                                icon: CustomIcons.enterprise,
                                value: space.maxCapacity, //max capacity
                                // value: '1,000,000', //max capacity
                              ),
                              AttributeChip(
                                icon: CustomIcons.toilet_wc,
                                value: space.washroom,
                              ),
                              AttributeChip(
                                icon: CustomIcons.parking,
                                value: space.parkingLot,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: height * .05,
                right: width * .04,
                child: Container(
                  // padding: const EdgeInsets.all(2.0),
                  decoration: new BoxDecoration(
                    // color: const Color(0xFFFFFFFF),
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 3.5,
                      color: const Color(0xFFFFFFFF),
                      // color: primaryColor,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: width * .1,
                    backgroundImage: AdvancedNetworkImage(
                      space.vendorImage,
                      loadedCallback: () {},
                      loadFailedCallback: () {},
                      loadingProgress: (double progress, dataInInt) {},
                      useDiskCache: true,
                    ),
                    backgroundColor: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              // Positioned(
              //   top: 5,
              //   right: 10,
              //   child:
              //       // Icon(
              //       //   CustomIcons.verified,
              //       //   color: verified ?  primaryColor: Colors.grey ,
              //       // )
              //       FloatingActionButton(
              //     heroTag: '${space.name}-favorites-floater',
              //     backgroundColor: Colors.white,
              //     mini: true,
              //     elevation: 0,
              //     onPressed: () => {},
              //     child: Icon(
              //       CustomIcons.verified,
              //       // color: primaryColor,
              //       color: space.verified ? primaryColor : Colors.red,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
