///todo: Delete this file
/*
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

class FanSettingPage extends StatefulWidget {
  static String routeName = '/settingsFanPage';
  final int unitId;
  FanSettingPage({this.unitId});

  @override
  _FanSettingPageState createState() => _FanSettingPageState();
}

class _FanSettingPageState extends State<FanSettingPage> {
  bool _isLoading =
      false; // Takvimi kaydet butonuna basılınca LoadingOverLay için
  Unit _tempUnit;
  List<List<int>> _tempFanSchedule;

  /// Bu metot başka şekilde düşünülecek veya logic içerisine taşınacak!!!
  void _toggleIsActive(int dayNo, bool value) {
    _tempUnit.fan[dayNo].isActive = value;
  }

  void _updateTempFanSchedule(List<List<int>> fanSchedule) {
    _tempFanSchedule = fanSchedule;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    */
/*_tempUnit = Provider.of<ClientState>(context)
        .units
        .firstWhere((unit) => unit.unitId == widget.unitId);*/ /*

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Constants.mainGreen,
        title: Text('Ünite ${widget.unitId}: Fan Takvimi',
            style: TextStyle(color: Colors.white)),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        progressIndicator: CircularProgressIndicator(),
        color: Colors.green[50],
        opacity: 0.5,
        child: Consumer<ClientState>(
          builder: (context, clientState, child) {
            /// ClientState'ten veriler çekiliyor, build öncesi.try
            /// NotifyListeners olursa bunlar baştan çekilip, rebuild olacak
            _tempUnit = clientState.units
                .firstWhere((unit) => unit.unitId == widget.unitId);
            _tempFanSchedule = clientState.getFanSchedule(widget.unitId);
            print("Consumer içindeki builder metodu çalışıyor");
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ImageIcon(
                      AssetImage('assets/fan_icon.jpg'),
                      color: Colors.lightGreen,
                      size: 80,
                    ),
                  ),
                  Text('Fan Çalışma Saatleri için tıklayınız:',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 50,
                  ),
                  ScheduleRow(
                    dayNo: 0,
                    unit: _tempUnit,
                    fanSchedule: _tempFanSchedule,
                    toggleIsActive: _toggleIsActive,
                    updateTempFanSchedule: _updateTempFanSchedule,
                  ),
                  ScheduleRow(
                    dayNo: 1,
                    unit: _tempUnit,
                    fanSchedule: _tempFanSchedule,
                    toggleIsActive: _toggleIsActive,
                    updateTempFanSchedule: _updateTempFanSchedule,
                  ),
                  ScheduleRow(
                    dayNo: 2,
                    unit: _tempUnit,
                    fanSchedule: _tempFanSchedule,
                    toggleIsActive: _toggleIsActive,
                    updateTempFanSchedule: _updateTempFanSchedule,
                  ),
                  ScheduleRow(
                    dayNo: 3,
                    unit: _tempUnit,
                    fanSchedule: _tempFanSchedule,
                    toggleIsActive: _toggleIsActive,
                    updateTempFanSchedule: _updateTempFanSchedule,
                  ),
                  ScheduleRow(
                    dayNo: 4,
                    unit: _tempUnit,
                    fanSchedule: _tempFanSchedule,
                    toggleIsActive: _toggleIsActive,
                    updateTempFanSchedule: _updateTempFanSchedule,
                  ),
                  ScheduleRow(
                    dayNo: 5,
                    unit: _tempUnit,
                    fanSchedule: _tempFanSchedule,
                    toggleIsActive: _toggleIsActive,
                    updateTempFanSchedule: _updateTempFanSchedule,
                  ),
                  ScheduleRow(
                    dayNo: 6,
                    unit: _tempUnit,
                    fanSchedule: _tempFanSchedule,
                    toggleIsActive: _toggleIsActive,
                    updateTempFanSchedule: _updateTempFanSchedule,
                  ),
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
                                _tempFanSchedule)) {
                              showAlertDialog(context);
                            }
                            var response = await clientState.updateFanSchedule(
                                _tempFanSchedule, _tempUnit);
                            print(
                                'viewmodeldan butona gelen response: $response');
                            if (response) {
                              print('true döndü');
                            } else {
                              print('kaydedilemedi ');
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
class ScheduleRow extends StatefulWidget {
  final int dayNo;
  final Unit unit;
  final List<List<int>>
      fanSchedule; // [[450, 495, 900, 925, -1, -1], [720, 725, 900, 925, -1, -1], [720, 725, 900, 925, -1, -1], [720, 725, 900, 925, -1, -1], [720, 725, 900, 925, -1, -1], [720, 725, 900, 925, -1, -1], [720, 725, 900, 925, -1, -1]]
  final Function toggleIsActive;
  final Function updateTempFanSchedule;
  const ScheduleRow(
      {@required this.dayNo,
      @required this.unit,
      @required this.fanSchedule,
      @required this.toggleIsActive,
      @required this.updateTempFanSchedule});

  @override
  _ScheduleRowState createState() => _ScheduleRowState();
}

class _ScheduleRowState extends State<ScheduleRow> {
  bool isActive = true;
  Function toggleIsActive = () {};
  Function updateTempFanSchedule = () {};
  List<List<int>> _fanSchedule;

  @override
  void initState() {
    isActive = widget.unit.fan[widget.dayNo].isActive;
    toggleIsActive = widget.toggleIsActive;
    updateTempFanSchedule = widget.updateTempFanSchedule;
    _fanSchedule = widget.fanSchedule;
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
                  onTap: _fanSchedule[dayNo][0] < 0
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
                              _fanSchedule[dayNo][0] = minutes;
                              updateTempFanSchedule(_fanSchedule);
                            });
                          }
                        },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        localizations.formatTimeOfDay(
                            Calculator.createTimeOfDayFromInt(
                                _fanSchedule[dayNo][0]),
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
                        _fanSchedule[dayNo][1] = minutes;
                        updateTempFanSchedule(_fanSchedule);
                      });
                    }
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        localizations.formatTimeOfDay(
                            Calculator.createTimeOfDayFromInt(
                                _fanSchedule[dayNo][1]),
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
*/
