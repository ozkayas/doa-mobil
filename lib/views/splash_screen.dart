import 'package:cron/cron.dart';
import 'package:doa_1_0/view_models/client_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import './landing_page.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    //Provider.of<ClientState>(context, listen: false).getClientDataFromApi();
    return Center(
      child: SplashOne(),
    );
  }
}

class SplashOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 1,
        navigateAfterSeconds: LandingPage(),
        image: Image.asset('assets/logo_ver2.png'),
        backgroundColor: Colors.white,
        useLoader: false,
        photoSize: 100.0,
        loaderColor: Colors.green[800]);
  }
}

class SplashTwo extends StatelessWidget {
  const SplashTwo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Provider.of<ClientState>(context).getClientDataFromApi();
    return SplashScreen(
        seconds: 1,
        navigateAfterSeconds: LandingPage(),
        image: Image.asset('assets/doa_logo.png'),
        backgroundColor: Colors.white,
        useLoader: true,
        photoSize: 100.0,
        loadingText: Text('''Kullanıcı bilgileri alınıyor
        Lütfen Bekleyiniz'''),
        loaderColor: Colors.green[800]);
  }
}
