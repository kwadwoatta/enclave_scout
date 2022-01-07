import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class RegionalCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // final primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: EdgeInsets.all(10),
      // color: Colors.green,
      height: screenSize.height * .25,
      child: ListView(
        children: <Widget>[
          RegionTile(
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/enclave-space.appspot.com/o/cities%2Faccra%2Faccra_pic%40640.jpg?alt=media&token=4925c5ca-141c-4ce8-9822-632148b65232',
            cityName: "Accra",
          ),
          RegionTile(
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/enclave-space.appspot.com/o/cities%2Fkumasi%2Fkumasi_pic.jpg?alt=media&token=0a257d8f-0bd1-41dc-8704-1cfa78aa8f1c',
            cityName: "Kumasi",
          ),
          RegionTile(
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/enclave-space.appspot.com/o/cities%2Fcape_coast%2Fcape_coast_pic%40640.jpg?alt=media&token=62a4c80f-edc4-49b0-80cb-b2540679b7f0',
            cityName: "Cape Coast",
          ),
          RegionTile(
            imageUrl:
                'https://upload.wikimedia.org/wikipedia/commons/b/b0/Sunyani_Cocoa_House.jpg',
            cityName: "Sunyani",
          )
        ],
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class RegionTile extends StatefulWidget {
  final String imageUrl;
  final String cityName;

  RegionTile({
    @required this.cityName,
    @required this.imageUrl,
  });

  @override
  _RegionTileState createState() => _RegionTileState();
}

class _RegionTileState extends State<RegionTile> {
  Function reloadFunction;

  @override
  Widget build(BuildContext context) {
    bool imageLoaded = false;
    bool imageFailed = false;
    final width = MediaQuery.of(context).size.width;
    final imageUrl = widget.imageUrl;
    final cityName = widget.cityName;
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: EdgeInsets.all(5),
      width: width * .5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/city-spaces-screen', arguments: {
              'imageUrl': imageUrl,
              'cityName': cityName,
            });
          },
          // : imageFailed ? reloadFunction : null,
          child: GridTile(
            child: Hero(
              tag: cityName,
              child: TransitionToImage(
                image: AdvancedNetworkImage(
                  imageUrl,
                  loadedCallback: () {
                    setState(() => imageLoaded = true);
                  },
                  loadFailedCallback: () {
                    setState(() => imageFailed = true);
                  },
                  loadingProgress: (double progress, dataInInt) {
                    // print('Now Loading: $progress');
                  },
                  useDiskCache: true,
                ),
                loadingWidgetBuilder: (_, double progress, __) => Center(
                  child: CircularProgressIndicator(
                    value: progress,
                    backgroundColor: Theme.of(context).accentColor,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
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
                fit: BoxFit.fill,
                placeholder: const Icon(Icons.refresh),
                width: width,
                enableRefresh: true,
              ),
            ),
            footer: GridTileBar(
              backgroundColor: Color(0xFFf1f0ee).withOpacity(.8),
              leading: Text(cityName),
            ),
          ),
        ),
      ),
    );
  }
}
