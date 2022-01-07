import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:intl/intl.dart';
import 'package:scout/models/request.dart';
import 'package:scout/widgets/requests_screen/sub_widgets/payment_dialog.dart';
import 'package:scout/widgets/requests_screen/sub_widgets/request_dialog.dart';

class RequestTile extends StatefulWidget {
  final Request request;
  RequestTile({@required this.request});

  @override
  _RequestTileState createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
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

    return Container(
      color: request.status == RequestStatus.CANCELED
          ? Colors.grey.withOpacity(.2)
          : request.viewedByScout
              ? Colors.white
              : primaryColor.withOpacity(0.3),
      height: height * .13,
      // height: height * .21,
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: request.paid || request.status == RequestStatus.CANCELED
                ? null
                : request.status == RequestStatus.ACCEPTED
                    ? () => PaymentDialog(
                          context: context,
                          request: request,
                        ).view()
                    : () => RequestDialog(
                          context: context,
                          request: request,
                        ).view(),
            leading: CircleAvatar(
              backgroundImage: AdvancedNetworkImage(
                request.vendorPhotoUrl,
                useDiskCache: true,
                fallbackAssetImage: 'assets/images/user.png',
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  request.vendorName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * .047,
                  ),
                ),
                Text(
                  _printDuration(
                      DateTime.now().difference(request.creationDate)),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: width * .042,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              children: <Widget>[
                Text(
                  'You requested to book ${request.spaceName} on ${DateFormat.yMMMMEEEEd().format(request.eventDate)} at ${DateFormat.Hm().format(request.eventDate)} for ${request.hours} hours.',
                  style: TextStyle(
                    fontSize: width * .043,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Your max attendants will be ${NumberFormat('#,###').format(request.maxCapacity)}.',
                      style: TextStyle(
                        fontSize: width * .043,
                      ),
                    ),
                    if (request.status == RequestStatus.PENDING)
                      Text(
                        'PENDING',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: width * .043,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (request.status == RequestStatus.ACCEPTED)
                      Text(
                        'ACCEPTED',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: width * .043,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (request.status == RequestStatus.REJECTED)
                      Text(
                        'REJECTED',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: width * .043,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (request.status == RequestStatus.CANCELED)
                      Text(
                        'CANCELED',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: width * .043,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            isThreeLine: true,
          ),
          // Expanded(
          //   child: GridView(
          //     padding: EdgeInsets.all(20),
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 7,
          //       childAspectRatio: 2 / 2,
          //       crossAxisSpacing: 10,
          //       mainAxisSpacing: 10,
          //     ),
          //     children: <Widget>[
          //       ...request.spaceImages.map((image) {
          //         return TransitionToImage(
          //           image: AdvancedNetworkImage(
          //             image,
          //             loadedCallback: () {},
          //             loadFailedCallback: () {},
          //             loadingProgress: (double progress, dataInInt) {},
          //             useDiskCache: true,
          //           ),
          //           loadingWidgetBuilder: (_, double progress, __) => Center(
          //             child: CircularProgressIndicator(
          //               value: progress,
          //               backgroundColor: Theme.of(context).accentColor,
          //               valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          //             ),
          //           ),
          //           placeholderBuilder: ((_, refresh) {
          //             return Center(
          //               child: InkWell(
          //                 onTap: refresh,
          //                 child: Icon(Icons.refresh),
          //               ),
          //             );
          //           }),
          //           fit: BoxFit.cover,
          //           placeholder: const Icon(Icons.refresh),
          //           enableRefresh: true,
          //         );
          //       }).toList(),
          //     ],
          //   ),
          // ),
          Divider(
            thickness: 2,
            indent: width * .19,
          )
        ],
      ),
    );
  }
}
