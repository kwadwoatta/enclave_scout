import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CapacityDialog {
  final BuildContext context;
  final Function filterFunction;

  CapacityDialog({
    @required this.context,
    @required this.filterFunction,
  }) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController minCapacity = TextEditingController();
    TextEditingController maxCapacity = TextEditingController();

    _maxCapValidator(String val) {
      if (val.trim().length == 0) return 'Enter a maximum capacity';
      if (int.tryParse(val) == null) return 'Enter a valid number';
      return null;
    }

    _minCapValidator(String val) {
      if (val.trim().length == 0) return 'Enter a minimum capacity';
      if (int.tryParse(val) == null) return 'Enter a valid number';
      return null;
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) {
        final height = MediaQuery.of(context).size.height;
        final width = MediaQuery.of(context).size.width;
        final primaryColor = Theme.of(context).primaryColor;

        return StatefulBuilder(
          builder: ((context, setState) {
            _sendRequest() {
              if (!formKey.currentState.validate()) return;
              formKey.currentState.save();
              Navigator.of(context).pop();
              filterFunction(
                minCap: int.parse(minCapacity.text),
                maxCap: int.parse(maxCapacity.text),
              );
            }

            return Dialog(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    left: width * .05,
                    right: width * .05,
                    top: height * .02,
                  ),
                  height: height * .21,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Text('Minimum Capacity: '),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    height: height * .05,
                                    child: TextFormField(
                                      cursorColor: primaryColor,
                                      keyboardType: TextInputType.number,
                                      controller: minCapacity,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(7),
                                      ],
                                      style: TextStyle(
                                        fontSize: width * .05,
                                        color: primaryColor,
                                      ),
                                      validator: (val) => _minCapValidator(val),
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(fontSize: 10),
                                        fillColor: Colors.white,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: primaryColor),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * .02),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Text('Maximum Capacity: '),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    height: height * .05,
                                    child: TextFormField(
                                      cursorColor: primaryColor,
                                      keyboardType: TextInputType.number,
                                      controller: maxCapacity,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(7),
                                      ],
                                      style: TextStyle(
                                        fontSize: width * .05,
                                        color: primaryColor,
                                      ),
                                      validator: (val) => _maxCapValidator(val),
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(fontSize: 10),
                                        fillColor: Colors.white,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: primaryColor),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: height * .01,
                          top: height * .03,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text(
                                'CANCEL',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: width * 0.05,
                                ),
                              ),
                            ),
                            SizedBox(width: width * .1),
                            InkWell(
                              onTap: _sendRequest,
                              child: Text(
                                'SEARCH',
                                style: TextStyle(
                                  fontSize: width * 0.05,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
