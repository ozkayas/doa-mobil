import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/client_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'package:flutter/material.dart';

class ClientState with ChangeNotifier {
  /// Tüm ana veriyi tutan model sınıf --> client_model.dart dosyasında
  Client _clientData;

  ///StreamBuilder için stream Controller
  BehaviorSubject<Client> postsController = BehaviorSubject();

  /// Kullanıcının anlık token, username ve giriş bilgileri
  /// Bu veri sharedPref'te saklaniyor ve LandingPage yuklenirken okunuyor
  User _user;

  /// Fetches device notification token from Firebase Cloud Messaging
  Future<String> fetchDeviceNotificationToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  void setDeviceNotificationToken(String username, String token) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.add({'username': username, 'token': token});
  }

  Future<User> getUserStatusFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    var response = prefs.getString('user');
    if (response != null) {
      _user = User.fromMap(jsonDecode(response));
    } else {
      _user = User(
          token: '',
          userName: '',
          isLoggedIn: false,
          deviceNotificationToken: '');
    }

    var deviceNotificationToken = await fetchDeviceNotificationToken();
    ApiService.instance.postDeviceNotificationToken(deviceNotificationToken);
    setDeviceNotificationToken(_user.userName, deviceNotificationToken);
    _user.deviceNotificationToken = deviceNotificationToken;

/*    /// Set & Send token if different from current one
    if (deviceNotificationToken != _user.deviceNotificationToken) {
      ApiService.instance.postDeviceNotificationToken(deviceNotificationToken);
      _user.deviceNotificationToken = deviceNotificationToken;
    }*/

    ApiService.instance.setToken(_user.token);
    ApiService.instance.setUserName(_user.userName);

    return _user;
  }

  Future<void> saveUserStatusToDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final String user = jsonEncode(_user.toMap());
    prefs.setString('user', user);
  }

  Future<Map<String, dynamic>> login({String email, String pass}) async {
    var _apiService = ApiService.instance;
    Map<String, dynamic> _loginResponse =
        await _apiService.login(email: email, pass: pass);
    if (_loginResponse['loginStatus'] == LoginStatus.ok) {
      _user.token = _loginResponse['token'];
      _user.userName = _loginResponse['userName'];
      _user.isLoggedIn = true;
    }
    return _loginResponse;
  }

  /// API Servisinden Tüm Müşteri + Cihaz bilgisini isteyen metot
  Future<bool> getClientDataFromApi() async {
    print("---- CLIENT STATE: getClientDataFromApi called");
    try {
      var _apiService = ApiService.instance;
      _clientData = await _apiService.getDataFromServer();
      print("----- _clientData yenilendi");

      ///Stream'e veri ekleniyor, Streambuilder widgetlar okuyor
      postsController.add(_clientData);

      return true;
    } catch (e) {
      rethrow;
    }
  }

  /// API Servisinden Belirli bir ünitenin özet bilgilerini isteyen metot
  Future<Unit> getUnitDataFromApi({int unitId}) async {
    var _apiService = ApiService.instance;
    Map<String, dynamic> shortUnitDataAsMap =
        await _apiService.getShortUnitDataFromServer(unitId: unitId);
    //gelen güncel ünite bilgisini _clientData içine yazıyoruz

    // bu Id'li unitenin listenin kaçıncı sırasında olduğunu bul
    int index = _clientData.units.indexWhere((unit) => unit.unitId == unitId);

    // bu indexteki uniteye Map içindeki verileri yaz
    _clientData.units[index].waterLevelOk = shortUnitDataAsMap['waterLevelOk'];
    _clientData.units[index].isActive = shortUnitDataAsMap['isActive'];
    _clientData.units[index].temperature = shortUnitDataAsMap['temperature'];
    _clientData.units[index].humidity = shortUnitDataAsMap['humidity'];
    _clientData.units[index].moisture = shortUnitDataAsMap['moisture'];
    _clientData.units[index].wateringOn = shortUnitDataAsMap['wateringOn'];
    _clientData.units[index].fanOn = shortUnitDataAsMap['fanOn'];
    _clientData.units[index].lightingOn = shortUnitDataAsMap['lightingOn'];

    return _clientData.units[index];
  }

  /// Belirli bir unitenin fan takvimini güncelleyen fonksiyon,
  /// argümanlar: yeni fan takvimi ve üzerinde işlem yapılan unit bilgisi.
  Future<bool> updateFanSchedule(
      List<List<int>> fanSchedule, Unit unitToUpdate) async {
    //Argüman olarak gelen fanSchedule & unitToUpdate birleştir, tek bir unit olacak şekilde
    //Seçilen saatleri unit objesindeki Timinglere doldur:

/*    unitToUpdate.fan.sort((a, b) {
      return a.day - b.day;
    });*/

    for (int i = 0; i < 7; i++) {
      unitToUpdate.fan[i].startTimeA = fanSchedule[i][0];
      unitToUpdate.fan[i].endTimeA = fanSchedule[i][1];
      //2.ve 3. pencereler için gelecekte yorumdan çıkartılacak satırlar:
      //unitToUpdate.fan[i].startTimeB = fanSchedule[i][2];
      //unitToUpdate.fan[i].endTimeB = fanSchedule[i][3];
      //unitToUpdate.fan[i].startTimeC = fanSchedule[i][4];
      //unitToUpdate.fan[i].endTimeC = fanSchedule[i][5];
    }

    try {
      var unitAsMap = unitToUpdate.toMap();
      bool response =
          await ApiService.instance.postUnitData(unitAsMap: unitAsMap);
      print('apiden dönen response: $response');
      if (response == true) {
        await getClientDataFromApi();
        notifyListeners();
      } else {
        notifyListeners();
      }
      print('returnden önceki satırdaki response: $response');
      return response;
    } catch (e) {
      print(' ${e.toString()}');
      rethrow;
    }
  }

  Future<bool> updateLightSchedule(
      List<List<int>> lightSchedule, Unit unitToUpdate) async {
    //Argüman olarak gelen lightSchedule & unitToUpdate birleştir, tek bir unit olacak şekilde
    //Seçilen saatleri unit objesindeki Timinglere doldur:
    for (int i = 0; i < 7; i++) {
      unitToUpdate.lighting[i].startTimeA = lightSchedule[i][0];
      unitToUpdate.lighting[i].endTimeA = lightSchedule[i][1];
      //2.ve 3. pencereler için gelecekte yorumdan çıkartılacak satırlar:
      //unitToUpdate.lighting[i].startTimeB = lightSchedule[i][2];
      //unitToUpdate.lighting[i].endTimeB = lightSchedule[i][3];
      //unitToUpdate.lighting[i].startTimeC = lightSchedule[i][4];
      //unitToUpdate.lighting[i].endTimeC = lightSchedule[i][5];
    }
    //Birleştirilmiş, updated Unit objesini Map'e çevir
    try {
      var unitAsMap = unitToUpdate.toMap();
      bool response =
          await ApiService.instance.postUnitData(unitAsMap: unitAsMap);

      if (response == true) {
        await getClientDataFromApi();
        notifyListeners();
      } else {
        notifyListeners();
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// GETTERS
  bool get isLoggedIn => _user.isLoggedIn ?? false;
  int get locationId => _clientData.locationId;
  String get locationName => _clientData.locationName;
  List<Unit> get units => _clientData.units;
  Unit unit(int unitId) =>
      _clientData.units.firstWhere((unit) => unit.unitId == unitId);
  bool wateringOn(int unitId) => _clientData.units
      .firstWhere((element) => element.unitId == unitId)
      .wateringOn;
  bool fanOn(int unitId) =>
      _clientData.units.firstWhere((element) => element.unitId == unitId).fanOn;
  bool lightingOn(int unitId) => _clientData.units
      .firstWhere((element) => element.unitId == unitId)
      .lightingOn;

  List<List<int>> getWaterSchedule(int unitId) {
    Unit _unit =
        _clientData.units.firstWhere((element) => element.unitId == unitId);
    return _unit.watering
        .map((e) => [
              e.startTimeA,
              e.endTimeA,
              e.startTimeB,
              e.endTimeB,
              e.startTimeC,
              e.endTimeC
            ])
        .toList();
  }

  List<List<int>> getFanSchedule(int unitId) {
    Unit _unit =
        _clientData.units.firstWhere((element) => element.unitId == unitId);
    // Günlere göre sıralanıyor.
    _unit.fan.sort((a, b) {
      return a.day - b.day;
    });

    return _unit.fan
        .map((e) => [
              e.startTimeA,
              e.endTimeA,
              e.startTimeB,
              e.endTimeB,
              e.startTimeC,
              e.endTimeC
            ])
        .toList();
  }

  List<List<int>> getLightSchedule(int unitId) {
    Unit _unit =
        _clientData.units.firstWhere((element) => element.unitId == unitId);
    // Return etmeden önce günlere göre sıralama yapmak gerekiyor
    _unit.lighting.sort((a, b) {
      return a.day - b.day;
    });
    // Günlere göre sıralanmış listeden pencereler List<int> dolduruluyor.
    return _unit.lighting
        .map((e) => [
              e.startTimeA,
              e.endTimeA,
              e.startTimeB,
              e.endTimeB,
              e.startTimeC,
              e.endTimeC
            ])
        .toList();
  }

  /// SETTERS
  void setLoggedIn(bool bool) {
    print('Provider içindeki _isLoggedIn: $bool yapıldı');
    _user.isLoggedIn = bool;
    saveUserStatusToDevice();
  }

  Future<bool> toggleSwitch({bool bool, int toggleType, String unitId}) async {
    var _apiService = ApiService.instance;
    var result = await _apiService.toggle(
        toggleStatus: bool, toggleType: toggleType, unitId: unitId);
    await getClientDataFromApi();
    return result;
  }
}
