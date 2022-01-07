import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scout/custom_icons/custom_icons.dart';
import 'package:scout/models/request.dart';
import 'package:scout/providers/request.dart';
import 'package:scout/widgets/show_error_dialog.dart';

class PaymentCard extends StatefulWidget {
  final Request request;
  PaymentCard({@required this.request});

  @override
  _PaymentCardState createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    // String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    // return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    if (int.parse(twoDigits(duration.inHours)) < 1)
      return "$twoDigitMinutes min ago";
    else
      return duration.inDays >= 1
          ? "${duration.inDays} ${duration.inDays > 1 ? 'days' : 'day'}, ${twoDigits(24 - duration.inHours.remainder(24) > 0 ? 24 - duration.inHours.remainder(24) : 0)} ${24 - duration.inHours.remainder(24) > 1 ? 'hrs' : 'hr'}, $twoDigitMinutes min ago"
          : "${twoDigits(duration.inHours)} hrs, $twoDigitMinutes min ago";
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final primaryColor = Theme.of(context).primaryColor;
    final request = widget.request;

    return Card(
      // color: request.viewed ? Colors.white : primaryColor.withOpacity(0.2),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8,
      child: ListTile(
        onTap: request.viewedByScout
            ? null
            : () => RequestDialog(context: context, request: request).view(),
        leading: CircleAvatar(
          backgroundImage: AdvancedNetworkImage(
            request.scoutPhotoUrl,
            useDiskCache: true,
            fallbackAssetImage: 'assets/images/user.png',
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              request.scoutName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: width * .047,
              ),
            ),
            Text(
              _printDuration(DateTime.now().difference(request.creationDate)),
              // '${DateTime.now().difference(request.creationDate).inHours} hours, ${DateTime.now().difference(request.creationDate).inMinutes} minutes ago',
              style: TextStyle(
                color: Colors.grey,
                fontSize: width * .042,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Paid ¢25,000.00 to book ${request.spaceName} on ${DateFormat.yMMMMEEEEd().format(request.creationDate)} at ${DateFormat.Hm().format(request.creationDate)}',
              style: TextStyle(
                fontSize: width * .043,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Event Date: ${DateFormat.yMMMd().format(request.eventDate)}.',
                  style: TextStyle(
                    fontSize: width * .043,
                  ),
                ),
                Icon(
                  CustomIcons.sim_card,
                  size: width * .05,
                  // color: Color(0xFFffcc00),
                  // color: Color(0xFFe60000),
                  color: Color(0xFF01377a),
                ),
              ],
            )
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}

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
                      '${request.scoutName} sent you a request on ${DateFormat.yMMMMEEEEd().format(request.creationDate)} to book ${request.spaceName} for the date ${DateFormat.yMMMMEEEEd().format(request.eventDate)} for a duration of ${request.hours} hours starting from ${DateFormat.Hm().format(request.eventDate)}.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: width * .05,
                      ),
                    ),
                    SizedBox(height: height * .07),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Provider.of<RequestProvider>(context)
                                .cancelRequest(requestId: request.requestId)
                                .then((_) {
                              setState(() => responded = true);
                              Navigator.of(context).pop();
                            });
                          },
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: width * .037,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Provider.of<RequestProvider>(context)
                            //     .acceptRequest(requestId: request.requestId)
                            //     .then((_) {
                            //   setState(() => responded = true);
                            //   Navigator.of(context).pop();
                            // });
                          },
                          child: Text(
                            'ACCEPT FOR PAYMENT',
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
