import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:scout/custom_icons/custom_icons.dart';
import 'package:scout/providers/user.dart';
import 'package:scout/screens/verify_phone_screen.dart';
import 'package:scout/widgets/show_error_dialog.dart';

class EnterPhoneNumberScreen extends StatefulWidget {
  static const routeName = "/enter-phone-number";

  @override
  _EnterPhoneNumberScreenState createState() => _EnterPhoneNumberScreenState();
}

class _EnterPhoneNumberScreenState extends State<EnterPhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();

  var _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _imageLoading = false;
  bool _isInit = true;
  File _pickedImage;

  UserProvider userProvider;

  didChangeDependencies() {
    if (_isInit) {
      userProvider = Provider.of<UserProvider>(context);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  _phoneValidator(String val) {
    if (val.trim().length != 10) return 'Enter 10 digit phone number';
    if (int.tryParse(val) == null) return 'Enter correct phone number';
    return null;
  }

  Future<File> getImageFileFromAssets(String path, ByteData byteData) async {
    final file = File(path);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<int> getImageFileLength(String path, Asset asset) async {
    File pickedFile =
        await getImageFileFromAssets(path, await asset.getByteData());
    return pickedFile.length().then((length) {
      return length;
    });
  }

  void _pickPic() {
    MultiImagePicker.pickImages(
      maxImages: 1,
      materialOptions: MaterialOptions(
        actionBarTitle: "Pick profile picture",
        allViewTitle: "All view title",
        actionBarColor: "#37c888",
        actionBarTitleColor: "#ffffff",
        lightStatusBar: false,
        statusBarColor: "#37c888",
        selectCircleStrokeColor: "#696969",
        selectionLimitReachedText: "You can't select any more.",
      ),
    ).then((pickedAssets) async {
      final tempDir = await getTemporaryDirectory();
      setState(() => _imageLoading = true);

      // Compress and store images
      pickedAssets.forEach((pickedAsset) async {
        final targetPath = tempDir.absolute.path + '/${pickedAsset.name}';

        final sizeinBytes = await getImageFileLength(targetPath, pickedAsset);

        // If image size is less than 2 MB don't compress
        if (sizeinBytes > 2097152) {
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
          if (comSizeinBytes > 2097152) {
            throw Exception(
              '${pickedAsset.name} is bigger than 2MB. Please select another',
            );
          }

          setState(() {
            _pickedImage = compressedImage;
            _imageLoading = false;
          });
        } else {
          final uncompressedImage = await getImageFileFromAssets(
            targetPath,
            await pickedAsset.getByteData(),
          );
          setState(() {
            _pickedImage = uncompressedImage;
            _imageLoading = false;
          });
        }
      });
    }).catchError((error) {
      print(error);
      ErrorDialog(context: context, error: error).showError();
    });
  }

  _goToVerify() async {
    try {
      if (!_formKey.currentState.validate()) return;
      if (_pickedImage == null)
        return ErrorDialog(
          context: context,
          error: 'Please upload a profile picture',
        ).showError();
      _formKey.currentState.save();
      setState(() => _isLoading = true);
      await userProvider.addPhoneNumberAndDP(
        phoneNumber: '+233${_phoneController.text}',
        photo: _pickedImage,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => VerifyPhoneScreen(
            phoneNumber: '+233${_phoneController.text}',
          ),
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ErrorDialog(context: context, error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).accentColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          'Verify Phone Number',
          style: TextStyle(
            color: primaryColor,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Logout"),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                // width: width * .4,
                // color: Colors.red,
                child: Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: width * .2,
                      backgroundImage: _imageLoading
                          ? AssetImage('assets/images/loading.gif')
                          : _pickedImage == null
                              ? AssetImage('assets/images/user.png')
                              : FileImage(_pickedImage),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: FloatingActionButton(
                        mini: true,
                        heroTag: 'uploadProfilePic',
                        child: Icon(CustomIcons.camera),
                        onPressed: () => _pickPic(),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: height * .3),
              Form(
                key: _formKey,
                child: Container(
                  height: height * .07,
                  width: width * .6,
                  child: TextFormField(
                    readOnly: _isLoading,
                    controller: _phoneController,
                    validator: (val) => _phoneValidator(val),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    style: TextStyle(
                      fontSize: 18,
                      color: primaryColor,
                    ),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 15,
                        color: accentColor,
                      ),
                      labelText: 'Mobile Money Phone Number',
                      suffixIcon: Icon(CustomIcons.phone),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * .3),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: width * .35,
                  height: height * .06,
                  child: RaisedButton(
                    color: primaryColor,
                    textColor: Colors.white,
                    child: Text(
                      'Verify Phone Number',
                      style: TextStyle(fontSize: 20, letterSpacing: 1),
                    ),
                    onPressed: _goToVerify,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
