import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class ShowMapDialog {
  ShowMapDialog({
    BuildContext context,
    bool isDone,
    double latitude,
    double longitude,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) {
        final height = MediaQuery.of(context).size.height;
        final width = MediaQuery.of(context).size.width;
        final primaryColor = Theme.of(context).primaryColor;
        // bool imageLoaded = false;
        // bool imageFailed = false;

        return StatefulBuilder(
          builder: ((context, setState) {
            return Dialog(
              child: Container(
                padding: !isDone
                    ? EdgeInsets.only(left: 10, right: 5, top: 10)
                    : EdgeInsets.all(0),
                height: !isDone ? height * .17 : height * .25,
                child: isDone
                    ? Stack(
                        children: <Widget>[
                          TransitionToImage(
                            image: AdvancedNetworkImage(
                              "https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=19&size=600x300&maptype=hybrid&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=AIzaSyBH4E70p8YoQnfyKfbej4849IwtLNKMKpc",
                              loadedCallback: () {
                                // setState(() => imageLoaded = true);
                              },
                              loadFailedCallback: () {
                                // setState(() => imageFailed = true);
                              },
                              loadingProgress: (double progress, dataInInt) {},
                              useDiskCache: true,
                            ),
                            loadingWidgetBuilder: (_, double progress, __) =>
                                Center(
                              child: CircularProgressIndicator(
                                value: progress,
                                backgroundColor: Theme.of(context).accentColor,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(primaryColor),
                              ),
                            ),
                            placeholderBuilder: ((_, refresh) {
                              return Center(
                                child: InkWell(
                                  onTap: refresh,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.refresh),
                                      Text(
                                        'Tap to retry',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            fit: BoxFit.cover,
                            placeholder: const Icon(Icons.refresh),
                            width: width,
                            height: height * .25,
                            enableRefresh: true,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: FloatingActionButton(
                              mini: true,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          )
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(height: height * .02),
                            Text(
                              'Getting your current location ...',
                              style: TextStyle(fontSize: width * .05),
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
