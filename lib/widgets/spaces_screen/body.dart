import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout/models/event.dart';
import 'package:scout/providers/events.dart';
import 'package:scout/widgets/show_error_dialog.dart';

import '../../widgets/spaces_screen/sub_widgets/avatar.dart';
import '../../widgets/spaces_screen/sub_widgets/regional_cards.dart';

import './sub_widgets/events_carousel.dart';
import './sub_widgets/floating_search_container.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isInit = true;

  didChangeDependencies() {
    if (isInit) {
      Provider.of<EventProvider>(context).retreiveAllevents();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final primaryColor = Theme.of(context).primaryColor;
    final Stream<List<Event>> events =
        Provider.of<EventProvider>(context).events;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: height * .659,
          width: width,
          child: Stack(
            children: <Widget>[
              StreamBuilder(
                stream: events,
                builder: ((context, AsyncSnapshot<List<Event>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Container(
                      height: height * .5,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: primaryColor,
                        ),
                      ),
                    );
                  else if (snapshot.hasData) {
                    final events = snapshot.data;
                    return EventsCarousel(
                      events: events,
                    );
                  } else if (!snapshot.hasData) {
                    return Container(
                      height: height * .5,
                      child: Center(
                        child: Text(
                          'Oops, no event space found.',
                          style: TextStyle(
                            fontSize: width * .05,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    ErrorDialog(context: context, error: snapshot.error);
                    return Container(
                      height: height * .5,
                      child: Center(
                        child: Text(
                          'Oops, an error occured.',
                          style: TextStyle(
                            fontSize: width * .05,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  } else
                    return Container(
                      height: height * .5,
                      child: Center(
                        child: Text(
                          'Oops, no events found.',
                          style: TextStyle(
                            fontSize: width * .05,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                }),
              ),
              Avatar(),
              FloatingSearchContainer(),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              'Cities',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        RegionalCards(),
      ],
    );
  }
}
