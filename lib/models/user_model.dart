import 'package:flutter/material.dart';

/// Login Status korumak için SharedPref'te saklanan model

class User {
  String userName;
  String token;
  bool isLoggedIn;

  User({@required this.userName, @required this.token, this.isLoggedIn});

  Map<String, dynamic> toMap() =>
      {'userName': userName, 'token': token, 'isLoggedIn': isLoggedIn};

  static User fromMap(Map<String, dynamic> map) => User(
      userName: map['userName'],
      token: map['token'],
      isLoggedIn: map['isLoggedIn']);
}
