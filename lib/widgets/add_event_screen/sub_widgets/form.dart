import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:scout/models/event.dart';
import 'package:scout/models/space.dart';
import 'package:scout/widgets/add_space_screen/sub_widgets/map_dialog.dart';
import 'package:scout/widgets/show_error_dialog.dart';

class AdvertForm extends StatefulWidget {
  final Function confirmForm;

  AdvertForm({
    @required this.confirmForm,
  });

  @override
  _AdvertFormState createState() => _AdvertFormState();
}

class _AdvertFormState extends State<AdvertForm> {
  bool isSubmitting = false;
  bool isInit = true;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _price = TextEditingController(text: '0.0');
  TextEditingController _address = TextEditingController();
  TextEditingController _adName = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  String _selectedCity = 'Accra';
  DateTime pickedDate = DateTime.now();

  List<String> _cityNames = [
    'Accra',
    'Kumasi',
    'Cape Coast',
    'Sunyani',
    'Techiman',
    'Tamale',
    'Ho',
    'Koforidua',
    'Bolgatanga',
    'Wa',
    'Sekondi',
    'Sefwi Wiawso',
    'Damango',
    'Nalerigu',
    'Goaso',
    'Dambai',
  ];

  _phoneValidator(String val) {
    if (val.trim().length != 10) return 'Enter 10 digit phone number';
    if (int.tryParse(val) == null) return 'Enter correct phone number';
    return null;
  }

  _priceValidator(String val) {
    if (val.trim().length == 0) return 'Please enter a price';
    if (int.tryParse(val.trim()) == null && double.tryParse(val.trim()) == null)
      return 'Please enter valid amount';
    return null;
  }

  _adNameValidator(String val) {
    if (int.tryParse(val) != null) return 'Please enter a name';
    if (val.trim().length == 0) return 'Please enter name of space';
    if (val.trim().length < 4) return 'Seems too short to be a valid name';
    return null;
  }

  _descriptionValidator(String val) {
    if (int.tryParse(val) != null) return 'Please enter a description';
    if (val.trim().length == 0) return 'Please enter description of space';
    if (val.trim().length < 25) return 'Enter more than 25 characters';
    return null;
  }

  _gpAddressValidator(String val) {
    if (int.tryParse(val) != null) return 'Please enter a valid address';
    if (val.trim().length == 0) return 'Please enter an address';
    if (val.trim().length < 4) return 'Please enter a valid address';
    return null;
  }

  _selectCity({@required String city}) {
    setState(() => _selectedCity = city);
  }

  _pickTime() {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime(2021, 1, 1),
      onChanged: (date) {
        setState(() => pickedDate = date);
      },
      onConfirm: (date) {
        setState(() => pickedDate = date);
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  String capitalize(String str) {
    print(str);
    List<String> splitStr = str.toLowerCase().split(' ');
    for (var i = 0; i < splitStr.length; i++) {
      splitStr[i] = splitStr[i][0].toUpperCase() + splitStr[i].substring(1);
    }
    return splitStr.join(' ');
  }

  _submitForm() async {
    try {
      if (!_formKey.currentState.validate()) return;

      setState(() => isSubmitting = true);
      final space = Event(
        adName: capitalize(_adName.text),
        address: _address.text.toUpperCase(),
        city: _selectedCity,
        price: double.parse(_price.text),
        description: _description.text,
        eventDate: pickedDate,
        phoneNumber: _phoneController.text,
        advertiserId: null,
        advertistmentId: null,
        coverPhoto: null,
        creationDate: null,
        flyers: null,
      );

      widget.confirmForm(space);
    } catch (e) {
      print(e);
      print(e.runtimeType);
      setState(() => isSubmitting = false);
      ErrorDialog(context: context, error: e).showError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).accentColor;

    return Scrollbar(
      child: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Container(
              width: width * .95,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5, right: 5, top: 10, bottom: 0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                      height: height * .07,
                      child: TextFormField(
                        cursorColor: primaryColor,
                        readOnly: isSubmitting,
                        maxLength: 30,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 18, color: primaryColor),
                        controller: _adName,
                        validator: (val) => _adNameValidator(val),
                        decoration: InputDecoration(
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
                          labelText: 'Name of advertisment',
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 7,
                              horizontal: 5,
                            ),
                            height: height * .055,
                            child: DropdownButton(
                              style: TextStyle(
                                color: accentColor,
                                // backgroundColor: primaryColor,
                              ),
                              value: _selectedCity,
                              hint: Text('Select City'),
                              onChanged: (String cityName) =>
                                  _selectCity(city: cityName),
                              items: _cityNames.map((city) {
                                return DropdownMenuItem(
                                  child: Text(
                                    city,
                                    style: TextStyle(color: accentColor),
                                  ),
                                  value: city,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 7,
                              horizontal: 5,
                            ),
                            height: height * .07,
                            child: TextFormField(
                              cursorColor: primaryColor,
                              style: TextStyle(
                                fontSize: 18,
                                color: primaryColor,
                              ),
                              readOnly: isSubmitting,
                              maxLength: 10,
                              keyboardType: TextInputType.phone,
                              controller: _phoneController,
                              validator: (val) => _phoneValidator(val),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                // errorBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(color: Colors.yellow),
                                // ),
                                // errorStyle: TextStyle(color: Colors.yellow),
                                fillColor: Colors.white,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                ),
                                labelText: 'Advertiser Phone Number',
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Pick Date: ',
                            style: TextStyle(fontSize: width * .042),
                          ),
                          InkWell(
                              onTap: _pickTime,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    DateFormat.yMMMMEEEEd().format(pickedDate),
                                    style: TextStyle(
                                      fontSize: width * .044,
                                      color: primaryColor,
                                    ),
                                  ),
                                  SizedBox(width: width * .05),
                                  Text(
                                    'Time:  ',
                                    style: TextStyle(fontSize: width * .042),
                                  ),
                                  Text(
                                    DateFormat.Hm().format(pickedDate),
                                    style: TextStyle(
                                      fontSize: width * .044,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 7,
                              horizontal: 5,
                            ),
                            height: height * .07,
                            child: TextFormField(
                              cursorColor: primaryColor,
                              style:
                                  TextStyle(fontSize: 18, color: primaryColor),
                              readOnly: isSubmitting,
                              maxLength: 12,
                              keyboardType: TextInputType.text,
                              controller: _address,
                              validator: (val) => _gpAddressValidator(val),
                              decoration: InputDecoration(
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
                                labelText: 'Ghana Post Address',
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 7,
                              horizontal: 5,
                            ),
                            height: height * .07,
                            child: TextFormField(
                              cursorColor: primaryColor,
                              style:
                                  TextStyle(fontSize: 18, color: primaryColor),
                              readOnly: isSubmitting,
                              maxLength: 7,
                              keyboardType: TextInputType.number,
                              controller: _price,
                              validator: (val) => _priceValidator(val),
                              decoration: InputDecoration(
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
                                labelText: 'Price / ¢',
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 7,
                        horizontal: 5,
                      ),
                      height: height * .2,
                      child: TextFormField(
                        cursorColor: primaryColor,
                        style: TextStyle(fontSize: 18, color: primaryColor),
                        readOnly: isSubmitting,
                        maxLines: 7,
                        maxLength: 300,
                        keyboardType: TextInputType.text,
                        controller: _description,
                        validator: (val) => _descriptionValidator(val),
                        decoration: InputDecoration(
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
                          hintText:
                              "Description\nEg:\tJoin Us This December In Ghana For The Experience Of A Lifetime At Afrochella. A Festival Of Culture, Music, Art & Fashion. Buy Your Tickets Now! Buy your tickets now! A Festival of Culture. Experience Ghana! Year of Return 2019.",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * .01),
                    SizedBox(
                      height: height * .05,
                      width: width * .5,
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: _submitForm,
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: height * .01),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
