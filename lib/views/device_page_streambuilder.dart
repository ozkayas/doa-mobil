import 'package:doa_1_0/models/client_model.dart';
import 'package:doa_1_0/services/calculator.dart';
import 'package:doa_1_0/services/constants.dart';
import 'package:doa_1_0/view_models/client_state_provider.dart';
import 'package:doa_1_0/views/setting_fan.dart';
import 'package:doa_1_0/views/setting_light.dart';
import 'package:doa_1_0/widgets/alert_dialogs.dart';
import 'package:doa_1_0/widgets/toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DevicePageStream extends StatefulWidget {
  static String routeName = '/devicePage';
  final String unitId;
  DevicePageStream({this.unitId});

  @override
  _DevicePageStreamState createState() => _DevicePageStreamState();
}

class _DevicePageStreamState extends State<DevicePageStream> {
  //Stream<Client> _stream;

  @override
  void initState() {
    super.initState();
    Unit _unit = Provider.of<ClientState>(context, listen: false)
        .units
        .firstWhere((element) => element.unitId == widget.unitId);
    /* _stream =
        Provider.of<ClientState>(context, listen: false).postsController.stream;*/
    if (!_unit.waterLevelOk) {
      showWaterLevelDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Provider.of<ClientState>(context, listen: false)
            .getClientDataFromApi();
        Navigator.pop(context);
        return false;
      },
      child: StreamBuilder<Client>(
          stream: Provider.of<ClientState>(context, listen: false)
              .postsController
              .stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child:
                    Text("Bir Hata Oluştu, Lütfen daha sonra tekrar deneyiniz"),
              );
            } else if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              var _unit = snapshot.data.units
                  .firstWhere((unit) => unit.unitId == widget.unitId);
              return Scaffold(
                  appBar: _buildAppBar(context, _unit),
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 12, 0),
                      child: Column(
                        children: [
                          //_buildLogo(_imageWidth),
                          SizedBox(
                            height: 10,
                          ),
                          _buildDeviceSummary(_unit, context),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildWateringCard(context, _unit),
                                  Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 16,
                                          child: _buildFanCard(context, _unit)),
                                      Expanded(
                                        flex: 3,
                                        child: ToggleSwitch(
                                            status: _unit.fanOn,
                                            unitId: widget.unitId,
                                            toggleType: 2),
                                      )
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 16,
                                          child: _buildLightingCard(
                                              context, _unit)),
                                      Expanded(
                                        flex: 3,
                                        child: ToggleSwitch(
                                          status: _unit.lightingOn,
                                          toggleType: 3,
                                          unitId: widget.unitId,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider()
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
            }
          }),
    );
  }

  Widget _buildDeviceSummary(Unit _unit, BuildContext context) {
    final double _imageWidth = MediaQuery.of(context).size.width * 0.3;

    return Row(
      // Cihaz imajı ve sıcaklık bilgilerinin içeren Row
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
            width: _imageWidth, child: Image.asset('assets/doa_unit_1.png')),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _unit.waterLevelOk
                ? Text('Su Seviyesi: Uygun',
                    style: Theme.of(context).textTheme.subtitle1)
                : Text('Su Seviyesi: Kritik',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.red)),
            Text('Sıcaklık: ${_unit.temperature} °C',
                style: Theme.of(context).textTheme.subtitle1),
            Text('Nem: ${_unit.humidity} %',
                style: Theme.of(context).textTheme.subtitle1),
          ],
        ),
      ],
    );
  }
/*
  Widget _buildLogo(double _imageWidth) {
    return Image.asset(
      'assets/logo_ver2.png',
      width: _imageWidth,
    );
  }*/

  AppBar _buildAppBar(BuildContext context, Unit _unit) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Constants.mainGreen,
      title:
          Text('Ünite ${_unit.unitId}', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildWateringCard(BuildContext context, Unit unit) {
    final localizations = MaterialLocalizations.of(context);
    String startTime = localizations.formatTimeOfDay(
        Calculator.createTimeOfDayFromInt(unit.watering[0].startTimeA),
        alwaysUse24HourFormat: true);
    String endTime = localizations.formatTimeOfDay(
        Calculator.createTimeOfDayFromInt(unit.watering[0].endTimeA),
        alwaysUse24HourFormat: true);

    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(right: 2),
        child: ImageIcon(
          AssetImage('assets/watering_icon.jpg'),
          color: Colors.green[700],
          size: 30,
        ),
      ),
      title: Text('SULAMA', style: Theme.of(context).textTheme.headline6),
      subtitle: Text('$startTime - $endTime'),
    );
  }

  Widget _buildFanCard(BuildContext context, Unit unit) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FanSettingPage(
              unitId: unit.unitId,
            ),
          ),
        );
      },
      leading: Padding(
        padding: const EdgeInsets.only(right: 2),
        child: ImageIcon(
          AssetImage('assets/fan_icon.jpg'),
          color: Colors.green[700],
          size: 30,
        ),
      ),
      title: Text('FAN', style: Theme.of(context).textTheme.headline6),
      subtitle: _buildDayButtons(unit.fan),
    );
  }

  Widget _buildLightingCard(BuildContext context, Unit unit) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LightSettingPage(
              unitId: unit.unitId,
            ),
          ),
        );
      },
      leading: Padding(
        padding: const EdgeInsets.only(right: 2),
        child: ImageIcon(
          AssetImage('assets/light_icon.jpg'),
          color: Colors.green[700],
          size: 30,
        ),
      ),
      title: Text('AYDINLATMA', style: Theme.of(context).textTheme.headline6),
      subtitle: _buildDayButtons(unit.lighting),
    );
  }

  Widget _buildDayButtons(List<Timing> timings) {
    double radius = 12;
    List<String> _weekDays = ['Pt', 'S', 'Ç', 'P', 'C', 'Ct', 'P'];
    return Container(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _weekDays.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
              BoxShadow(
                  blurRadius: 2,
                  color: Colors.black45,
                  offset: Offset(2, 2),
                  spreadRadius: 1)
            ]),
            child: CircleAvatar(
              radius: radius,
              backgroundColor: timings[index].isActive
                  ? Colors.lightGreen
                  : Colors.redAccent,
              child:
                  Text(_weekDays[index], style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}
