import 'dart:async';
import 'dart:ui';

import 'package:doa_1_0/models/client_model.dart';
import 'package:doa_1_0/services/constants.dart';
import 'package:doa_1_0/view_models/client_state_provider.dart';
import 'package:doa_1_0/views/device_page.dart';
import 'package:doa_1_0/views/device_page_streambuilder.dart';
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
  bool showFAB = true;
  bool _isSnackbarActive = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Timer timer;
  Future _future;
  bool isLoading = false;
  final TextStyle _infoTextStyle =
      TextStyle(fontSize: 20, color: Colors.black54);

  @override
  void initState() {
    super.initState();
    isLoading = false;
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) {
      Provider.of<ClientState>(context, listen: false).getClientDataFromApi();
    });
  }

  @override
  void didChangeDependencies() {
    _future =
        Provider.of<ClientState>(context, listen: false).getClientDataFromApi();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _imageWidth = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      key: scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: _buildAppBar(context),
      body: FutureBuilder<bool>(
        future: _future,
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
                    '${Provider.of<ClientState>(context).locationName}',
                    style: _infoTextStyle,
                  ),
                  SizedBox(height: 20.0),
                  Expanded(
                    child: StreamBuilder<Client>(
                        stream: Provider.of<ClientState>(context)
                            .postsController
                            .stream,
                        builder: (context, snapshot) {
                          return (snapshot.hasError)
                              ? Center(
                                  child: Text(
                                      "Bir Hata Oluştu, Lütfen daha sonra tekrar deneyiniz"),
                                )
                              : (!snapshot.hasData)
                                  ? Center(child: CircularProgressIndicator())
                                  : ListView.builder(
                                      itemCount: snapshot.data.units.length,
                                      itemBuilder: (BuildContext context,
                                              int index) =>
                                          _buildCard(
                                              index: index,
                                              unit: snapshot.data.units[index],
                                              context: context),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                    );
                        }),
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
      floatingActionButton: !_isSnackbarActive
          ? FloatingActionButton(
              backgroundColor: Constants.mainGreen,
              onPressed: () async {
                if (!_isSnackbarActive) {
                  showSnack();
                  await context.read<ClientState>().getClientDataFromApi();
                }
              },
              child: Icon(
                Icons.refresh_rounded,
                size: 34,
              ))
          : null,
    );
  }

  showSnack() {
    setState(() {
      _isSnackbarActive = true;
    });
    return ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            //animation: Animation,
            backgroundColor: Constants.mainGreen.withOpacity(0.5),
            content: const Text(
              'Veriler Güncelleniyor',
              textAlign: TextAlign.center,
            ),
            //behavior: SnackBarBehavior.floating,
          ),
        )
        .closed
        .then((SnackBarClosedReason reason) {
      // snackbar is now closed.
      setState(() {
        _isSnackbarActive = false;
      });
    });
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
                /*setState(() {
                  isLoading = true;
                });*/
                try {
                  Unit _unit =
                      await Provider.of<ClientState>(context, listen: false)
                          .getUnitDataFromApi(unitId: unit.unitId)
                          .timeout(Duration(seconds: 5));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DevicePageStream(
                        unitId: unit.unitId,
                      ),
                    ),
                  );
                } on TimeoutException catch (e) {
                  /*   setState(() {
                    isLoading = false;
                  });*/
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
