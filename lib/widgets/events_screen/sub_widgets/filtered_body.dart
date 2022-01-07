import 'package:flutter/material.dart';
import 'package:scout/models/event.dart';
import 'package:scout/widgets/events_screen/sub_widgets/event_card.dart';
import 'package:scout/widgets/show_error_dialog.dart';

List<Widget> filteredBody({
  @required BuildContext context,
  @required Stream<int> eventsLength,
  @required Stream<List<Event>> events,
}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  final primaryColor = Theme.of(context).primaryColor;

  return [
    Expanded(
      child: StreamBuilder(
        stream: events,
        builder: ((context, AsyncSnapshot<List<Event>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: primaryColor,
              ),
            );
          else if (snapshot.hasData) {
            final events = snapshot.data;
            return ListView(
              children: events.map((event) {
                return EventCard(
                  event: event,
                );
              }).toList(),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Oops, no event space found.',
                style: TextStyle(
                  fontSize: width * .05,
                  color: Colors.white,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            ErrorDialog(context: context, error: snapshot.error);
            return Center(
              child: Text(
                'Oops, an error occured.',
                style: TextStyle(
                  fontSize: width * .05,
                  color: Colors.white,
                ),
              ),
            );
          } else
            return Center(
              child: Text(
                'Oops, no events found.',
                style: TextStyle(
                  fontSize: width * .05,
                  color: Colors.white,
                ),
              ),
            );
        }),
      ),
    ),
  ];
}
