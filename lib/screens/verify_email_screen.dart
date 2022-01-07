import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scout/custom_icons/custom_icons.dart';

import 'package:scout/providers/user.dart';
import 'package:scout/widgets/show_alert_dialog.dart';

class VerifyEmailScreen extends StatefulWidget {
  static const routeName = "/verify-email";

  final String userId;
  final String email;

  VerifyEmailScreen({
    this.email,
    this.userId,
  });

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  String userId;

  bool _isLoading = false;
  bool _isInit = true;
  String verificationId;
  UserProvider userProvider;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((user) {
      user.reload();
    });
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    userProvider = Provider.of<UserProvider>(context);

    if (_isInit) {
      if (widget.email == null) {
        await FirebaseAuth.instance.currentUser().then((user) {
          setState(() {
            _emailController = TextEditingController(text: user.email);
          });
        }).catchError((e) {
          print(e);
        });
      }
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  _emailVaidator(String val) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(val)) return 'Please enter a valid email address';
    return null;
  }

  _verifyEmailFunc({@required BuildContext context}) async {
    if (!_formKey.currentState.validate()) return;
    setState(() => _isLoading = true);

    await FirebaseAuth.instance.currentUser().then((user) {
      user.reload();
    });

    userProvider
        .verifyEmail(
      email: _emailController.text,
    )
        .then((_) {
      print("Email sent");
      setState(() => _isLoading = false);
      ShowAlertDialog(
        context: context,
        message:
            "Please check your inbox. A verification link has been sent to you.",
        actionable: true,
      );
      Future.delayed(Duration(seconds: 3)).then((_) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed('/');
      });

      // Navigator.of(context).pushReplacementNamed('/verify-card');
    }).catchError((e) {
      setState(() => _isLoading = false);
      print(e);
      // showAlertDialog(
      //   context: context,
      //   message: e.message,
      //   type: "error",
      //   whenPressed: () {
      //     Navigator.of(context).pop();
      //     Navigator.of(context).pop();
      //   },
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).accentColor;

    return Builder(
      builder: (context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Verify Email'),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: height,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: width * .1,
                    right: width * .1,
                    top: height * .35,
                  ),
                  width: width,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      readOnly: _isLoading,
                      controller: _emailController,
                      cursorColor: primaryColor,
                      validator: (val) => _emailVaidator(val),
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Scout Email',
                        suffixIcon: Icon(CustomIcons.mail),
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
                  ),
                ),
                SizedBox(height: height * .25),
                Align(
                  alignment: Alignment.center,
                  child: _isLoading
                      ? CircularProgressIndicator(
                          backgroundColor: Color(0xff77a27a),
                        )
                      : SizedBox(
                          width: width * .5,
                          height: height * .055,
                          child: RaisedButton(
                            color: primaryColor,
                            textColor: Colors.white,
                            child: Text(
                              'VERIFY',
                              style: TextStyle(fontSize: 20, letterSpacing: 1),
                            ),
                            onPressed: () => _verifyEmailFunc(context: context),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
