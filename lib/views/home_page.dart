import 'dart:async';

import 'package:doa_1_0/models/client_model.dart';
import 'package:doa_1_0/services/constants.dart';
import 'package:doa_1_0/view_models/client_state_provider.dart';
import 'package:doa_1_0/views/device_page.dart';
import 'package:doa_1_0/views/landing_page.dart';
import 'package:doa_1_0/widgets/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/homePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer timer;
  bool isLoading;
  final TextStyle _infoTextStyle =
      TextStyle(fontSize: 20, color: Colors.black54);

  @override
  void initState() {
    super.initState();
    isLoading = false;
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      //print("Timer triggered");
      Provider.of<ClientState>(context, listen: false).getClientDataFromApi();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _imageWidth = MediaQuery.of(context).size.width * 0.5;

    return Consumer<ClientState>(
      builder: (BuildContext context, _clientState, Widget child) {
        print("HomePage Consumer build etti");
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          appBar: _buildAppBar(context),
          body: FutureBuilder<bool>(
            future: _clientState.getClientDataFromApi(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                        'Bir Hata Oluştu, Lütfen Uygulamayı Tekrar Çalıştırın'));
              }
              if (snapshot.hasData) {
                return Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset(
                          'assets/logo_ver2.png',
                          width: _imageWidth,
                        ),
                      ),
                      Text(
                        '${_clientState.locationName}',
                        style: _infoTextStyle,
                      ),
                      SizedBox(height: 20.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _clientState.units.length,
                          itemBuilder: (BuildContext context, int index) =>
                              _buildCard2(
                                  index: index,
                                  unit: _clientState.units[index],
                                  context: context),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                        ),
                      ),
                      //Spacer(),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 30),
                      Text('Lütfen Bekleyiniz'),
                      Text('Cihaz Bilgileri Getiriliyor')
                    ],
                  ),
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: Constants.mainGreen,
              onPressed: () async {
                await context.read<ClientState>().getClientDataFromApi();
              },
              child: Icon(
                Icons.refresh_rounded,
                size: 34,
              )),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
            onPressed: () async {
              var response = await showConfirmLogoutDialog(context);
              if (response) {
                Provider.of<ClientState>(context, listen: false)
                    .setLoggedIn(false);

                Navigator.pushReplacementNamed(
                  context,
                  LandingPage.routeName,
                );
              }
            },
            icon: Icon(Icons.logout, size: 30),
            color: Colors.black45,
          ),
        )
      ],
    );
  }

  Widget _buildCard({Unit unit, int index, BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 2),
      child: GestureDetector(
        onTap: isLoading
            ? null
            : () async {
                setState(() {
                  isLoading = false;
                });
                try {
                  Unit _unit =
                      await Provider.of<ClientState>(context, listen: false)
                          .getUnitDataFromApi(unitId: unit.unitId)
                          .timeout(Duration(seconds: 5));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DevicePage(
                        unitId: unit.unitId,
                        wateringOn: _unit.wateringOn,
                        fanOn: _unit.fanOn,
                        lightingOn: _unit.lightingOn,
                      ),
                    ),
                  );
                } on TimeoutException catch (e) {
                  setState(() {
                    isLoading = true;
                  });
                }
              },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: unit.isActive ? Colors.green[50] : Colors.red[50],
          child: ListTile(
            leading: unit.isActive
                ? Icon(Icons.wb_sunny, color: Colors.green)
                : Icon(Icons.warning, color: Colors.red),
            title: isLoading
                ? Text('Ünite verisi okunuyor')
                : Text('Ünite ${unit.unitId}'),
            //subtitle: isActive ? Text('Aktif') : Text('Çalışmıyor'),
          ),
        ),
      ),
    );
  }

  Widget _buildCard2({Unit unit, int index, BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 2),
      child: GestureDetector(
        onTap: isLoading
            ? null
            : () async {
                setState(() {
                  isLoading = false;
                });
                try {
                  Unit _unit =
                      await Provider.of<ClientState>(context, listen: false)
                          .getUnitDataFromApi(unitId: unit.unitId)
                          .timeout(Duration(seconds: 5));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DevicePage(
                        unitId: unit.unitId,
                        wateringOn: _unit.wateringOn,
                        fanOn: _unit.fanOn,
                        lightingOn: _unit.lightingOn,
                      ),
                    ),
                  );
                } on TimeoutException catch (e) {
                  setState(() {
                    isLoading = true;
                  });
                }
              },
        child: Card(
          elevation: unit.isActive ? 3 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: (unit.isActive == false)
              ? Colors.grey.shade200
              : unit.waterLevelOk
                  ? Colors.white
                  : Colors.red.shade100,
          child: ListTile(
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              (!unit.waterLevelOk)
                  ? Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                    )
                  : Container(),
              SizedBox(
                width: 5,
              ),
              ImageIcon(
                AssetImage('assets/fan_icon.jpg'),
                color: unit.fanOn ? Colors.lightGreen : Colors.grey,
                size: 20,
              ),
              SizedBox(
                width: 5,
              ),
              ImageIcon(
                AssetImage('assets/light_icon.jpg'),
                color: unit.lightingOn ? Colors.lightGreen : Colors.grey,
                size: 20,
              ),
            ]),
            title: isLoading
                ? Text('Ünite verisi okunuyor')
                : Text('Ünite ${unit.unitId}'),
            subtitle: (!unit.isActive)
                ? Text('Cihaz Bağlantı Hatası')
                : unit.waterLevelOk
                    ? Text('')
                    : Text('Kritik Su Seviyesi'),
          ),
        ),
      ),
    );
  }
}
