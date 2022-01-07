import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';

class FloatingSearchContainer extends StatefulWidget {
  @override
  _FloatingSearchContainerState createState() =>
      _FloatingSearchContainerState();
}

class _FloatingSearchContainerState extends State<FloatingSearchContainer> {
  DateTime _pickedDate;
  int minCapacity;
  int maxCapacity;
  TextEditingController searchController = TextEditingController();

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
    final screenSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;

    return Positioned(
      top: screenSize.height * .4,
      left: screenSize.width * .05,
      right: screenSize.width * .05,
      child: Container(
        height: screenSize.height * .25,
        width: screenSize.width * .9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.93),
          // color: Color(0xFFf1f0ee).withOpacity(.99),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.8),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FractionallySizedBox(
                widthFactor: .9,
                child: SizedBox(
                  height: 45,
                  child: TextField(
                    controller: searchController,
                    cursorColor: primaryColor,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFf1f0ee)),
                          borderRadius: BorderRadius.circular(40)),
                      // disabledBorder: OutlineInputBorder(
                      //     borderSide: BorderSide(color: Colors.white)),
                      contentPadding: EdgeInsets.only(bottom: 1),
                      prefixIcon: Icon(
                        Icons.search,
                        color: primaryColor,
                      ),
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
              Expanded(
                child: FractionallySizedBox(
                  widthFactor: .90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: screenSize.height * .08,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Choose Date',
                                style: TextStyle(color: Colors.grey),
                              ),
                              GestureDetector(
                                onTap: () => pickDate(),
                                child: Text(
                                  _pickedDate != null
                                      ? DateFormat.yMMMMd().format(_pickedDate)
                                      : 'Today',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          // width: screenSize.width * .01,
                          height: screenSize.height * 0.05,
                          child: VerticalDivider(
                            thickness: 3,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          height: screenSize.height * .08,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Capacity',
                                style: TextStyle(color: Colors.grey),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    pickCapacity(primaryColor: primaryColor),
                                child: Text(
                                  minCapacity != null && maxCapacity != null
                                      ? '${NumberFormat('###,###', 'en_US').format(minCapacity)} Per - ${NumberFormat('###,###', 'en_US').format(maxCapacity)} Pers'
                                      : '1 Per - 10,000 Pers',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Flexible(child: FractionallySizedBox(heightFactor: .00)),
              FractionallySizedBox(
                widthFactor: .9,
                child: SizedBox(
                  height: 50,
                  child: RaisedButton(
                    elevation: 3,
                    child: Text(
                      searchController.text.trim() == ''
                          ? 'View All Spaces'
                          : 'Search Space',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    color: primaryColor,
                    onPressed: () => Navigator.of(context)
                        .pushNamed('/search-spaces-screen'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
