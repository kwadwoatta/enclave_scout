import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout/custom_icons/custom_icons.dart';
import 'package:scout/models/space.dart';
import 'package:scout/providers/space.dart';
import 'package:scout/widgets/show_error_dialog.dart';

class ConfirmSpaceFormScreen extends StatefulWidget {
  static const routeName = "/confirm-form";
  final Space space;
  final List<File> images;

  ConfirmSpaceFormScreen({
    this.space,
    this.images,
  });

  @override
  _ConfirmSpaceFormScreenState createState() => _ConfirmSpaceFormScreenState();
}

class _ConfirmSpaceFormScreenState extends State<ConfirmSpaceFormScreen> {
  SpaceProvider _spaceProvider;
  bool pageInit = true;
  bool postingSpace = false;
  bool agreed = false;

  @override
  void didChangeDependencies() {
    if (pageInit) {
      _spaceProvider = Provider.of<SpaceProvider>(context, listen: false);
      super.didChangeDependencies();
      pageInit = false;
    }
  }

  showClarificationDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) {
        final height = MediaQuery.of(context).size.height;
        final width = MediaQuery.of(context).size.width;
        final primaryColor = Theme.of(context).primaryColor;
        final accentColor = Theme.of(context).accentColor;

        return Dialog(
          child: Container(
              padding: EdgeInsets.symmetric(
                vertical: height * .02,
                horizontal: width * .05,
              ),
              height: height * .2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Once you're done posting your event space our team will review it's legitimacy and quality of photos uploaded. Please look forward to receiving an email from us for further clarification.",
                      style: TextStyle(
                        color: accentColor,
                        fontSize: width * .05,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          agreed = true;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontSize: width * .05,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              )),
        );
      }),
    ).then((_) {
      if (agreed) _uploadSpace();
    });
  }

  _uploadSpace() async {
    try {
      setState(() => postingSpace = true);
      ShowProgressDialog(context: context, isDone: false);
      await _spaceProvider.uploadSpace(
        space: widget.space,
        imageFiles: widget.images,
      );
      setState(() => postingSpace = false);
      Navigator.of(context).pop();
      ShowProgressDialog(context: context, isDone: true);
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, '/my-spaces-screen');
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
        onPressed: showClarificationDialog,
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
                  title: Text('Space verification'),
                  subtitle: Text(
                    'PENDING',
                    style: TextStyle(color: Colors.yellow),
                  ),
                ),
                ListTile(
                  title: Text('Space Name'),
                  subtitle: Text(widget.space.name),
                ),
                ListTile(
                  title: Text('City'),
                  subtitle: Text(widget.space.city),
                ),
                ListTile(
                  title: Text('Description'),
                  subtitle: Text(widget.space.description),
                ),
                ListTile(
                  title: Text('Latitude'),
                  subtitle: Text(widget.space.latitude.toString()),
                ),
                ListTile(
                  title: Text('Longitude'),
                  subtitle: Text(widget.space.longitude.toString()),
                ),
                ListTile(
                  title: Text('Address'),
                  subtitle: Text(widget.space.address),
                ),
                ListTile(
                  title: Text('Price per Hour'),
                  subtitle: Text(widget.space.price.toString()),
                ),
                ListTile(
                  title: Text('Minimun Capacity'),
                  subtitle: Text(widget.space.minCapacity.toString()),
                ),
                ListTile(
                  title: Text('Maximum Capacity'),
                  subtitle: Text(widget.space.maxCapacity.toString()),
                ),
                ListTile(
                  title: Text('Number of washrooms'),
                  subtitle: Text(widget.space.washroom.toString()),
                ),
                ListTile(
                  title: Text('Number of parking lots'),
                  subtitle: Text(widget.space.parkingLot.toString()),
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
