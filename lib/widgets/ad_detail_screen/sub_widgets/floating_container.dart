import 'package:flutter/material.dart';
import 'package:scout/models/event.dart';

class FloatingContainer extends StatelessWidget {
  final Event event;
  FloatingContainer({@required this.event});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      height: height * .37,
      width: width * .9,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Text(
                event.adName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * .085,
                ),
              ),
            ),
          ),
          // row 2
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: height * .01),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Address Column
                  Expanded(
                    flex: 7,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${event.address}, ${event.city}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: width * .04,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Rating row
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

                  // Price Column
                  Expanded(
                    flex: 3,
                    child: Text(
                      '¢ ${event.price}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width * .055,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Description
          Expanded(
            flex: 4,
            child: ListView(
              children: <Widget>[
                Text(
                  event.description,
                  style: TextStyle(color: Colors.grey, fontSize: width * .04),
                )
              ],
            ),
          ),

// Button Row
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: height * .055,
                  width: width * .7,
                  child: RaisedButton(
                    color: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      'Contact advertiser',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: <Widget>[
//             Expanded(
//               flex: 3,
//               child: Row(
//                 children: <Widget>[
//                   // Info Column
//                   Expanded(
//                     flex: 4,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: <Widget>[
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Container(
//                                   width: width * .6,
//                                   child: Text(
//                                     event.adName,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: width * .09,
//                                     ),
//                                   ),
//                                 ),
//                                 Text(
//                                   '${event.address}, ${event.city}',
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: width * .04,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         // Rating row
//                         Row(
//                           children: <Widget>[
//                             Icon(
//                               Icons.star_border,
//                               size: 17,
//                               color: primaryColor,
//                             ),
//                             Icon(
//                               Icons.star_border,
//                               size: 17,
//                               color: primaryColor,
//                             ),
//                             Icon(
//                               Icons.star_border,
//                               size: 17,
//                               color: primaryColor,
//                             ),
//                             Icon(
//                               Icons.star_border,
//                               size: 17,
//                               color: primaryColor,
//                             ),
//                             Icon(
//                               Icons.star_border,
//                               size: 17,
//                               color: primaryColor,
//                             ),
//                           ],
//                         ),
//                         Container(
//                           height: height * .2,
//                           child: ListView(
//                             children: <Widget>[
//                               Text(
//                                 event.description,
//                                 style: TextStyle(
//                                     color: Colors.grey, fontSize: width * .04),
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),

//                   // Price Column
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           '¢ ${event.price}',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: width * .055,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

// // Button Row
//             Expanded(
//               flex: 2,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   SizedBox(
//                     height: height * .055,
//                     width: width * .7,
//                     child: RaisedButton(
//                       color: primaryColor,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20)),
//                       child: Text(
//                         'Contact advertiser',
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                       onPressed: () {},
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
