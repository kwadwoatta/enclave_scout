import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scout/providers/user.dart';
import 'package:scout/widgets/show_alert_dialog.dart';
import 'package:scout/widgets/show_error_dialog.dart';

class VerifyPhoneScreen extends StatefulWidget {
  static const routeName = "/verify-phone";

  final String phoneNumber;
  final String userId;
  // final String name;
  // final String password;
  // final String email;

  VerifyPhoneScreen({
    this.phoneNumber,
    this.userId,
    // this.name,
    // this.password,
    // this.email,
  });

  @override
  _VerifyPhoneScreenState createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _one = TextEditingController();
  TextEditingController _two = TextEditingController();
  TextEditingController _three = TextEditingController();
  TextEditingController _four = TextEditingController();
  TextEditingController _five = TextEditingController();
  TextEditingController _six = TextEditingController();
  String verificationId;
  String smsCode;
  String userId;
  String phoneNumber;
  AuthCredential credential;

  bool _isInit = true;
  bool _isLoading = false;
  bool otpSent = false;
  bool _verifyingOTP = false;
  bool dialogOneShowing = false;
  bool dialogTwoShowing = false;
  UserProvider userProvider;

  @override
  Future<void> didChangeDependencies() async {
    userProvider = Provider.of<UserProvider>(context);

    if (_isInit) {
      try {
        // verificationId = userProvider.verificationId;
        // print('verificationId');
        // print(verificationId);

        if (widget.userId == null) {
          final user = await FirebaseAuth.instance.currentUser();
          userId = user.uid;
          print('userId');
          print(userId);
        } else
          userId = widget.userId;
        print('user id set');

        if (widget.phoneNumber == null) {
          final user = await FirebaseAuth.instance.currentUser();
          if (user.phoneNumber != null)
            phoneNumber = user.phoneNumber;
          else {
            final querySnapshot = await Firestore.instance
                .collection('/scouts')
                .where('uid', isEqualTo: userId)
                .getDocuments();

            if (querySnapshot.documents[0] == null)
              throw Exception("Documet fetch error");
            final userDoc = querySnapshot.documents[0].data;
            phoneNumber = userDoc['phoneNumber'];
            print(phoneNumber);
            print('user phoneNumber set');
          }
        } else
          phoneNumber = widget.phoneNumber;
        print(phoneNumber);

        _isInit = false;
      } catch (error) {
        print(error);
        ErrorDialog(context: context, error: error).showError();
      }
    }
    super.didChangeDependencies();
  }

  _otpValidator(String val) {
    if (val.trim().length != 6) return '!';
    if (int.tryParse(val) == null) return '!';
    return null;
  }

  _resendOTP() {
    try {
      setState(() {
        _isLoading = true;
      });

      final PhoneCodeAutoRetrievalTimeout autoRetrieve = (verId) {
        verificationId = verId;
        print('autoretreival timed out');
      };

      final PhoneCodeSent smsCodeSent =
          (String verId, [int forceCodeResend]) async {
        print('Phone code sent');
        verificationId = verId;
        setState(() {
          _isLoading = false;
          otpSent = true;
          dialogOneShowing = true;
        });

        ShowAlertDialog(
          context: context,
          message: "We've sent you an SMS code. Please enter it below.",
          actionable: false,
        );
        await Future.delayed(Duration(seconds: 3));
        Navigator.of(context).pop();
      };

      final PhoneVerificationCompleted verifySucceed =
          (AuthCredential authCred) async {
        try {
          print('Verification complete');
          ShowAlertDialog(
            context: context,
            actionable: false,
            message: "Verifying ...",
          );
          await userProvider.updatePhoneNumber(
            phoneNumber: phoneNumber,
            credential: authCred,
          );
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop();
          final user = await FirebaseAuth.instance.currentUser();
          user.reload();
        } catch (error) {
          print(error);
          Navigator.of(context).pop();
          ErrorDialog(context: context, error: error).showError();
          throw error;
        }
      };

      final PhoneVerificationFailed verifyFailed = (AuthException authEx) {
        print(authEx.message);
        setState(() {
          _isLoading = false;
        });
        ErrorDialog(context: context, error: authEx.message).showError();
        // throw Exception(authEx.message);
      };

      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 30),
        verificationFailed: verifyFailed,
        verificationCompleted: verifySucceed,
      );
    } catch (error) {
      setState(() {
        otpSent = false;
        _isLoading = false;
      });
      print(error);
      ErrorDialog(context: context, error: error).showError();
    }
  }

  _verifyOTP() async {
    smsCode =
        '${_one.text}${_two.text}${_three.text}${_four.text}${_five.text}${_six.text}';
    print(smsCode);
    print(verificationId);
    try {
      setState(() => _isLoading = true);
      final credential = PhoneAuthProvider.getCredential(
        smsCode: smsCode,
        verificationId: verificationId,
      );

      await userProvider.updatePhoneNumber(
        phoneNumber: phoneNumber,
        credential: credential,
      );
      setState(() => _isLoading = false);
      FirebaseAuth.instance.currentUser().then((user) {
        user.reload().then((_) {
          Navigator.of(context).pushReplacementNamed('/');
          // if (!user.isEmailVerified)
          //   Navigator.of(context).pushReplacementNamed('/verify-email');
          // Navigator.of(context).pushReplacementNamed('/verify-card');
        });
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ErrorDialog(context: context, error: e).showError();
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).accentColor;

    Widget textField({@required TextEditingController controller}) {
      return Container(
        width: width * .1,
        height: height * .07,
        margin: EdgeInsets.only(right: width * .02),
        child: TextFormField(
          validator: (val) => _otpValidator(val),
          cursorColor: Color(0xff77a27a),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
          ],
          keyboardType: TextInputType.phone,
          controller: controller,
          readOnly: _verifyingOTP,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: accentColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
          ),
        ),
      );
    }

    return Builder(
      builder: (context) => Scaffold(
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
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => FirebaseAuth.instance.signOut(),
            )
          ],
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: height * .3),
              Form(
                key: _formKey,
                child: Container(
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      textField(controller: _one),
                      textField(controller: _two),
                      textField(controller: _three),
                      textField(controller: _four),
                      textField(controller: _five),
                      textField(controller: _six),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * .3),
              Align(
                alignment: Alignment.center,
                child: _isLoading
                    ? CircularProgressIndicator(
                        backgroundColor: Color(0xff77a27a),
                      )
                    : SizedBox(
                        width: width * .35,
                        height: height * .06,
                        child: !otpSent
                            ? RaisedButton(
                                color: primaryColor,
                                textColor: Colors.white,
                                child: Text(
                                  'Send OTP',
                                  style:
                                      TextStyle(fontSize: 20, letterSpacing: 1),
                                ),
                                onPressed:
                                    _verifyingOTP ? null : () => _resendOTP(),
                              )
                            : RaisedButton(
                                color: primaryColor,
                                textColor: Colors.white,
                                child: Text(
                                  'VERIFY',
                                  style:
                                      TextStyle(fontSize: 20, letterSpacing: 1),
                                ),
                                onPressed:
                                    _verifyingOTP ? null : () => _verifyOTP(),
                              ),
                      ),
              ),
              SizedBox(height: height * .03),
              if (otpSent)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Haven't received SMS code yet? ",
                      style: TextStyle(color: Colors.red),
                    ),
                    FlatButton(
                      child: Text('Resend'),
                      onPressed: _resendOTP,
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
