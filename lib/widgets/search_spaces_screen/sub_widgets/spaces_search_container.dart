import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scout/widgets/search_spaces_screen/sub_widgets/capacity_dialog.dart';

class EventsSearchContainer extends StatefulWidget {
  final Function filterFunction;
  final Function searchFunction;

  EventsSearchContainer({
    @required this.filterFunction,
    @required this.searchFunction,
  });

  @override
  _EventsSearchContainerState createState() => _EventsSearchContainerState();
}

class _EventsSearchContainerState extends State<EventsSearchContainer> {
  DateTime _pickedDate;
  int minCapacity;
  int maxCapacity;

  pickCapacity() {
    CapacityDialog(context: context, filterFunction: widget.filterFunction);
  }

  searchSpace(String searchPhrase) {
    widget.searchFunction(spaceName: searchPhrase);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    // final accentColor = Theme.of(context).accentColor;
    final screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height * .14,
      padding: EdgeInsets.only(
        left: 10,
        top: screenSize.height * .01,
        bottom: screenSize.height * .01,
      ),
      color: Color(0xFFFFFFFF),
      // color: Color(0xFFf6f6f6),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Expanded(
                flex: 9,
                child: Container(
                  padding: EdgeInsets.only(
                    left: screenSize.width * .03,
                    right: screenSize.width * .03,
                  ),
                  height: screenSize.height * .055,
                  width: screenSize.width * .8,
                  child: TextField(
                    onSubmitted: (searchPhrase) => searchPhrase.trim() == ''
                        ? null
                        : searchSpace(searchPhrase),
                    cursorColor: primaryColor,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        color: primaryColor,
                      ),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFf1f0ee)),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      // disabledBorder: OutlineInputBorder(
                      //     borderSide: BorderSide(color: Colors.white)),
                      contentPadding: EdgeInsets.only(top: 25, left: 20),
                      hintText: 'Try Accra, Kumasi',
                      hintStyle: TextStyle(color: Color(0xFFb8b8b8)),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        gapPadding: 9,
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   flex: 2,
              //   child: FloatingActionButton(
              //     heroTag: 'search_event',
              //     mini: true,
              //     backgroundColor: primaryColor,
              //     child: Icon(
              //       Icons.search,
              //       color: Colors.white,
              //     ),
              //     onPressed: () {},
              //   ),
              // ),
            ],
          ),

          //
          Padding(
            padding: EdgeInsets.only(
              right: screenSize.width * .1,
              left: screenSize.width * .03,
              top: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Choose City',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      SizedBox(height: 3),
                      GestureDetector(
                        // onTap: () => pickDate(),
                        child: Text(
                          _pickedDate != null
                              ? DateFormat.yMMMMd().format(_pickedDate)
                              : 'All Cities',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    // width: screenSize.width * .03,
                    height: 28,
                    child: VerticalDivider(
                      thickness: 3,
                      color: primaryColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Choose Capacity Range',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      SizedBox(height: 3),
                      GestureDetector(
                        onTap: () => pickCapacity(),
                        child: Text(
                          minCapacity != null && maxCapacity != null
                              ? '${NumberFormat('###,###', 'en_US').format(minCapacity)} Per - ${NumberFormat('###,###', 'en_US').format(maxCapacity)} Pers'
                              : '1 Per - 1,000,000 Pers',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
