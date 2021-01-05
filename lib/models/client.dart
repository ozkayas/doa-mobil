import 'package:flutter/material.dart';

class ClientData extends ChangeNotifier {
  final int userId;
  final String companyName;
  final double temperature;
  final double humidity;
  final List<Unit> units;

  ClientData(
      {this.userId,
      this.companyName,
      this.temperature,
      this.humidity,
      this.units});
}

class Unit {
  final int id;
  final bool isActive;
  final String type;
  final Map<String, dynamic> water;
  final Map<String, dynamic> fan;
  final Map<String, dynamic> light;

  Unit(
      {this.id,
      this.isActive,
      this.type,
      this.water = defaultMap,
      this.fan = defaultMap,
      this.light = defaultMap});
}

const Map<String, dynamic> defaultMap = {
  "monday": true,
  "tuesday": true,
  "wednesday": true,
  "thursday": false,
  "friday": true,
  "saturday": false,
  "sunday": true,
  "start_time": "12:20",
  "duration": 5
};
