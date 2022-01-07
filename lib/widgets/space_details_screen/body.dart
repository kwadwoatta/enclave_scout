import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:scout/custom_icons/custom_icons.dart';
import 'package:scout/models/request.dart';
import 'package:scout/models/space.dart';
import 'package:scout/providers/request.dart';
import 'package:scout/widgets/show_error_dialog.dart';
import 'package:scout/widgets/space_details_screen/sub_widgets/images_carousel.dart';
import 'package:scout/widgets/space_details_screen/sub_widgets/bottom_request_bar.dart';
import 'package:scout/widgets/space_details_screen/sub_widgets/nav_bar.dart';
import 'package:scout/widgets/space_details_screen/sub_widgets/request_form_dialog.dart';

class Body extends StatefulWidget {
  final Space space;
  Body({this.space});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool requestSubmitted = false;
  bool submitting = false;
  bool requestFormShowing = false;
  bool confirmDialogShowing = false;
  DateTime _pickedDate = DateTime.now();
  TextEditingController _capacity = TextEditingController();
  int numberOfHours;
  final _formKey = GlobalKey<FormState>();
  RequestProvider requestProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _capacityValidator(String val) {
    if (val.trim().length == 0) return 'Enter a maximum capacity';
    if (int.tryParse(val) == null) return 'Enter a valid number';
    return null;
  }

  _showConfirmDialog({
    BuildContext context,
    DateTime date,
    int hours,
  }) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) {
        final height = MediaQuery.of(context).size.height;
        final width = MediaQuery.of(context).size.width;
        final primaryColor = Theme.of(context).primaryColor;

        return Dialog(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 5, top: 10),
            height: height * .16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "You're about to send a request to book ${widget.space.name} on ${DateFormat.yMMMMEEEEd().format(date)} from ${DateFormat.Hm().format(date)} for $hours hours.\nYour maximum attendants will be ${NumberFormat('#,###').format(int.parse(_capacity.text))}.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: width * .042,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: width * .04,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(width: 10),
                    FlatButton(
                      child: Text(
                        'PROCEED',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: width * .04,
                        ),
                      ),
                      onPressed: () async {
                        setState(() => submitting = true);
                        Navigator.of(context).pop();
                        final request = Request(
                          creationDate: DateTime.now(),
                          eventDate: date,
                          hours: hours,
                          maxCapacity: int.parse(_capacity.text),
                          spaceName: widget.space.name,
                          vendorId: widget.space.vendorId,
                          vendorName: widget.space.vendorName,
                          status: RequestStatus.PENDING,
                          spaceImages: widget.space.venueImages,
                          vendorPhotoUrl: widget.space.vendorImage,
                          pricePerHour: widget.space.price,
                          acceptanceDate: null,
                          cancelationDate: null,
                          rejectionDate: null,
                          requestId: null,
                          scoutId: null,
                          scoutName: null,
                          scoutPhotoUrl: null,
                        );
                        _requestSpace(request: request);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  _showRequestFormDialog({BuildContext context, String spaceName}) async {
    RequestFormDialog(
      context: context,
      capacity: _capacity,
      capacityValidator: _capacityValidator,
      numberOfHours: numberOfHours,
      pickedDate: _pickedDate,
      showConfirmDialog: _showConfirmDialog,
      formKey: _formKey,
    );
  }

  _requestSpace({@required Request request}) async {
    try {
      final sendRequest = Provider.of<RequestProvider>(context).sendRequest;

      ShowProgressDialog(
        context: context,
        isDone: false,
      );

      await sendRequest(request: request);
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      ShowProgressDialog(
        context: context,
        isDone: true,
      );
      await Future.delayed(Duration(seconds: 5));
      Navigator.of(context).pop();
      setState(() => requestSubmitted = true);
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
      ErrorDialog(
        context: context,
        error: 'Error whiles sending request. Retry',
      ).showError();
    }
  }

  @override
  Widget build(BuildContext context) {
    Space space = widget.space;
    // final primaryColor = Theme.of(context).primaryColor;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ImagesCarousel(
              images: space.venueImages,
            ),
            Expanded(
              child: Container(
                // color: Colors.red,
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  children: <Widget>[
                    Text(
                      '${space.name}, ${space.city}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: width * .08,
                        wordSpacing: 1.5,
                      ),
                    ),
                    Text(
                      space.address,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: width * .045,
                        wordSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: height * .04),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text:
                                '¢ ${NumberFormat('#,###.0#', 'en_US').format(space.price)}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: width * .08,
                              wordSpacing: 1.5,
                            ),
                          ),
                          TextSpan(
                            text: ' / hour',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * .02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Attributes(
                          icon: CustomIcons.audience,
                          counter: space.maxCapacity,
                          attribute: 'Maximum',
                        ),
                        Attributes(
                          icon: CustomIcons.toilet,
                          counter: space.washroom,
                          attribute: 'Washrooms',
                        ),
                        Attributes(
                          icon: CustomIcons.parking_car,
                          counter: space.parkingLot,
                          attribute: 'Parking Lots',
                        ),
                      ],
                    ),
                    SizedBox(height: height * .03),
                    Text(
                      space.description,
                      style: TextStyle(
                        fontSize: width * .045,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        InvisibleNavBar(
          spaceName: space.name,
          verified: space.verified,
        ),
        Positioned(
          top: height * .47,
          right: width * .06,
          child: FloatingActionButton(
            heroTag: '${space.name}-favorites-floater',
            backgroundColor: Colors.white,
            elevation: 5,
            onPressed: () => {},
            child: Icon(
              Icons.favorite,
              color: Colors.grey,
              // color: space.verified ? primaryColor : Colors.red,
            ),
          ),
        ),
        BottomRequestBar(
          space: space,
          onPressed: () => _showRequestFormDialog(
            context: context,
            spaceName: space.name,
          ),
        ),
      ],
    );
  }
}

class Attributes extends StatelessWidget {
  final IconData icon;
  final int counter;
  final String attribute;

  Attributes({
    @required this.icon,
    @required this.counter,
    this.attribute,
  });

  @override
  Widget build(BuildContext context) {
    // final primaryColor = Theme.of(context).primaryColor;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: height * .01,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: width * .07,
          ),
          SizedBox(height: height * .01),
          Text(
            '${NumberFormat('#,###', 'en_US').format(counter)} $attribute',
            style: TextStyle(
              fontSize: width * .042,
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
                              'Sending request ...',
                              style: TextStyle(fontSize: width * .05),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              'Request sent successfully.\nGo to Settings > Requests to see all of your sent requests',
                              textAlign: TextAlign.center,
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
