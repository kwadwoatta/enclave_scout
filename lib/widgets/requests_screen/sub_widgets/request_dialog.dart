import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scout/models/request.dart';
import 'package:scout/providers/request.dart';
import 'package:scout/widgets/show_error_dialog.dart';

class RequestDialog {
  final BuildContext context;
  final Request request;

  RequestDialog({
    @required this.context,
    @required this.request,
  });

  view() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    bool responded = false;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) {
        return StatefulBuilder(
          builder: ((context, setState) {
            return Dialog(
              child: Container(
                height: height * .22,
                padding: EdgeInsets.symmetric(
                  vertical: height * .01,
                  horizontal: width * .05,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'You sent ${request.vendorName} a request on ${DateFormat.yMMMMEEEEd().format(request.creationDate)} to book ${request.spaceName} for the date ${DateFormat.yMMMMEEEEd().format(request.eventDate)} for a duration of ${request.hours} hours starting from ${DateFormat.Hm().format(request.eventDate)}.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: width * .043,
                      ),
                    ),
                    SizedBox(height: height * .07),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            if (request.status == RequestStatus.ACCEPTED ||
                                request.status == RequestStatus.PENDING) {
                              Provider.of<RequestProvider>(context)
                                  .cancelRequest(requestId: request.requestId)
                                  .then((_) {
                                setState(() => responded = true);
                                Navigator.of(context).pop();
                              });
                            }
                          },
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: width * .05,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() => responded = true);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: width * .05,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
        );
      }),
    ).then((_) {
      try {
        if (responded)
          Provider.of<RequestProvider>(context)
              .toggleViewed(requestId: request.requestId);
      } catch (e) {
        print(e);
        ErrorDialog(
          context: context,
          error: 'Error whiles setting request as viewed',
        ).showError();
      }
    });
  }
}
