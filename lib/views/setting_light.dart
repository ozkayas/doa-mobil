import 'dart:async';
import 'package:doa_1_0/services/constants.dart';
import 'package:doa_1_0/widgets/alert_dialogs.dart';
import '../models/client_model.dart';
import '../services/calculator.dart';
import '../view_models/client_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:loading_overlay/loading_overlay.dart';

const List<String> _days = ['Pt', 'S', 'Ç', 'P', 'C', 'Ct', 'P'];

class LightSettingPage extends StatefulWidget {
  static String routeName = '/settingsLightPage';
  final int unitId;
  LightSettingPage({this.unitId});

  @override
  _LightSettingPageState createState() => _LightSettingPageState();
}

class _LightSettingPageState extends State<LightSettingPage> {
  bool _isLoading = false; // LoadingOverlay default value
  Unit _tempUnit;
  List<List<int>> _tempLightSchedule;

  void _toggleIsActive(int dayNo, bool value) {
    _tempUnit.lighting[dayNo].isActive = value;
  }

  void _updateTempLightSchedule(List<List<int>> lightSchedule) {
    _tempLightSchedule = lightSchedule;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
            //Navigator.pop(context);
          },
        ),
        backgroundColor: Constants.mainGreen,
        title: Text('Ünite ${widget.unitId}: Aydınlatma Takvimi',
            style: TextStyle(color: Colors.white)),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        progressIndicator: CircularProgressIndicator(),
        color: Colors.green[50],
        opacity: 0.5,
        child: Consumer<ClientState>(
          builder: (context, clientState, child) {
            _tempUnit = clientState.units
                .firstWhere((unit) => unit.unitId == widget.unitId);
            //Günlere göre sırala
            _tempUnit.lighting.sort((a, b) => a.day - b.day);
            _tempLightSchedule = _tempUnit.lighting
                .map((e) => [
                      e.startTimeA,
                      e.endTimeA,
                      e.startTimeB,
                      e.endTimeB,
                      e.startTimeC,
                      e.endTimeC
                    ])
                .toList();
            /*List<List<int>> _tempLightSchedule =
                clientState.getLightSchedule(widget.unitId);*/

            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ImageIcon(
                      AssetImage('assets/light_icon.jpg'),
                      color: Colors.lightGreen,
                      size: 80,
                    ),
                  ),
                  Text('Aydınlatma Saatleri için tıklayınız:',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(
                    height: 50,
                  ),
                  ScheduleRow(
                      dayNo: 0,
                      unit: _tempUnit,
                      lightSchedule: _tempLightSchedule,
                      toggleIsActive: _toggleIsActive,
                      updateTempLightSchedule: _updateTempLightSchedule),
                  ScheduleRow(
                      dayNo: 1,
                      unit: _tempUnit,
                      lightSchedule: _tempLightSchedule,
                      toggleIsActive: _toggleIsActive,
                      updateTempLightSchedule: _updateTempLightSchedule),
                  ScheduleRow(
                      dayNo: 2,
                      unit: _tempUnit,
                      lightSchedule: _tempLightSchedule,
                      toggleIsActive: _toggleIsActive,
                      updateTempLightSchedule: _updateTempLightSchedule),
                  ScheduleRow(
                      dayNo: 3,
                      unit: _tempUnit,
                      lightSchedule: _tempLightSchedule,
                      toggleIsActive: _toggleIsActive,
                      updateTempLightSchedule: _updateTempLightSchedule),
                  ScheduleRow(
                      dayNo: 4,
                      unit: _tempUnit,
                      lightSchedule: _tempLightSchedule,
                      toggleIsActive: _toggleIsActive,
                      updateTempLightSchedule: _updateTempLightSchedule),
                  ScheduleRow(
                      dayNo: 5,
                      unit: _tempUnit,
                      lightSchedule: _tempLightSchedule,
                      toggleIsActive: _toggleIsActive,
                      updateTempLightSchedule: _updateTempLightSchedule),
                  ScheduleRow(
                      dayNo: 6,
                      unit: _tempUnit,
                      lightSchedule: _tempLightSchedule,
                      toggleIsActive: _toggleIsActive,
                      updateTempLightSchedule: _updateTempLightSchedule),
                  SizedBox(height: 30),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: MediaQuery.of(context).size.width * 0.8),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Constants.mainGreen,
                        ),
                        onPressed: () async {
                          ///todo: butona basıldığında, provider içindeki clientstate fanSchedule gönderilecek,
                          ///clientState viewModel da bunu alıp clientState'i güncelleyecek bir metot lazım
                          ///bu metot aynı zamanda API'dan servera güncel state isteğini gönderecek.
                          ///buton sonra sayfayı pop edecek, bir önceki sayfaya atacak kullanıcıyı.
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            if (!Calculator.validateSelectedTimes(
                                _tempLightSchedule)) {
                              showAlertDialog(context);
                            }
                            var response =
                                await clientState.updateLightSchedule(
                                    _tempLightSchedule, _tempUnit);
                            if (response) {
                            } else {
                              await showTimeOutAlertDialog(context);
                              Navigator.pop(context);
                            }
                          } on TimeoutException catch (_) {
                            await showTimeOutAlertDialog(context);
                            Navigator.pop(context);
                          }
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        child: Text(
                          'KAYDET',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// ScheduleRow kısmını StateFul Widget haline getiriyorum
///  int dayNo verisi alacak
///
/*///todo: Delete This implementation
  class ScheduleRow extends StatefulWidget {
  final int dayNo;
  final Unit unit;
  final List lightSchedule;
  final Function toggleIsActive;
  const ScheduleRow(
      {@required this.dayNo,
      @required this.unit,
      @required this.lightSchedule,
      @required this.toggleIsActive});

  @override
  _ScheduleRowState createState() => _ScheduleRowState();
}

class _ScheduleRowState extends State<ScheduleRow> {
  bool isActive = true;
  Function toggleIsActive = () {};
  List<List<int>> _lightSchedule;

  @override
  void initState() {
    isActive = widget.unit.lighting[widget.dayNo].isActive;
    toggleIsActive = widget.toggleIsActive;
    _lightSchedule = widget.lightSchedule;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final int dayNo = widget.dayNo;
    final double _circleAvatarRadius = 20.0;

    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: _circleAvatarRadius,
            backgroundColor: isActive ? Colors.lightGreen : Colors.redAccent,
            child: Text(_days[dayNo],
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          SizedBox(
            width: 20,
          ),
          AbsorbPointer(
            absorbing: !isActive,
            child: Row(
              children: [
                GestureDetector(
                  onTap: _lightSchedule[dayNo][0] < 0
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
                          if (_selectedTime != null) {
                            int minutes = Calculator.createIntFromTimeOfDay(
                                _selectedTime);
                            setState(() {
                              _lightSchedule[dayNo][0] = minutes;
                            });
                          }
                        },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        localizations.formatTimeOfDay(
                            Calculator.createTimeOfDayFromInt(
                                _lightSchedule[dayNo][0]),
                            alwaysUse24HourFormat: true),
                        style: GoogleFonts.orbitron(
                            fontSize: 16,
                            color: isActive ? Colors.black : Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Text('-'),
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
                    if (_selectedTime != null) {
                      int minutes =
                          Calculator.createIntFromTimeOfDay(_selectedTime);
                      setState(() {
                        _lightSchedule[dayNo][1] = minutes;
                      });
                    }
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        localizations.formatTimeOfDay(
                            Calculator.createTimeOfDayFromInt(
                                _lightSchedule[dayNo][1]),
                            alwaysUse24HourFormat: true),
                        style: GoogleFonts.orbitron(
                            fontSize: 16,
                            color: isActive ? Colors.black : Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Switch(
              activeColor: Colors.lightGreen,
              value: isActive,
              onChanged: (value) {
                toggleIsActive(dayNo, value);
                setState(() {
                  isActive = !isActive;
                });
              })
        ],
      ),
    );
  }
}*/
class ScheduleRow extends StatefulWidget {
  final int dayNo;
  final Unit unit;
  final List<List<int>>
      lightSchedule; // [[450, 495, 900, 925, -1, -1], [720, 725, 900, 925, -1, -1], [720, 725, 900, 925, -1, -1], [720, 725, 900, 925, -1, -1], [720, 725, 900, 925, -1, -1], [720, 725, 900, 925, -1, -1], [720, 725, 900, 925, -1, -1]]
  final Function toggleIsActive;
  final Function updateTempLightSchedule;
  const ScheduleRow(
      {@required this.dayNo,
      @required this.unit,
      @required this.lightSchedule,
      @required this.toggleIsActive,
      @required this.updateTempLightSchedule});

  @override
  _ScheduleRowState createState() => _ScheduleRowState();
}

class _ScheduleRowState extends State<ScheduleRow> {
  bool isActive = true;
  Function toggleIsActive = () {};
  Function updateTempLightSchedule = () {};
  List<List<int>> _lightSchedule;

  @override
  void initState() {
    isActive = widget.unit.lighting[widget.dayNo].isActive;
    toggleIsActive = widget.toggleIsActive;
    updateTempLightSchedule = widget.updateTempLightSchedule;
    _lightSchedule = widget.lightSchedule;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final int dayNo = widget.dayNo;
    final double _circleAvatarRadius = 20.0;

    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: _circleAvatarRadius,
            backgroundColor: isActive ? Colors.lightGreen : Colors.redAccent,
            child: Text(_days[dayNo],
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          SizedBox(
            width: 20,
          ),
          AbsorbPointer(
            absorbing: !isActive,
            child: Row(
              children: [
                GestureDetector(
                  onTap: _lightSchedule[dayNo][0] < 0
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
                          if (_selectedTime != null) {
                            int minutes = Calculator.createIntFromTimeOfDay(
                                _selectedTime);
                            setState(() {
                              _lightSchedule[dayNo][0] = minutes;
                              updateTempLightSchedule(_lightSchedule);
                            });
                          }
                        },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        localizations.formatTimeOfDay(
                            Calculator.createTimeOfDayFromInt(
                                _lightSchedule[dayNo][0]),
                            alwaysUse24HourFormat: true),
                        style: GoogleFonts.orbitron(
                            fontSize: 16,
                            color: isActive ? Colors.black : Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Text('-'),
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
                    if (_selectedTime != null) {
                      int minutes =
                          Calculator.createIntFromTimeOfDay(_selectedTime);
                      setState(() {
                        _lightSchedule[dayNo][1] = minutes;
                        updateTempLightSchedule(_lightSchedule);
                      });
                    }
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        localizations.formatTimeOfDay(
                            Calculator.createTimeOfDayFromInt(
                                _lightSchedule[dayNo][1]),
                            alwaysUse24HourFormat: true),
                        style: GoogleFonts.orbitron(
                            fontSize: 16,
                            color: isActive ? Colors.black : Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Switch(
              activeColor: Colors.lightGreen,
              value: isActive,
              onChanged: (value) {
                toggleIsActive(dayNo, value);
                setState(() {
                  isActive = !isActive;
                });
              })
        ],
      ),
    );
  }
}
