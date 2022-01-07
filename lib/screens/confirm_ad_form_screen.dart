import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout/custom_icons/custom_icons.dart';
import 'package:scout/models/event.dart';
import 'package:scout/providers/events.dart';
import 'package:scout/widgets/show_error_dialog.dart';

class ConfirmAdFormScreen extends StatefulWidget {
  static const routeName = "/confirm-ad-form";
  final Event event;
  final List<File> images;

  ConfirmAdFormScreen({
    this.event,
    this.images,
  });

  @override
  _ConfirmAdFormScreenState createState() => _ConfirmAdFormScreenState();
}

class _ConfirmAdFormScreenState extends State<ConfirmAdFormScreen> {
  EventProvider _eventProvider;
  bool pageInit = true;
  bool postingEvent = false;

  @override
  void didChangeDependencies() {
    if (pageInit) {
      _eventProvider = Provider.of<EventProvider>(context, listen: false);
      super.didChangeDependencies();
      pageInit = false;
    }
  }

  _uploadEvent() async {
    try {
      setState(() => postingEvent = true);
      ShowProgressDialog(context: context, isDone: false);
      await _eventProvider.uploadevent(
        event: widget.event,
        imageFiles: widget.images,
      );
      setState(() => postingEvent = false);
      Navigator.of(context).pop();
      ShowProgressDialog(context: context, isDone: true);
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, '/events-screen');
    } catch (error) {
      Navigator.of(context).pop();
      ErrorDialog(context: context, error: error).showError();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    // final accentColor = Theme.of(context).accentColor;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          'Confirm Form',
          style: TextStyle(color: primaryColor),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 5,
        child: Icon(
          CustomIcons.checked,
          color: Colors.green,
        ),
        onPressed: _uploadEvent,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: GridView(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 2 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              children: <Widget>[
                ...widget.images.map((image) {
                  return Image.file(image);
                }).toList(),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text('Event expiration'),
                  subtitle: Text(
                    'Advertisment will expire after a week of posting.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ListTile(
                  title: Text('Event Name'),
                  subtitle: Text(widget.event.adName),
                ),
                ListTile(
                  title: Text('Description'),
                  subtitle: Text(widget.event.description),
                ),
                ListTile(
                  title: Text('City'),
                  subtitle: Text(widget.event.city),
                ),
                ListTile(
                  title: Text('Address'),
                  subtitle: Text(widget.event.address),
                ),
                ListTile(
                  title: Text('Price'),
                  subtitle: Text(widget.event.price.toString()),
                ),
                ListTile(
                  title: Text('Phone Number'),
                  subtitle: Text(widget.event.phoneNumber),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShowProgressDialog {
  ShowProgressDialog({BuildContext context, bool isDone}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) {
        final height = MediaQuery.of(context).size.height;
        final width = MediaQuery.of(context).size.width;

        return StatefulBuilder(
          builder: ((context, setState) {
            return Dialog(
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 5, top: 10),
                height: height * .2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      !isDone
                          ? CircularProgressIndicator()
                          : Icon(
                              CustomIcons.checked,
                              color: Colors.green,
                            ),
                      SizedBox(height: height * .02),
                      !isDone
                          ? Text(
                              'Uploading ...',
                              style: TextStyle(fontSize: width * .05),
                            )
                          : Text('Upload successful.'),
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
