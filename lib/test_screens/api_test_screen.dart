import 'package:doa_1_0/services/api_service.dart';
import 'package:flutter/material.dart';

// API'den data çekme kontrolü için main sayfasında home: direkt bağlanarak
// kullanılır
// gerekli printler getData fonksiyonu içinde verilebilir
// consola print ettirilerek kontrol edilir.

class ApiTestScreen extends StatefulWidget {
  @override
  _ApiTestScreenState createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  ApiService _apiService = ApiService.instance;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text('get data from api'),
        onPressed: () {
          _apiService.getDataFromServer();
        },
      ),
    );
  }
}
