import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout/widgets/show_error_dialog.dart';

import '../providers/user.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login-screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isInit = true;
  UserProvider userProvider;

  // dispose() {
  //   userProvider.dispose();
  //   super.dispose();
  // }

  didChangeDependencies() {
    if (_isInit) {
      userProvider = Provider.of<UserProvider>(context);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  _passwordValidator(String val) {
    if (val.trim().length == 0) return 'Password must be 6 or more characters';
    if (val.length < 6) return 'Password must be 6 or more characters';
    return null;
  }

  _emailVaidator(String val) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(val.trim()))
      return 'Please enter a valid email address';
    return null;
  }

  loginUserIn() {
    if (!_loginFormKey.currentState.validate()) return;
    setState(() => _isLoading = true);
    userProvider
        .logUserIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    )
        .then((_) {
      setState(() => _isLoading = false);
      // Navigator.of(context).pushReplacementNamed('/home-screen');
    }).catchError((error) {
      setState(() => _isLoading = false);
      ErrorDialog(context: context, error: error).showError();
    });
  }

  loginUserInWithGoogle() {
    setState(() => _isLoading = true);
    userProvider.logUserInWithGoogle().then((_) {
      setState(() => _isLoading = false);
      // Navigator.of(context).pushReplacementNamed('/home-screen');
    }).catchError((error) {
      setState(() => _isLoading = false);
      ErrorDialog(context: context, error: error).showError();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;
    // final accentColor = Theme.of(context).accentColor;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenSize.height,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              // Align(
              //   alignment: Alignment.topCenter,
              //   child: Container(
              //     margin: EdgeInsets.only(top: screenSize.height * .1),
              //     height: screenSize.height * .1,
              //     child: Text(
              //       "Enclave Scout",
              //       style: TextStyle(
              //         fontSize: 50,
              //         fontWeight: FontWeight.bold,
              //         color: primaryColor,
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Form(
                        key: _loginFormKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              readOnly: _isLoading,
                              controller: _emailController,
                              validator: (val) => _emailVaidator(val),
                              style: TextStyle(fontSize: 18),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                suffixIcon: Icon(Icons.person_outline),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              readOnly: _isLoading,
                              controller: _passwordController,
                              validator: (val) => _passwordValidator(val),
                              maxLength: 12,
                              style: TextStyle(fontSize: 18),
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: Icon(Icons.vpn_key),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: FlatButton(
                                child: Text('Forgotten Password?'),
                                onPressed: null,
                              ),
                            ),
                            SizedBox(height: 10),
                            _isLoading
                                ? CircularProgressIndicator()
                                : SizedBox(
                                    height: screenSize.height * .055,
                                    width: screenSize.width * .5,
                                    child: RaisedButton(
                                      color: primaryColor,
                                      textColor: Colors.white,
                                      child: Text(
                                        'Login',
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      onPressed: loginUserIn,
                                    ),
                                  ),
                            SizedBox(height: screenSize.height * .03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Divider(
                                    color: Colors.black,
                                    height: 13,
                                  ),
                                ),
                                Text('    OR    '),
                                Expanded(
                                  child: Divider(
                                    color: Colors.black,
                                    height: 13,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenSize.height * .01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Login instead with Google',
                                  style: TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                    icon: Image.asset(
                                      'assets/images/google-logo.png',
                                      height: 25,
                                    ),
                                    onPressed: _isLoading
                                        ? null
                                        : loginUserInWithGoogle)
                              ],
                            ),
                            SizedBox(height: screenSize.height * .002),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Don't have an account? "),
                                FlatButton(
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: _isLoading
                                      ? null
                                      : () => Navigator.of(context)
                                          .pushNamed('/signup-screen'),
                                )
                              ],
                            ),
                            // SizedBox(height: screenSize.height * .001)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
