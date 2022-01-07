import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:scout/custom_icons/custom_icons.dart';
import 'package:scout/screens/verify_phone_screen.dart';
import 'package:scout/widgets/show_alert_dialog.dart';
import 'package:scout/widgets/show_error_dialog.dart';

import '../widgets/showAlertDialog.dart';
import '../providers/user.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = "/signup-screen";

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _signupFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool imageLoading = false;
  bool _isInit = true;
  UserProvider userProvider;
  File pickedImage;

  didChangeDependencies() {
    if (_isInit) {
      userProvider = Provider.of<UserProvider>(context);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _emailController = TextEditingController();
  var _phoneController = TextEditingController();
  var _passwordController = TextEditingController();
  var _rPasswordController = TextEditingController();

  _phoneValidator(String val) {
    if (val.trim().length != 10) return 'Enter 10 digit phone number';
    if (int.tryParse(val) == null) return 'Enter correct phone number';
    return null;
  }

  _passwordValidator(String val) {
    if (val.trim().length == 0) return 'Password must be 6 or more characters';
    if (val.length < 6) return 'Password must be 6 or more characters';
    return null;
  }

  _repeatPvalidator(String val) {
    if (val != _passwordController.text)
      return 'Password does not match, RETRY !';
    return null;
  }

  _nameValidator(String val) {
    if (int.tryParse(val) != null) return 'Please enter a name';
    if (val.trim().length == 0) return 'Please enter your correct name';
    if (val.trim().length < 4) return 'Seems too short to be a correct name';
    return null;
  }

  _emailVaidator(String val) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(val)) return 'Please enter a valid email address';
    return null;
  }

  Future<void> _signUp(BuildContext context) async {
    try {
      if (!_signupFormKey.currentState.validate()) return;
      if (pickedImage == null)
        return ErrorDialog(
          context: context,
          error: 'Please upload a profile picture',
        ).showError();
      _signupFormKey.currentState.save();
      setState(() => _isLoading = true);

      await userProvider.signUserUp(
        email: _emailController.text,
        password: _passwordController.text,
        phoneNumber: _phoneController.text,
        userName: '${_firstNameController.text} ${_lastNameController.text}',
        profilePic: pickedImage,
      );
      setState(() => _isLoading = false);
      ShowAlertDialog(
        context: context,
        message: "Your account has been created successfully.",
        actionable: false,
      );

      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pop();

      final user = await FirebaseAuth.instance.currentUser();
      await user.reload();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => VerifyPhoneScreen(
            phoneNumber: '+233${_phoneController.text}',
            userId: user.uid,
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      setState(() => _isLoading = false);
      print(e);
      ErrorDialog(
        context: context,
        error: e,
      ).showError();
    }
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
      setState(() => imageLoading = true);

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
            pickedImage = compressedImage;
            imageLoading = false;
          });
        } else {
          final uncompressedImage = await getImageFileFromAssets(
            targetPath,
            await pickedAsset.getByteData(),
          );
          setState(() {
            pickedImage = uncompressedImage;
            imageLoading = false;
          });
        }
      });
    }).catchError((e) {
      print(e);
      showAlertDialog(
        message: e.message,
        type: "error",
        context: context,
      );
    });
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
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            // width: width * .4,
            // color: Colors.red,
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: width * .2,
                  backgroundImage: imageLoading
                      ? AssetImage('assets/images/loading.gif')
                      : pickedImage == null
                          ? AssetImage('assets/images/user.png')
                          : FileImage(pickedImage),
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
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Form(
                key: _signupFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          readOnly: _isLoading,
                          controller: _firstNameController,
                          validator: (val) => _nameValidator(val),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(12),
                          ],
                          style: TextStyle(
                            fontSize: 18,
                            color: primaryColor,
                          ),
                          cursorColor: primaryColor,
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
                            labelText: 'First Name',
                            suffixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        SizedBox(height: height * .02),
                        TextFormField(
                          readOnly: _isLoading,
                          controller: _lastNameController,
                          validator: (val) => _nameValidator(val),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(12),
                          ],
                          style: TextStyle(
                            fontSize: 18,
                            color: primaryColor,
                          ),
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
                            labelText: 'Last Name',
                            suffixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        SizedBox(height: height * .02),
                        TextFormField(
                          readOnly: _isLoading,
                          controller: _emailController,
                          validator: (val) => _emailVaidator(val),
                          style: TextStyle(
                            fontSize: 18,
                            color: primaryColor,
                          ),
                          keyboardType: TextInputType.emailAddress,
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
                            labelText: 'Email',
                            suffixIcon: Icon(
                              CustomIcons.mail,
                              size: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: height * .02),
                        TextFormField(
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
                        SizedBox(height: height * .02),
                        TextFormField(
                          readOnly: _isLoading,
                          controller: _passwordController,
                          validator: (val) => _passwordValidator(val),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(12),
                          ],
                          style: TextStyle(
                            fontSize: 18,
                            color: primaryColor,
                          ),
                          obscureText: true,
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
                            labelText: 'Password',
                            suffixIcon: Icon(Icons.vpn_key),
                          ),
                        ),
                        SizedBox(height: height * .02),
                        TextFormField(
                          readOnly: _isLoading,
                          controller: _rPasswordController,
                          validator: (val) => _repeatPvalidator(val),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(12),
                          ],
                          style: TextStyle(
                            fontSize: 18,
                            color: primaryColor,
                          ),
                          obscureText: true,
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
                            labelText: 'Repeat Password',
                            suffixIcon: Icon(Icons.vpn_key),
                          ),
                        ),
                        SizedBox(height: height * .02),
                        _isLoading
                            ? CircularProgressIndicator()
                            : SizedBox(
                                height: height * .055,
                                width: width * .5,
                                child: RaisedButton(
                                  color: primaryColor,
                                  textColor: Colors.white,
                                  child: Text(
                                    'CREATE ACCOUNT',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  onPressed: () => _signUp(context),
                                ),
                              ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
