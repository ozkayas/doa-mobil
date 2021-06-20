import 'package:doa_1_0/models/client_model.dart';
import 'package:doa_1_0/view_models/client_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaterSettingPage extends StatefulWidget {
  static String routeName = '/settingsWaterPage';

  final int unitId;
  WaterSettingPage({this.unitId});
  @override
  _WaterSettingPageState createState() => _WaterSettingPageState();
}

class _WaterSettingPageState extends State<WaterSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sulama Takvimi')),
      body: BodyContainer(
        unitId: widget.unitId,
      ),

      /// metotları test etmek için kullanıyorum
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var list = Provider.of<ClientState>(context, listen: false)
              .getWaterSchedule(widget.unitId);
          print(list);
        },
      ),
    );
  }
}

class BodyContainer extends StatefulWidget {
  final int unitId;
  BodyContainer({this.unitId});

  @override
  _BodyContainerState createState() => _BodyContainerState();
}

class _BodyContainerState extends State<BodyContainer> {
  Unit _unit;
  List<List<int>> _waterSchedule;
  List<String> _days = ['Pt', 'S', 'Ç', 'P', 'C', 'Ct', 'P'];

  TimeOfDay _createTimeOfDayFromInt(int minutes) {
    int trimmed = minutes % 1440;
    int m = trimmed % 60;
    int h = ((trimmed - m) / 60).round();
    return TimeOfDay(hour: h, minute: m);
  }

  int _createIntFromTimeOfDay(TimeOfDay timeOfDay) {
    return timeOfDay.hour * 60 + timeOfDay.minute;
  }

  /// InıtState içerisinde hangi ünite olduğunu çekiyoruz
  @override
  void initState() {
    _unit = Provider.of<ClientState>(context, listen: false)
        .units
        .firstWhere((element) => element.unitId == widget.unitId);
    _waterSchedule = Provider.of<ClientState>(context, listen: false)
        .getWaterSchedule(widget.unitId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            buildScheduleRow(dayNo: 0),
            SizedBox(height: 10),
            buildScheduleRow(dayNo: 1),
            SizedBox(height: 10),
            buildScheduleRow(dayNo: 2),
            SizedBox(height: 10),
            buildScheduleRow(dayNo: 3),
            SizedBox(height: 10),
            buildScheduleRow(dayNo: 4),
            SizedBox(height: 10),
            buildScheduleRow(dayNo: 5),
            SizedBox(height: 10),
            buildScheduleRow(dayNo: 6),
            SizedBox(height: 30),
            ElevatedButton(onPressed: () {}, child: Text('Takvimi Kaydet'))
          ],
        ),
      ),
    );
  }

  Row buildScheduleRow({int dayNo}) {
    final localizations = MaterialLocalizations.of(context);
    double _circleAvatarRadius = 30.0;
    return Row(
      children: [
        CircleAvatar(
          radius: _circleAvatarRadius,
          backgroundColor: _unit.watering[dayNo].isActive
              ? Colors.lightGreen
              : Colors.redAccent,
          child: Text(_days[dayNo],
              style: TextStyle(color: Colors.white, fontSize: 25)),
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                  padding: const EdgeInsets.all(4.0), child: Text('Başla:')),
            ),
            Container(
              child: Padding(
                  padding: const EdgeInsets.all(4.0), child: Text('Bitir:')),
            )
          ],
        ),
        Column(
          children: [
            GestureDetector(
              onTap: _waterSchedule[dayNo][0] < 0
                  ? null
                  : () async {
                      var _selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: 0, minute: 0),
                        builder: (BuildContext context, Widget child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child,
                          );
                        },
                      );
                      int minutes = _createIntFromTimeOfDay(_selectedTime);
                      setState(() {
                        _waterSchedule[dayNo][0] = minutes;
                      });
                    },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    localizations.formatTimeOfDay(
                        _createTimeOfDayFromInt(_waterSchedule[dayNo][0]),
                        alwaysUse24HourFormat: true),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                var _selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: 0, minute: 0),
                  builder: (BuildContext context, Widget child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child,
                    );
                  },
                );
                int minutes = _createIntFromTimeOfDay(_selectedTime);
                setState(() {
                  _waterSchedule[dayNo][1] = minutes;
                });
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    localizations.formatTimeOfDay(
                        _createTimeOfDayFromInt(_waterSchedule[dayNo][1]),
                        alwaysUse24HourFormat: true),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () async {
                var _selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: 0, minute: 0),
                  builder: (BuildContext context, Widget child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child,
                    );
                  },
                );
                int minutes = _createIntFromTimeOfDay(_selectedTime);
                setState(() {
                  _waterSchedule[dayNo][2] = minutes;
                });
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    localizations.formatTimeOfDay(
                        _createTimeOfDayFromInt(_waterSchedule[dayNo][2]),
                        alwaysUse24HourFormat: true),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                var _selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: 0, minute: 0),
                  builder: (BuildContext context, Widget child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child,
                    );
                  },
                );
                int minutes = _createIntFromTimeOfDay(_selectedTime);
                setState(() {
                  _waterSchedule[dayNo][3] = minutes;
                });
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    localizations.formatTimeOfDay(
                        _createTimeOfDayFromInt(_waterSchedule[dayNo][3]),
                        alwaysUse24HourFormat: true),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () async {
                var _selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: 0, minute: 0),
                  builder: (BuildContext context, Widget child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child,
                    );
                  },
                );
                int minutes = _createIntFromTimeOfDay(_selectedTime);
                setState(() {
                  _waterSchedule[dayNo][4] = minutes;
                });
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    localizations.formatTimeOfDay(
                        _createTimeOfDayFromInt(_waterSchedule[dayNo][4]),
                        alwaysUse24HourFormat: true),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                var _selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: 0, minute: 0),
                  builder: (BuildContext context, Widget child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child,
                    );
                  },
                );
                int minutes = _createIntFromTimeOfDay(_selectedTime);
                setState(() {
                  _waterSchedule[dayNo][5] = minutes;
                });
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    localizations.formatTimeOfDay(
                        _createTimeOfDayFromInt(_waterSchedule[dayNo][5]),
                        alwaysUse24HourFormat: true),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
