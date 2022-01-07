import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';

class ErrorDialog {
  final BuildContext context;
  final error;
  ErrorDialog({@required this.context, @required this.error});

  String printStatement;

  showError() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      printStatement = "Your device is not connected to any network";
      _showErrorDialog();
    } else {
      switch (error.runtimeType) {
        case HttpException:
          printStatement = error.message.toString();
          break;
        case NetworkImageLoadException:
          printStatement = "Error loading ${error.uri.path}";
          break;
        case CloudFunctionsException:
          printStatement = error.message.toString();
          break;
        case PlatformException:
          printStatement = error.message.toString();
          break;
        // case AbstractClassInstantiationError:
        //   printStatement = error.stackTrace.toString();
        //   break;
        // case AssertionError:
        //   printStatement = error.message.toString();
        //   break;
        // case CastError:
        //   printStatement = error.stackTrace.toString();
        //   break;
        // case AbstractClassInstantiationError:
        //   printStatement = error.stackTrace.toString();
        //   break;
        // case FormatException:
        //   printStatement = error.message.toString();
        //   break;
        // case IOException:
        //   printStatement = error.runtimeType.toString();
        //   break;
        // case IntegerDivisionByZeroException:
        //   printStatement = error.runtimeType.toString();
        // break;
        case SignalException:
          printStatement = error.message.toString();
          printStatement = error.osError.toString();
          break;
        case NetworkImageLoadException:
          printStatement = error.uri.toString();
          printStatement = error.statusCode.toString();
          break;
        case HandshakeException:
          printStatement = error.message.toString();
          // printStatement = error.osError.toString();
          // printStatement = error.type.toString();
          break;
        case ArgumentError:
          printStatement = error.message.toString();
          break;
        case String:
          printStatement = error;
          // printStatement = error.name.toString();
          // printStatement = error.invalidValue.toString();
          break;
        // case Exception:
        //   printStatement = error.toString();
        //   break;
        default:
          {
            printStatement = "Sorry, an error occurred.";
          }
      }
      _showErrorDialog();
    }
  }

  _showErrorDialog() {
    showDialog(
      context: context,
      builder: ((context) {
        final screenSize = MediaQuery.of(context).size;

        return Dialog(
          backgroundColor: Colors.red,
          // elevation: 5,
          child: Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            height: screenSize.height * .12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  printStatement,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenSize.width * .04,
                  ),
                ),
                SizedBox(height: screenSize.height * .015),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: screenSize.width * .15,
                    height: screenSize.height * .032,
                    child: RaisedButton(
                      color: Colors.white,
                      textColor: Colors.red,
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: screenSize.width * .03,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  // InkWell(
                  //   child: Text(
                  //     'OK',
                  //     style: TextStyle(
                  //       color: Colors.black,
                  //       fontSize: screenSize.width * .05,
                  //     ),
                  //   ),
                  //   onTap: () => Navigator.of(context).pop(),
                  // ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

// AbstractClassInstantiationError
// ArgumentError
// AssertionError
// CastError
// ConcurrentModificationError
// CyclicInitializationError
// Error
// Exception
// FallThroughError
// FormatException
// IndexError
// IntegerDivisionByZeroException
// LateInitializationError
// NoSuchMethodError
// NullThrownError
// OutOfMemoryError
// RangeError
// StackOverflowError
// StateError
// TypeError
// UnimplementedError
// UnsupportedError
// DeferredLoadException
// FirebaseApiNotAvailableException, FirebaseAppIndexingException, FirebaseAuthException, FirebaseFirestoreException, FirebaseNetworkException, FirebaseRemoteConfigException, FirebaseTooManyRequestsException, StorageException,
