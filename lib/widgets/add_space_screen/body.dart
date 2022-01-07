import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scout/screens/confirm_space_form_screen.dart';
import 'package:scout/widgets/show_alert_dialog.dart';
import 'package:scout/widgets/show_error_dialog.dart';

import './sub_widgets/selected_images_carousel.dart';
import '../../widgets/showAlertDialog.dart';
import 'sub_widgets/form.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File coverPhoto;
  List<File> spaceImages = [];

  bool imagesDone = false;
  bool imagesLoading = false;

  Future<File> getImageFileFromAssets(String path, ByteData byteData) async {
    final file = File(path);
    await file.writeAsBytes(byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    ));

    return file;
  }

  Future<int> getImageFileLength(String path, Asset asset) async {
    File pickedFile =
        await getImageFileFromAssets(path, await asset.getByteData());
    return pickedFile.length().then((length) {
      return length;
    });
  }

  _pickSpacePhotos() async {
    try {
      List<Asset> pickedAssets = await MultiImagePicker.pickImages(
        maxImages: 7,
        materialOptions: MaterialOptions(
          actionBarTitle: "Event space photos",
          allViewTitle: "All view title",
          actionBarColor: "#37c888",
          actionBarTitleColor: "#ffffff",
          lightStatusBar: false,
          statusBarColor: "#37c888",
          selectCircleStrokeColor: "#696969",
          selectionLimitReachedText: "You can't select any more.",
        ),
      );

      final tempDir = await getTemporaryDirectory();

      if (pickedAssets.length < 7) throw Exception("Please select 7 images");

      if (spaceImages.isNotEmpty) setState(() => spaceImages.clear());

      setState(() => imagesLoading = true);

      //* Compress and store images
      pickedAssets.forEach((pickedAsset) async {
        final targetPath = tempDir.absolute.path + '/${pickedAsset.name}';

        //* print('******* Picked image Size *******');
        // getImageFileLength(targetPath, pickedAsset).then((length) {
        //   print(length);
        // });

        final sizeinBytes = await getImageFileLength(targetPath, pickedAsset);

        //* If image size is less than 2 MB don't compress
        if (sizeinBytes >= 2097152) {
          final file = await getImageFileFromAssets(
            targetPath,
            await pickedAsset.getByteData(),
          );

          final compressedImage = await FlutterImageCompress.compressAndGetFile(
            file.path,
            targetPath,
            quality: 50,
            format: CompressFormat.jpeg,
          );

          // Check sizes of images
          final comSizeinBytes =
              await File(compressedImage.absolute.path).length();
          if (comSizeinBytes >= 2097152) {
            throw Exception(
              '${pickedAsset.name} is bigger than 2MB. Please select another',
            );
          }

          // print('******* Compressed image size *******');
          // await File(compressedImage.absolute.path).length().then((length) {
          //   print(length);
          // });
          setState(() {
            spaceImages.add(compressedImage);
            if (spaceImages.length == pickedAssets.length) imagesDone = true;
            if (spaceImages.length == pickedAssets.length)
              imagesLoading = false;
          });
        } else {
          final uncompressedImage = await getImageFileFromAssets(
            targetPath,
            await pickedAsset.getByteData(),
          );
          setState(() {
            spaceImages.add(uncompressedImage);
            if (spaceImages.length == pickedAssets.length) imagesDone = true;
            if (spaceImages.length == pickedAssets.length)
              imagesLoading = false;
          });
        }
      });
    } catch (e) {
      print(e);
      ErrorDialog(context: context, error: e).showError();
    }
  }

  String capitalize(String str) {
    print(str);
    List<String> splitStr = str.toLowerCase().split(' ');
    for (var i = 0; i < splitStr.length; i++) {
      splitStr[i] = splitStr[i][0].toUpperCase() + splitStr[i].substring(1);
    }
    return splitStr.join(' ');
  }

  _confirmForm(space) {
    print('here');

    if (spaceImages.length == 0)
      return ErrorDialog(
        context: context,
        error: "Please upload images of the space.",
      ).showError();

    if (imagesLoading)
      return ShowAlertDialog(
        context: context,
        message:
            'Still loading images, please retry after all images are done loading.',
        actionable: true,
      );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmSpaceFormScreen(
          space: space,
          images: spaceImages,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final accentColor = Theme.of(context).accentColor;
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      height: screenSize.height,
      width: screenSize.width,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: _pickSpacePhotos,
            child: imagesDone || imagesLoading
                ? imagesDone
                    ? ImagesCarousel(
                        height: screenSize.height * .4,
                        imageFiles: spaceImages,
                      )
                    : Container(
                        height: screenSize.height * .4,
                        width: screenSize.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Loading...',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      )
                : Container(
                    height: screenSize.height * .4,
                    width: screenSize.width,
                    color: Colors.white,
                    child: Container(
                      height: screenSize.height * .3,
                      width: screenSize.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                          color: Colors.grey,
                          width: 2,
                        )),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Click to add event advertisment photos',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(height: 30),
                          Text(
                            'First picture will be used as cover photo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          Expanded(
            child: SpaceForm(
              confirmForm: _confirmForm,
            ),
          ),
        ],
      ),
    );
  }
}
