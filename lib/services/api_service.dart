import 'dart:async';
import 'dart:convert';
import './constants.dart';
import '../models/client_model.dart';
import 'package:http/http.dart' as http;

// Api Service Görevler:
// Server'dan token&username ile client bilgisini çeker
// client objesi oluşturur, Client Modeli kullarak, ve döner
enum LoginStatus { ok, userError, passwordError, unknownError }

class ApiService {
  /// Singleton obje yaratıyoruz
  ApiService._singleton();
  static final ApiService instance = ApiService._singleton();
  final String _apiTokenUrl = 'https://doa.ohmenerji.com.tr/token';
  final String _apiGetUrl = 'https://doa.ohmenerji.com.tr/api/units';
  final String _apiToggleUrl = 'https://doa.ohmenerji.com.tr/api/units/toggle';
  final String _apiPostUnitSettings = 'https://doa.ohmenerji.com.tr/api/units';

  /// Cihaz açılışında SharedPref'ten datalar çekilirken bu verilerin de yüklenmesi gerekiyor.
  ///
  String _token = '';
  String _userName = '';

  void setToken(String token) {
    _token = 'bearer $token';
  }

  void setUserName(String userName) {
    _userName = userName;
  }

  Map<String, String> get headersForGet => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "$_token",
        "username": "$_userName",
      };

  Map<String, String> get headersForToken => {
        "Content-Type": "application/x-www-form-urlencoded",
      };

  /// Login metodu
  /// arayüzden,formdan gelen email/pass kullanarak api servise get yapacak
  /// token bilgisini değişkene yazacak -->> Bu veriyi sharedPrefte tutmak gerekebilir
  /// arayüze LoginStatus bilgisi dönecek.
  /// login bilgisi tutan değişken true yapılacak -->> bunu da sharedprefte saklamak lazım
  Future<Map<String, dynamic>> login({String email, String pass}) async {
    final bodyMap = {
      "grant_type": "password",
      "username": email,
      "password": pass
    };
    final response = await http
        .post(_apiTokenUrl, headers: headersForToken, body: bodyMap)
        .timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      _userName = jsonDecode(response.body)['userName'];

      return {
        'loginStatus': LoginStatus.ok,
        'token': jsonDecode(response.body)['access_token'],
        'userName': jsonDecode(response.body)['userName']
      };
    } else if (jsonDecode(response.body)['error_description'] ==
        "The user name or password is incorrect.") {
      return {
        'loginStatus': LoginStatus.passwordError,
        'token': null,
        'userName': null
      };
    } else if (jsonDecode(response.body)['error_description'] ==
        "User not found") {
      return {
        'loginStatus': LoginStatus.userError,
        'token': null,
        'userName': null
      };
    } else {
      return {
        'loginStatus': LoginStatus.unknownError,
        'token': null,
        'userName': null
      };
    }
  }

  Future<Client> getDataFromServer() async {
    //print("----- API : getDataFromServer called");
    try {
      final response = await http
          .get(_apiGetUrl, headers: headersForGet)
          .timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
/*        print(" ============= SERVERDAN GELEN JSON");
        print(jsonDecode(response.body)['units'][1]['lighting']);*/
        var clientData = Client.fromJson(jsonDecode(response.body));
        return clientData;
      } else {
        throw Exception('Failed to load client data');
      }
    } on TimeoutException {
      print("**** TimeOutException -----> getDataFromServer");
      rethrow;
    }
  }

  /// switchleri toggle eden fonksiyon,
  /// Eğer işlem API'dan success olarak dönerse true döndürecek, aksi halde false
  Future<bool> toggle({int unitId, int toggleType, bool toggleStatus}) async {
    //body: objesi dışarı alınabilir mi diye düşündüm ama sanırım gerek yok.
    final response = await http.post(_apiToggleUrl,
        headers: headersForGet,
        body: jsonEncode(
            {"UnitId": unitId, "Type": toggleType, "Value": toggleStatus}));

    // İşlem başarılı olduysa dönen objenin Status key value değeri String '1'
    // Aşağıdaki ifade true ise işlem başarılı olmuştur
    if (jsonDecode(response.body)['Status'] == '1') {
      return true;
    } else {
      return false;
    }
  }

  /// Bu metot ile serverdan "Özet Unite verisi / Short Unit Data" alınıyor,
  /// Gelen veride unite takvimleri yok
  /// Map olarak viewmodel'a döndürülüyor
  Future<Map<String, dynamic>> getShortUnitDataFromServer({int unitId}) async {
    print("---- APİ : getShortUnitDataFromServer");

    final response =
        await http.get('$_apiGetUrl/$unitId', headers: headersForGet);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return response
      Map<String, dynamic> unitData = jsonDecode(response.body);

      return unitData;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load client data');
    }
  }

  Future<bool> postUnitData({Map unitAsMap}) async {
    //print("---- API : postUnitData");
/*    print(" ============= SERVERA GÖNDERİLEN JSON");
    print(unitAsMap['lighting']);*/
    try {
      final response = await http
          .post(_apiPostUnitSettings,
              headers: headersForGet, body: jsonEncode(unitAsMap))
          .timeout(Duration(seconds: 5));
      if (jsonDecode(response.body)['Status'] == '1') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
