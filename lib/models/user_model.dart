import 'package:flutter/material.dart';

/// Login Status korumak için SharedPref'te saklanan model

class User {
  String userName;
  String token;
  bool isLoggedIn;
  String deviceNotificationToken;

  User(
      {@required this.userName,
      @required this.token,
      this.isLoggedIn,
      this.deviceNotificationToken});

  Map<String, dynamic> toMap() => {
        'userName': userName,
        'token': token,
        'isLoggedIn': isLoggedIn,
        'deviceNotificationToken': deviceNotificationToken
      };

  static User fromMap(Map<String, dynamic> map) => User(
      userName: map['userName'],
      token: map['token'],
      isLoggedIn: map['isLoggedIn'],
      deviceNotificationToken: map['deviceNotificationToken']);
}
