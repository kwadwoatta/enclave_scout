import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/intl.dart';

class EventsSearchContainer extends StatefulWidget {
  final Function filterFunction;
  final Function searchFunction;

  const EventsSearchContainer({
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

  pickDate() {
    showDatePicker(
      context: context,
      initialDate: _pickedDate == null ? DateTime.now() : _pickedDate,
      firstDate: DateTime(2019),
      lastDate: DateTime(2020),
    ).then((date) {
      setState(() => _pickedDate = date);
    });
  }

  pickCapacity({@required primaryColor}) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 1, end: 10000),
          NumberPickerColumn(begin: 1, end: 10000),
        ]),
        delimiter: [
          PickerDelimiter(
              child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        hideHeader: true,
        title: Text(
          "Please select capacity range",
          style: TextStyle(
            color: primaryColor,
          ),
        ),
        onConfirm: (Picker picker, List value) {
          // print('================================');
          // print(value.toString());
          // print(picker.getSelectedValues());
          setState(() {
            minCapacity = picker.getSelectedValues()[0];
            maxCapacity = picker.getSelectedValues()[1];
          });
        }).showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height * .14,
      padding: EdgeInsets.only(
        left: 10,
        top: screenSize.height * .01,
        bottom: screenSize.height * .01,
      ),
      color: Color(0xFFf6f6f6),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: screenSize.width * .03),
                height: screenSize.height * .055,
                width: screenSize.width * .8,
                child: TextField(
                  cursorColor: primaryColor,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFf1f0ee)),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    // disabledBorder: OutlineInputBorder(
                    //     borderSide: BorderSide(color: Colors.white)),
                    contentPadding: EdgeInsets.only(top: 25, left: 20),
                    hintText: 'Search upcoming shows, weddings, anniversaries',
                    hintStyle: TextStyle(color: Color(0xFFb8b8b8)),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      gapPadding: 9,
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: FloatingActionButton(
                  heroTag: 'search_event',
                  mini: true,
                  backgroundColor: primaryColor,
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Choose Date',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () => pickDate(),
                      child: Text(
                        _pickedDate != null
                            ? DateFormat.yMMMMd().format(_pickedDate)
                            : 'Today',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: SizedBox(
                    // width: screenSize.width * .03,
                    height: 25,
                    child: VerticalDivider(
                      thickness: 3,
                      color: primaryColor,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'City',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () => pickCapacity(primaryColor: primaryColor),
                      child: Text(
                        minCapacity != null && maxCapacity != null
                            ? '${NumberFormat('###,###', 'en_US').format(minCapacity)} Per - ${NumberFormat('###,###', 'en_US').format(maxCapacity)} Pers'
                            : '1 Per - 10,000 Pers',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
