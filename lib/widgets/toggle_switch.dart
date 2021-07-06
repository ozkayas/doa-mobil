import 'package:doa_1_0/view_models/client_state_provider.dart';
import 'package:doa_1_0/widgets/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Ephemeral-Local State (Switch Toggle Durumu) tutabilmek için
///Ayırmak zorunda kaldım
class ToggleSwitch extends StatefulWidget {
  final bool status;
  final int toggleType;
  final int unitId;

  /// 1.WaterinOn 2.fanOn 3.lightingOn

  const ToggleSwitch(
      {Key key,
      @required this.toggleType,
      @required this.status,
      @required this.unitId})
      : super(key: key);

  @override
  _ToggleSwitchState createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  bool status;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    //print("Toggle Rebuilded");
    status = widget.status;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Switch(
            value: status,
            onChanged: (bool) async {
              setState(() {
                _isLoading = !_isLoading;
              });
              var result =
                  await Provider.of<ClientState>(context, listen: false)
                      .toggleSwitch(
                          bool: bool,
                          toggleType: widget.toggleType,
                          unitId: widget.unitId);
              if (result) {
                setState(() {
                  status = !status;
                  _isLoading = !_isLoading;
                });
              } else {
                print('toggle edilemedi, sunucuya yazılamadı');
                await showTimeOutAlertDialog(context);
                setState(() {
                  _isLoading = false;
                });
              }
            });
  }
}
