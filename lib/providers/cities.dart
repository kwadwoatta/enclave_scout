import 'package:flutter/material.dart';
import 'package:scout/services/cityManagement.dart';

class CitiesProvider with ChangeNotifier {
  List _cityImages;
  bool _isInit = true;
  final citiesManagement = CitiesManagement();

  static List<String> images = [
    'https://pbs.twimg.com/media/EE9sDOiWkAAc0qn.jpg',
    'https://pbs.twimg.com/media/EFy1jGkWoAEwhav.jpg',
    'https://pbs.twimg.com/media/D-tFLafXYAAumg4.jpg',
    'https://pbs.twimg.com/media/D-tFLacXkAMGR3E.jpg',
    'https://culartblog.files.wordpress.com/2015/08/poets1.jpg',
    'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
  ];

  get cityImages {
    return [..._cityImages];
  }

  // set user data
  // addToEvents({
  //   @required String uid,
  //   @required String advertId,
  //   @required String phoneNumber,
  //   @required String coverPhoto,
  //   @required DateTime date,
  //   @required String description,
  //   @required List<String> flyers,
  //   @required String name,
  //   @required double price,
  // }) {
  //   final event = Event(
  //     advertiserId: uid,
  //     advertistmentId: advertId,
  //     coverPhoto: coverPhoto,
  //     date: date,
  //     description: description,
  //     flyers: flyers,
  //     adName: name,
  //     phoneNumber: phoneNumber,
  //     price: price,
  //   );
  //   _cityImages.add(event);
  //   notifyListeners();
  // }

  Future<void> fetchAndSetCityImages() async {
    try {
      if (_isInit) {
        final cities = await citiesManagement.initGetData();
        if (cities != null) {
          for (var city in cities) {
            city.data.forEach((key, value) {
              print('key');
              print(key);
              print('value');
              print(value);
            });
            print('city.data');
            print(city.data);
          }
          // print(cityImages.asMap());
          // cityImages.asMap().forEach((key, values) {
          //   print('----------------------');
          //   print(values.data);
          //   print('----------------------');
          //   // addToEvents(
          //   //   advertId: key,
          //   //   uid: values['advertiserId'],
          //   //   phoneNumber: values['phoneNumber'],
          //   //   coverPhoto: values['coverPhoto'],
          //   //   date: values['date'],
          //   //   description: values['description'],
          //   //   flyers: values['flyers'],
          //   //   name: values['advertismentName'],
          //   //   price: values['price'],
          //   // );
          // });
          _isInit = false;
        }
      }
    } catch (error) {
      throw error;
    }
  }
}
