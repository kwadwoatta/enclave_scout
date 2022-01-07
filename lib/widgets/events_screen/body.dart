import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout/custom_icons/custom_icons.dart';
import 'package:scout/providers/events.dart';
import 'package:scout/widgets/events_screen/sub_widgets/default_body.dart';
import 'package:scout/widgets/events_screen/sub_widgets/filtered_body.dart';
import 'package:scout/widgets/events_screen/sub_widgets/searched_body.dart';

import './sub_widgets/events_search_container.dart';

// class Bod extends StatefulWidget {
//   @override
//   _BodState createState() => _BodState();
// }

// class _BodState extends State<Bod> {
//   static List<String> _items = [
//     'https://pbs.twimg.com/media/EE9sDOiWkAAc0qn.jpg',
//     'https://pbs.twimg.com/media/EFy1jGkWoAEwhav.jpg',
//     'https://pbs.twimg.com/media/D-tFLafXYAAumg4.jpg',
//     'https://pbs.twimg.com/media/D-tFLacXkAMGR3E.jpg',
//     'https://culartblog.files.wordpress.com/2015/08/poets1.jpg',
//     'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
//   ];

//   List<Event> _events = [
//     Event(
//       advertistmentId: UniqueKey().toString(),
//       advertiserId: UniqueKey().toString(),
//       eventDate: DateTime.now(),
//       adName: 'Seriously Dwoking with Dwomoh',
//       price: 20.00,
//       description: 'Stand up comedy with Dwomoh',
//       coverPhoto: 'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
//       flyers: _items,
//       phoneNumber: '0500000000',
//     ),
//     Event(
//       advertistmentId: UniqueKey().toString(),
//       advertiserId: UniqueKey().toString(),
//       eventDate: DateTime.now(),
//       adName: 'Seriously Dwoking with Dwomoh',
//       price: 20.00,
//       description: 'Stand up comedy with Dwomoh',
//       coverPhoto: 'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
//       flyers: _items,
//       phoneNumber: '0500000000',
//     ),
//     Event(
//       advertistmentId: UniqueKey().toString(),
//       advertiserId: UniqueKey().toString(),
//       eventDate: DateTime.now(),
//       adName: 'Seriously Dwoking with Dwomoh',
//       price: 20.00,
//       description: 'Stand up comedy with Dwomoh',
//       coverPhoto: 'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
//       flyers: _items,
//       phoneNumber: '0500000000',
//     ),
//     Event(
//       advertistmentId: UniqueKey().toString(),
//       advertiserId: UniqueKey().toString(),
//       eventDate: DateTime.now(),
//       adName: 'Seriously Dwoking with Dwomoh',
//       price: 20.00,
//       description: 'Stand up comedy with Dwomoh',
//       coverPhoto: 'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
//       flyers: _items,
//       phoneNumber: '0500000000',
//     ),
//     Event(
//       advertistmentId: UniqueKey().toString(),
//       advertiserId: UniqueKey().toString(),
//       eventDate: DateTime.now(),
//       adName: 'Seriously Dwoking with Dwomoh',
//       price: 20.00,
//       description: 'Stand up comedy with Dwomoh',
//       coverPhoto: 'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
//       flyers: _items,
//       phoneNumber: '0500000000',
//     ),
//     Event(
//       advertistmentId: UniqueKey().toString(),
//       advertiserId: UniqueKey().toString(),
//       eventDate: DateTime.now(),
//       adName: 'Seriously Dwoking with Dwomoh',
//       price: 20.00,
//       description: 'Stand up comedy with Dwomoh',
//       coverPhoto: 'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
//       flyers: _items,
//       phoneNumber: '0500000000',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     // final primaryColor = Theme.of(context).primaryColor;

//     return Container(
//       height: screenSize.height,
//       width: screenSize.width,
//       child: Column(
//         children: <Widget>[
//           EventsSearchContainer(),
//           Container(
//             height: screenSize.height * .68,
//             width: screenSize.width,
//             child: ListView.builder(
//               itemCount: _events.length,
//               itemBuilder: (context, index) {
//                 // return EventCard(
//                 //   images: _events[index].flyers,
//                 //   eventName: _events[index].adName,
//                 //   advertId: _events[index].advertistmentId,
//                 // );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class Body extends StatefulWidget {
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
  bool isInit = true;
  bool filterMode = false;
  bool searchMode = false;

  didChangeDependencies() {
    if (isInit) {
      Provider.of<EventProvider>(context).retreiveAllevents();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  filterFunction({
    @required int maxCap,
    @required int minCap,
  }) {
    Provider.of<EventProvider>(context).filterEvents(
        // date: ,
        );
    setState(() => filterMode = true);
  }

  searchFunction({
    @required String spaceName,
  }) {
    Provider.of<EventProvider>(context).searchEvents(name: spaceName);
    setState(() => searchMode = true);
  }

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    final eventsLength = Provider.of<EventProvider>(context).eventsLength;
    final filteredEvents = Provider.of<EventProvider>(context).filteredEvents;
    final filteredEventsLength =
        Provider.of<EventProvider>(context).filteredEventsLength;
    final searchedEvents = Provider.of<EventProvider>(context).searchedEvents;
    final searchedEventsLength =
        Provider.of<EventProvider>(context).searchedEventsLength;

    // final primaryColor = Theme.of(context).primaryColor;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              EventsSearchContainer(
                filterFunction: filterFunction,
                searchFunction: searchFunction,
              ),
              if (filterMode)
                ...filteredBody(
                  context: context,
                  events: filteredEvents,
                  eventsLength: filteredEventsLength,
                )
              else if (searchMode)
                ...searchedBody(
                  context: context,
                  events: searchedEvents,
                  eventsLength: searchedEventsLength,
                )
              else
                ...defaultBody(
                  context: context,
                  events: events,
                  eventsLength: eventsLength,
                ),
            ],
          ),
          if (filterMode || searchMode)
            Positioned(
              bottom: height * .03,
              right: width * .07,
              child: FloatingActionButton(
                child: Icon(CustomIcons.cancel_search),
                onPressed: () {
                  setState(() {
                    filterMode = false;
                    searchMode = false;
                  });
                },
              ),
            )
        ],
      ),
    );
  }
}
