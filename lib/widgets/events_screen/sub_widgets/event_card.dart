import 'package:flutter/material.dart';
import 'package:scout/models/event.dart';
import 'package:scout/screens/ad_details_screen.dart';

import 'events_carousel.dart';

class EventCard extends StatelessWidget {
  final Event event;

  EventCard({
    @required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AdDetailScreen(
            event: event,
          ),
        ),
      ),
      child: Container(
        width: screenSize.width,
        height: screenSize.height * .37,
        child: Stack(
          children: <Widget>[
            GridTile(
              child: EventsCarousel(
                items: event.flyers,
              ),
              footer: Container(
                // color: Color(0xFFf1f0ee),
                color: Colors.white,
                height: screenSize.height * .1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  event.adName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenSize.width * .06,
                                  ),
                                ),
                                Text(
                                  '${event.address}, ${event.city}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.star_border,
                                  size: 17,
                                  color: primaryColor,
                                ),
                                Icon(
                                  Icons.star_border,
                                  size: 17,
                                  color: primaryColor,
                                ),
                                Icon(
                                  Icons.star_border,
                                  size: 17,
                                  color: primaryColor,
                                ),
                                Icon(
                                  Icons.star_border,
                                  size: 17,
                                  color: primaryColor,
                                ),
                                Icon(
                                  Icons.star_border,
                                  size: 17,
                                  color: primaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '¢ ${event.price}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenSize.width * .05,
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 35,
                              width: 80,
                              child: RaisedButton(
                                color: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  'Contact',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              child: FloatingActionButton(
                heroTag: event.advertistmentId,
                backgroundColor: Colors.white,
                mini: true,
                elevation: 0,
                onPressed: () => {},
                child: Icon(
                  Icons.favorite_border,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
