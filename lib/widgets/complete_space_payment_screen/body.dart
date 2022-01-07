import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:scout/custom_icons/custom_icons.dart';
import 'package:scout/models/payment.dart';
import 'package:scout/widgets/complete_space_payment_screen/completion_momo_card.dart';
import 'package:scout/widgets/show_error_dialog.dart';

class CompleteSpacePaymentBody extends StatefulWidget {
  final Payment payment;
  CompleteSpacePaymentBody({@required this.payment});

  @override
  _CompleteSpacePaymentBodyState createState() =>
      _CompleteSpacePaymentBodyState();
}

class _CompleteSpacePaymentBodyState extends State<CompleteSpacePaymentBody> {
  bool _isInit = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _phoneController = TextEditingController(text: '0');
  bool isLoading = false;

  @override
  didChangeDependencies() async {
    if (_isInit) {
      await FirebaseAuth.instance.currentUser().then((user) {
        setState(() {
          _phoneController =
              TextEditingController(text: '0${user.phoneNumber.substring(4)}');
        });
      }).catchError((e) {
        print(e);
      });

      _isInit = false;
    }
    super.didChangeDependencies();
  }

  _phoneValidator(String val) {
    print(val.substring(0, 3));
    print(widget.payment.method);
    if (widget.payment.method == PaymentMethod.TIGO) {
      if (val.substring(0, 3) != '027' && val.substring(0, 3) != '057')
        return 'Enter correct network code or switch to correct payment option';
    } else if (widget.payment.method == PaymentMethod.AIRTEL) {
      if (val.substring(0, 3) != '026' && val.substring(0, 3) != '056')
        return 'Enter correct network code or switch to correct payment option';
    } else if (widget.payment.method == PaymentMethod.VODAFONE) {
      if (val.substring(0, 3) != '020' && val.substring(0, 3) != '050')
        return 'Enter correct network code or switch to correct payment option';
    } else if (widget.payment.method == PaymentMethod.MTN) {
      if (val.substring(0, 3) != '024' &&
          val.substring(0, 3) != '054' &&
          val.substring(0, 3) != '055' &&
          val.substring(0, 3) != '059')
        return 'Enter correct network code or switch to correct payment option';
    }
    if (val.trim().length != 10) return 'Enter 10 digit phone number';
    if (int.tryParse(val) == null) return 'Enter correct phone number';
    return null;
  }

  _makePayment() async {
    try {
      if (!_formKey.currentState.validate()) return;
      setState(() => isLoading = true);
      await Future.delayed(Duration(seconds: 3));
      setState(() => isLoading = false);

      // final payment = Payment(
      //   creationDate: null,
      //   eventDate: widget.payment.eventDate,
      //   paymentId: null,
      //   requestId: null,
      //   spaceName: null,
      //   scoutId: null,
      //   scoutName: null,
      //   vendorId: null,
      //   vendorName: null,
      //   hours: null,
      //   maxCapacity: null,
      //   scoutPhotoUrl: null,
      //   vendorPhotoUrl: null,
      //   method: null,
      //   pricePerHour: null,
      // );
      // Provider.of<PaymentProvider>(context).makePayment(payment: payment);
    } catch (error) {
      print(error);
      setState(() => isLoading = false);
      ErrorDialog(context: context, error: error).showError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).accentColor;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final payment = widget.payment;

    return Column(
      children: <Widget>[
        if (payment.method == PaymentMethod.TIGO)
          Container(
            height: height * .35,
            width: width,
            color: primaryColor,
            padding: EdgeInsets.symmetric(
              horizontal: width * .05,
              vertical: height * .04,
            ),
            child: CompletionMomoCard(
              scoutName: payment.scoutName,
              phoneNumber: _phoneController.text,
              brandName: 'Tigo Cash',
              backgroundColor: Colors.white,
              brandColor: Color(0xFF01377a),
              logoPath: 'assets/images/cards/tigo-logo.png',
              prefix: '057',
            ),
          )
        else if (payment.method == PaymentMethod.AIRTEL)
          Container(
            height: height * .35,
            width: width,
            color: primaryColor,
            padding: EdgeInsets.symmetric(
              horizontal: width * .05,
              vertical: height * .04,
            ),
            child: CompletionMomoCard(
              scoutName: payment.scoutName,
              phoneNumber: _phoneController.text,
              brandName: 'Airtel Cash',
              backgroundColor: Colors.white,
              brandColor: Color(0xFFec1c24),
              logoPath: 'assets/images/cards/airtel-logo.png',
              prefix: '056',
            ),
          )
        else if (payment.method == PaymentMethod.VODAFONE)
          Container(
            height: height * .35,
            width: width,
            color: primaryColor,
            padding: EdgeInsets.symmetric(
              horizontal: width * .05,
              vertical: height * .04,
            ),
            child: CompletionMomoCard(
              scoutName: payment.scoutName,
              phoneNumber: _phoneController.text,
              brandName: 'Vodafone Cash',
              backgroundColor: Colors.white,
              brandColor: Color(0xFFe60000),
              logoPath: 'assets/images/cards/vodafone-logo-2.png',
              prefix: '050',
            ),
          )
        else if (payment.method == PaymentMethod.MTN)
          Container(
            height: height * .35,
            width: width,
            color: primaryColor,
            padding: EdgeInsets.symmetric(
              horizontal: width * .05,
              vertical: height * .04,
            ),
            child: CompletionMomoCard(
              scoutName: payment.scoutName,
              phoneNumber: _phoneController.text,
              brandName: 'Mtn Mobile Money',
              backgroundColor: Color(0xFFffcc00),
              brandColor: Colors.white,
              logoPath: 'assets/images/cards/mtn-logo.png',
              prefix: '054',
            ),
          ),
        // else if(payment.method == PaymentMethod.ATM)  ,

        Expanded(
          child: Container(
            color: Colors.white,
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: width * .05,
                      vertical: height * .03,
                    ),
                    height: height * .08,
                    child: TextFormField(
                      onChanged: (val) => setState(() => () {}),
                      cursorColor: primaryColor,
                      readOnly: isLoading,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(fontSize: 20, color: primaryColor),
                      controller: _phoneController,
                      validator: (val) => _phoneValidator(val),
                      decoration: InputDecoration(
                        prefixText: '+233   ',
                        prefixIcon: Icon(CustomIcons.phone),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: accentColor),
                        ),
                        labelText: 'MOBILE MONEY PHONE NUMBER',
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  //
                  Padding(
                    padding: EdgeInsets.only(left: width * .05),
                    child: Text(
                      'BOOKING SUMMARY',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width * .06,
                        color: accentColor,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Space Booking Fee',
                      style: TextStyle(
                        fontSize: width * .05,
                        color: accentColor,
                      ),
                    ),
                    subtitle: Text(
                      '¢ ${payment.pricePerHour} x ${payment.hours} hours',
                      style: TextStyle(
                        fontSize: width * .05,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Text(
                      '¢ ${payment.bookingFee}',
                      style: TextStyle(
                        fontSize: width * .05,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Processing Fee',
                      style: TextStyle(
                        fontSize: width * .05,
                        color: accentColor,
                      ),
                    ),
                    subtitle: Text(
                      '¢ ${payment.bookingFee} x 1%',
                      style: TextStyle(
                        fontSize: width * .05,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Text(
                      '¢ ${payment.bookProcessingFee}',
                      style: TextStyle(
                        fontSize: width * .05,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width * .06,
                        color: accentColor,
                      ),
                    ),
                    subtitle: Text(
                      '¢ ${payment.bookingFee} + ¢ ${payment.bookProcessingFee}',
                      style: TextStyle(
                        fontSize: width * .05,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Text(
                      '¢ ${payment.scoutTotal}',
                      style: TextStyle(
                        fontSize: width * .05,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: height * .01),
        isLoading
            ? CircularProgressIndicator()
            : SizedBox(
                height: height * .06,
                width: width * .6,
                child: RaisedButton(
                  color: primaryColor,
                  onPressed: () => _makePayment(),
                  child: Text(
                    'COMPLETE PAYMENT',
                    style: TextStyle(
                      fontSize: width * .05,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
        SizedBox(height: height * .01),
      ],
    );
  }
}
