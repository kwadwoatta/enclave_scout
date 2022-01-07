import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';

class RequestFormDialog {
  BuildContext context;
  DateTime pickedDate;
  int numberOfHours;
  TextEditingController capacity;
  Function capacityValidator;
  Function showConfirmDialog;
  GlobalKey<FormState> formKey;

  RequestFormDialog({
    @required this.context,
    @required this.capacity,
    @required this.capacityValidator,
    @required this.numberOfHours,
    @required this.pickedDate,
    @required this.showConfirmDialog,
    @required this.formKey,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) {
        final height = MediaQuery.of(context).size.height;
        final width = MediaQuery.of(context).size.width;
        final primaryColor = Theme.of(context).primaryColor;

        return StatefulBuilder(
          builder: ((context, setState) {
            _pickTime() {
              DatePicker.showDateTimePicker(
                context,
                showTitleActions: true,
                minTime: DateTime.now(),
                maxTime: DateTime(2021, 1, 1),
                onChanged: (date) {
                  setState(() => pickedDate = date);
                  print('change $date');
                },
                onConfirm: (date) {
                  setState(() => pickedDate = date);
                  print('confirm $date');
                },
                currentTime: DateTime.now(),
                locale: LocaleType.en,
              );
            }

            _pickNumberOfHours() {
              Picker(
                  adapter: NumberPickerAdapter(data: [
                    NumberPickerColumn(begin: 1, end: 24),
                  ]),
                  hideHeader: true,
                  title: Text(
                    "Select number of hours",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: width * .05,
                    ),
                  ),
                  onConfirm: (Picker picker, List value) {
                    setState(
                      () =>
                          numberOfHours = picker.getSelectedValues()[0] as int,
                    );
                  }).showDialog(context);
            }

            _sendRequest() {
              if (!formKey.currentState.validate()) return;
              formKey.currentState.save();
              showConfirmDialog(
                context: context,
                date: pickedDate,
                hours: numberOfHours,
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
                  height: height * .33,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'REQUEST FOR SPACE',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                            fontSize: width * .055,
                          ),
                        ),
                      ),
                      SizedBox(height: height * .025),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Pick Date: ',
                            style: TextStyle(fontSize: width * .042),
                          ),
                          InkWell(
                            onTap: _pickTime,
                            child: Text(
                              DateFormat.yMMMMEEEEd().format(pickedDate),
                              style: TextStyle(
                                fontSize: width * .044,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * .025),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Scheduled Time: ',
                            style: TextStyle(fontSize: width * .042),
                          ),
                          Text(
                            DateFormat.Hm().format(pickedDate),
                            style: TextStyle(
                              fontSize: width * .044,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * .025),
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
                              child: Form(
                                key: formKey,
                                child: TextFormField(
                                  cursorColor: primaryColor,
                                  keyboardType: TextInputType.number,
                                  controller: capacity,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(7),
                                  ],
                                  style: TextStyle(
                                    fontSize: width * .05,
                                    color: primaryColor,
                                  ),
                                  validator: (val) => capacityValidator(val),
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
                          ),
                        ],
                      ),
                      SizedBox(height: height * .025),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Number of Hours: ',
                            style: TextStyle(
                              fontSize: width * .042,
                            ),
                          ),
                          InkWell(
                            onTap: _pickNumberOfHours,
                            child: Text(
                              numberOfHours != null
                                  ? '$numberOfHours ${numberOfHours > 1 ? "Hours" : "Hour"}'
                                  : 'NOT SPECIFIED',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: width * .044,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * .025),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: height * .01,
                          top: height * .01,
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
                              onTap: numberOfHours == null
                                  ? null
                                  : () {
                                      _sendRequest();
                                    },
                              child: Text(
                                'REQUEST',
                                style: TextStyle(
                                  fontSize: width * 0.05,
                                  // fontWeight: FontWeight.bold,
                                  color: numberOfHours == null
                                      ? Colors.grey
                                      : primaryColor,
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
