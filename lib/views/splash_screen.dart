import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splashscreen/splashscreen.dart';

import './landing_page.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SplashScreen(
          seconds: 3,
          navigateAfterSeconds: LandingPage(),
          title: Text('Yaşatan Tazelik',
              style: GoogleFonts.courgette(fontSize: 20.0)),
          image: Image.asset('assets/doa_logo.png'),
          backgroundColor: Colors.white,
          useLoader: false,
          photoSize: 100.0,
          loaderColor: Colors.green[800]),
    );
  }
}
