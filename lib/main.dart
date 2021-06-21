import 'package:cron/cron.dart';
import 'package:doa_1_0/services/api_service.dart';
import 'package:doa_1_0/services/constants.dart';
import 'package:doa_1_0/view_models/client_state_provider.dart';
import 'package:doa_1_0/views/device_page.dart';
import 'package:doa_1_0/views/home_page.dart';
import 'package:doa_1_0/views/landing_page.dart';
import 'package:doa_1_0/views/setting_fan.dart';
import 'package:doa_1_0/views/setting_light.dart';
import 'package:doa_1_0/views/setting_water.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'views/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
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
            DevicePage.routeName: (context) => DevicePage(),
            FanSettingPage.routeName: (context) => FanSettingPage(),
            WaterSettingPage.routeName: (context) => WaterSettingPage(),
            LightSettingPage.routeName: (context) => LightSettingPage(),
          }

          /// Routes tanımlı ancak ilk sayfa hariç kullanmaya gerek kalmadı, argüman taşımak basit yöntemle daha kolay
          ),
    );
  }
}
