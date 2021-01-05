import 'package:doa_1_0/models/client.dart';
import 'package:doa_1_0/views/device_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final TextStyle _infoTextStyle =
      TextStyle(fontSize: 20, color: Colors.black54);

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('HomePage'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.asset(
                'assets/doa_logo.png',
                width: _imageWidth,
              ),
            ),
            Text(
              '${_clientData.companyName}',
              style: _infoTextStyle,
            ),
            SizedBox(height: 20.0),
            Text(
              'Sıcaklık: 24 C',
              style: _infoTextStyle,
            ),
            Text('Nem Oranı: % 63', style: _infoTextStyle),
            SizedBox(height: 40.0),
            Expanded(
              child: ListView.builder(
                itemCount: _clientData.units.length,
                itemBuilder: (BuildContext context, int index) => _buildCard(
                    unitId: _clientData.units[index].id,
                    isActive: _clientData.units[index].isActive,
                    type: _clientData.units[index].type,
                    context: context),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      {int unitId, bool isActive, String type, BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 2),
      child: GestureDetector(
        onTap: () {
          print('Ünite $unitId tıklandı');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DevicePage(
                        unitId: unitId,
                      )));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: isActive ? Colors.green[50] : Colors.red[50],
          child: ListTile(
            leading: isActive
                ? Icon(Icons.wb_sunny, color: Colors.green)
                : Icon(Icons.warning, color: Colors.red),
            title: Text('Ünite $unitId'),
            //subtitle: isActive ? Text('Aktif') : Text('Çalışmıyor'),
          ),
        ),
      ),
    );
  }
}
