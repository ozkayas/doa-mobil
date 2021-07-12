import 'package:doa_1_0/services/constants.dart';
import 'package:doa_1_0/view_models/client_state_provider.dart';
import 'package:doa_1_0/views/device_page_streambuilder.dart';
import 'package:doa_1_0/views/home_page.dart';
import 'package:doa_1_0/views/landing_page.dart';
import 'package:doa_1_0/views/setting_fan.dart';
import 'package:doa_1_0/views/setting_light.dart';
import 'package:doa_1_0/views/setting_water.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  var token = await messaging.getToken();
  print(token);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClientState>(
      create: (context) => ClientState(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DOA',
          theme: ThemeData(
            buttonColor: Constants.mainGreen,
            primarySwatch: Colors.green,
          ),
          //home: Splash(),
          initialRoute: '/',
          routes: {
            '/': (context) => Splash(),
            HomePage.routeName: (context) => HomePage(),
            LandingPage.routeName: (context) => LandingPage(),
            DevicePageStream.routeName: (context) => DevicePageStream(),
            FanSettingPage.routeName: (context) => FanSettingPage(),
            WaterSettingPage.routeName: (context) => WaterSettingPage(),
            LightSettingPage.routeName: (context) => LightSettingPage(),
          }

          /// Routes tanımlı ancak ilk sayfa hariç kullanmaya gerek kalmadı, argüman taşımak basit yöntemle daha kolay
          ),
    );
  }
}
