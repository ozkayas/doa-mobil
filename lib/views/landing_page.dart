import 'package:doa_1_0/models/user_model.dart';
import '../view_models/client_state_provider.dart';
import 'package:provider/provider.dart';
import './home_page.dart';
import './sign_in.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  static String routeName = '/landinPage';
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    /*final Future<bool> _future =
        Provider.of<ClientState>(context, listen: false)
            .getLoginStatusFromDevice();*/
    final Future<User> _future =
        Provider.of<ClientState>(context, listen: false)
            .getUserStatusFromDevice();

    return FutureBuilder<User>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.isLoggedIn ? HomePage() : SignInPage();
          } else {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('Kullanıcı Bilgileri Okunuyor, Lütfen Bekleyiniz')
                  ],
                ),
              ),
            );
          }
        });
  }
}
