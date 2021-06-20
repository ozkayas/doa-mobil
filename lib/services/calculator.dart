import 'package:flutter/material.dart';

class Calculator {
  static TimeOfDay createTimeOfDayFromInt(int minutes) {
    int trimmed = minutes % 1440;
    int m = trimmed % 60;
    int h = ((trimmed - m) / 60).round();
    return TimeOfDay(hour: h, minute: m);
  }

  static int createIntFromTimeOfDay(TimeOfDay timeOfDay) {
    return timeOfDay.hour * 60 + timeOfDay.minute;
  }

  static bool validateSelectedTimes(List<List<int>> schedule) {
    bool _isValid = true;

    for (var item in schedule) {
      if (item[0] > item[1]) {
        _isValid = false;
        break;
      }
    }

    return _isValid;
  }
}
