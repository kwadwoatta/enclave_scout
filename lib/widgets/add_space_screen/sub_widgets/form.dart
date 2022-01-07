import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:scout/models/space.dart';
import 'package:scout/widgets/add_space_screen/sub_widgets/map_dialog.dart';
import 'package:scout/widgets/show_error_dialog.dart';

class SpaceForm extends StatefulWidget {
  final Function confirmForm;

  SpaceForm({
    @required this.confirmForm,
  });

  @override
  _SpaceFormState createState() => _SpaceFormState();
}

class _SpaceFormState extends State<SpaceForm> {
  bool isSubmitting = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _minCapacity = TextEditingController();
  TextEditingController _maxCapacity = TextEditingController();
  TextEditingController _pricePerHour = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _placeName = TextEditingController();
  TextEditingController _washingRooms = TextEditingController();
  TextEditingController _parkingLots = TextEditingController();
  TextEditingController _description = TextEditingController();
  String _selectedCity = 'Accra';
  double _latitude;
  double _longitude;

  List<String> _cityNames = [
    'Accra',
    'Kumasi',
    // 'Cape Coast',
    // 'Sunyani',
    // 'Tamale',
  ];

  _minCapacityValidator(String val) {
    if (val.trim().length == 0) return 'Enter a minimum capacity';
    if (int.tryParse(val) == null) return 'Enter a valid number';
    return null;
  }

  _maxCapacityValidator(String val) {
    if (val.trim().length == 0) return 'Enter a maximum capacity';
    if (int.tryParse(val) == null) return 'Enter a valid number';
    return null;
  }

  _pricePerHourValidator(String val) {
    if (val.trim().length == 0) return 'Please enter a price';
    if (int.tryParse(val.trim()) == null && double.tryParse(val.trim()) == null)
      return 'Please enter valid amount';
    return null;
  }

  _washRoomValidator(String val) {
    if (val.trim().length == 0) return 'Please enter number';
    if (int.tryParse(val.trim()) == null && double.tryParse(val.trim()) == null)
      return 'Please enter valid number';
    return null;
  }

  _parkLotValidator(String val) {
    if (val.trim().length == 0) return 'Please enter number';
    if (int.tryParse(val.trim()) == null && double.tryParse(val.trim()) == null)
      return 'Please enter valid number';
    return null;
  }

  _spaceNameValidator(String val) {
    if (int.tryParse(val) != null) return 'Please enter a name';
    if (val.trim().length == 0) return 'Please enter name of space';
    if (val.trim().length < 4) return 'Seems too short to be a valid name';
    return null;
  }

  _descriptionValidator(String val) {
    if (int.tryParse(val) != null) return 'Please enter a description';
    if (val.trim().length == 0) return 'Please enter description of space';
    if (val.trim().length < 60) return 'Enter more than 60 characters';
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

  _selectCurrentLocation() async {
    try {
      ShowMapDialog(context: context, isDone: false);
      final currentLocation = await Location().getLocation();
      setState(() {
        _latitude = currentLocation.latitude;
        _longitude = currentLocation.longitude;
      });
      Navigator.of(context).pop();
      ShowMapDialog(
        context: context,
        isDone: true,
        latitude: _latitude,
        longitude: _longitude,
      );
      // Future.delayed(Duration(seconds: 10)).whenComplete(
      //   () => Navigator.of(context).pop(),
      // );
    } catch (e) {
      ErrorDialog(context: context, error: e).showError();
    }
  }

  String capitalize(String str) {
    // print(str);
    List<String> splitStr = str.toLowerCase().split(' ');
    for (var i = 0; i < splitStr.length; i++) {
      splitStr[i] = splitStr[i][0].toUpperCase() + splitStr[i].substring(1);
    }
    return splitStr.join(' ');
  }

  _submitForm() async {
    try {
      // FocusScopeNode currentFocus = FocusScope.of(context);

      // if (!currentFocus.hasPrimaryFocus) {
      //   currentFocus.unfocus();
      // }

      if (!_formKey.currentState.validate()) return;

      if (_longitude == null || _latitude == null) {
        return ErrorDialog(
          context: context,
          error: "Please click the location button to set location.",
        ).showError();
      }
      setState(() => isSubmitting = true);
      final user = await FirebaseAuth.instance.currentUser();
      // print(user.uid);
      final space = Space(
        name: capitalize(_placeName.text),
        address: _address.text.toUpperCase(),
        city: _selectedCity,
        price: double.parse(_pricePerHour.text),
        maxCapacity: int.parse(_maxCapacity.text),
        minCapacity: int.parse(_minCapacity.text),
        latitude: _latitude,
        longitude: _longitude,
        rating: 0,
        vendorImage: user.photoUrl,
        washroom: int.parse(_washingRooms.text),
        parkingLot: int.parse(_parkingLots.text),
        description: _description.text,
      );
      widget.confirmForm(space);
    } catch (e) {
      // print(e);
      // print(e.runtimeType);
      setState(() => isSubmitting = false);
      ErrorDialog(context: context, error: e).showError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
                        controller: _placeName,
                        validator: (val) => _spaceNameValidator(val),
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
                          labelText: 'Name of event space',
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
                                    // style: TextStyle(color: Colors.white),
                                  ),
                                  value: city,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: accentColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Lat:  ',
                                    ),
                                    TextSpan(
                                      text: _latitude != null
                                          ? NumberFormat('###.0#', 'en_US')
                                              .format(_latitude)
                                          : '--',
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: accentColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Lng:   ',
                                    ),
                                    TextSpan(
                                      text: _longitude != null
                                          ? NumberFormat('###.0#', 'en_US')
                                              .format(_longitude)
                                          : '--',
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add_location),
                                onPressed: _selectCurrentLocation,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 5),
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
                                  // borderSide: BorderSide(color: Color(0xFFf1f0ee)),
                                  borderSide: BorderSide(color: accentColor),
                                ),
                                labelText: 'Ghana Post Address',
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: primaryColor,
                                ),
                                // border: OutlineInputBorder(),
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
                              controller: _pricePerHour,
                              validator: (val) => _pricePerHourValidator(val),
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
                                labelText: 'Price per Hour / ¢',
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: primaryColor,
                                ),
                                // border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 5),
                            height: height * .07,
                            child: TextFormField(
                              cursorColor: primaryColor,
                              style:
                                  TextStyle(fontSize: 18, color: primaryColor),
                              readOnly: isSubmitting,
                              maxLength: 7,
                              keyboardType: TextInputType.number,
                              controller: _minCapacity,
                              validator: (val) => _minCapacityValidator(val),
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
                                  // borderSide: BorderSide(color: Color(0xFFf1f0ee)),
                                  borderSide: BorderSide(color: accentColor),
                                ),
                                labelText: 'Minimum Capacity',
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: primaryColor,
                                ),
                                // border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 5),
                            height: height * .07,
                            child: TextFormField(
                              cursorColor: primaryColor,
                              style:
                                  TextStyle(fontSize: 18, color: primaryColor),
                              readOnly: isSubmitting,
                              keyboardType: TextInputType.number,
                              maxLength: 7,
                              controller: _maxCapacity,
                              validator: (val) => _maxCapacityValidator(val),
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
                                labelText: 'Maximum Capacity',
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: primaryColor,
                                ),
                                // border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 5),
                            height: height * .07,
                            child: TextFormField(
                              cursorColor: primaryColor,
                              style:
                                  TextStyle(fontSize: 18, color: primaryColor),
                              readOnly: isSubmitting,
                              maxLength: 2,
                              keyboardType: TextInputType.number,
                              controller: _washingRooms,
                              validator: (val) => _washRoomValidator(val),
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
                                labelText: 'Number of washrooms',
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: primaryColor,
                                ),
                                // border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 5),
                            height: height * .07,
                            child: TextFormField(
                              cursorColor: primaryColor,
                              style:
                                  TextStyle(fontSize: 18, color: primaryColor),
                              readOnly: isSubmitting,
                              keyboardType: TextInputType.number,
                              maxLength: 2,
                              controller: _parkingLots,
                              validator: (val) => _parkLotValidator(val),
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
                                labelText: 'Number of parking lots',
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: primaryColor,
                                ),
                                // border: OutlineInputBorder(),
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
                              "Description\nEg:\tFeatures state-of-the-art fiber optic, power, lighting, and rigging support, comfortable KAISER LD-8612 premium theater seating, magnificent interior decorations and a tropical outdoor patio for dining. Our toilets are also neatly cleaned every two hours. Our venue is perfect for conferences, concerts and exhibits. ",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: primaryColor,
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
