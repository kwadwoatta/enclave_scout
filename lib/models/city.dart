import 'package:flutter/material.dart';

class City {
  final String name;
  final List<Map<String, String>> photos;

  City({
    @required this.name,
    @required this.photos,
  });
}
