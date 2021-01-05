import 'package:doa_1_0/models/client.dart';
import 'package:flutter/material.dart';

class DevicePage extends StatelessWidget {
  final int unitId;
  DevicePage({this.unitId});
  final ClientData _clientData = ClientData(
      userId: 123456,
      companyName: 'ABC Company',
      temperature: 20,
      humidity: 64,
      units: <Unit>[
        Unit(id: 1, type: 'compact', isActive: true),
        Unit(
          id: 2,
          type: 'medium',
          isActive: true,
        ),
        Unit(
          id: 3,
          type: 'compact',
          isActive: false,
        ),
        Unit(id: 4, type: 'large', isActive: true),
        Unit(id: 5, type: 'large', isActive: true),
        Unit(id: 6, type: 'large', isActive: false)
      ]);

  @override
  Widget build(BuildContext context) {
    final double _imageWidth = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.green[700]),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.green[50],
          title: Text('Ünite Detay Bilgisi',
              style: TextStyle(color: Colors.green[700])),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 30, 12, 20),
            child: Column(
              children: [
                Image.asset(
                  'assets/doa_logo.png',
                  width: _imageWidth,
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Ünite: $unitId',
                    style: Theme.of(context).textTheme.headline4),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Flexible(
                        flex: 1, child: Image.asset('assets/unit_image.png')),
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoCard(context, 'Sulama',
                                _clientData.units[unitId - 1].water),
                            Divider(),
                            _buildInfoCard(context, 'Fan',
                                _clientData.units[unitId - 1].fan),
                            Divider(),
                            _buildInfoCard(context, 'Aydınlatma',
                                _clientData.units[unitId - 1].light)
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  _buildInfoCard(BuildContext context, String title, Map<String, dynamic> map) {
    List<String> activeDays = [];
    map.forEach((key, value) {
      if (value == true) {
        activeDays.add(key);
      }
    });
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headline6),
          Text(activeDays.join(', ')),
          Text('Başlangıç: ${map['start_time']}'),
          Text('Süre: ${map['duration']}'),
        ],
      ),
    );
  }
}
