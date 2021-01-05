import './home_page.dart';
import './sign_in.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return _loggedIn ? HomePage() : SignInPage();
  }
}
