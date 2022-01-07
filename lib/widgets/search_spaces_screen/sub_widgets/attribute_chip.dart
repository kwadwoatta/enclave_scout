import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttributeChip extends StatelessWidget {
  final int value;
  final IconData icon;

  AttributeChip({
    this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Color(0xFFefeef1),
            // color: Colors.grey,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: height * .01,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: width * .05,
              ),
              SizedBox(width: width * .05),
              Text(
                NumberFormat('#,###', 'en_US').format(value),
                style: TextStyle(
                  fontSize: width * .05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// return GestureDetector(
//   onTap: () => Navigator.of(context).pushNamed(
//     '/ad-detail-screen',
//     arguments: spaceImages[0],
//   ),
//   child: Container(
//     padding: EdgeInsets.all(4),
//     margin: EdgeInsets.only(
//       left: width * .02,
//       right: width * .02,
//       bottom: height * .01,
//     ),
//     // margin: EdgeInsets.all(5),
//     // width: width,
//     height: height * .37,
//     child: Stack(
//       children: <Widget>[
//         ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: GridTile(
//             child: EventsCarousel(
//               items: spaceImages,
//             ),
//             footer: Container(
//               // color: Color(0xFFf1f0ee),
//               color: Colors.white,
//               height: height * .1,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Expanded(
//                       flex: 6,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(
//                                 spaceName,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                               Text(
//                                 '$address, $city',
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: <Widget>[
//                               Icon(
//                                 Icons.star_border,
//                                 size: 17,
//                                 color: primaryColor,
//                               ),
//                               Icon(
//                                 Icons.star_border,
//                                 size: 17,
//                                 color: primaryColor,
//                               ),
//                               Icon(
//                                 Icons.star_border,
//                                 size: 17,
//                                 color: primaryColor,
//                               ),
//                               Icon(
//                                 Icons.star_border,
//                                 size: 17,
//                                 color: primaryColor,
//                               ),
//                               Icon(
//                                 Icons.star_border,
//                                 size: 17,
//                                 color: primaryColor,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       flex: 4,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: <Widget>[
//                           Text(
//                             '¢ $price per Hour',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           Container(
//                             height: 35,
//                             width: 80,
//                             child: RaisedButton(
//                               color: primaryColor,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               child: Text(
//                                 'Details',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                               onPressed: () {},
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           right: 10,
//           child: FloatingActionButton(
//             heroTag: '$spaceName-favorites-floater',
//             backgroundColor: Colors.white,
//             mini: true,
//             elevation: 0,
//             onPressed: () => {},
//             child: Icon(
//               Icons.favorite_border,
//               color: primaryColor,
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// );
