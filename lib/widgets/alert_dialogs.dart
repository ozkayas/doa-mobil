import 'package:flutter/material.dart';

Future<void> showLoginAlertDialog(BuildContext context, String error) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('GİRİŞ HATASI'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(error),
              Text('Lütfen bilgilerinizi kontrol ediniz'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('ANLADIM'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showAlertDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('DİKKAT'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Lütfen takvim seçiminizi kontrol ediniz'),
              Text('Başlama anı, bitiş zamanından önce olmalı'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('ANLADIM'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showTimeOutAlertDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('BAĞLANTI HATASI'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Sunucu ile bağlantı kurulamadı'),
              Text('Lütfen daha sonra tekrar deneyiniz'),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text('ANLADIM'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showSimpleDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          "Bağlantı Hatası",
          textAlign: TextAlign.center,
        ),
        titlePadding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 20,
        ),
        children: <Widget>[
          Text(
            "Lütfen daha sonra tekrar deneyiniz.",
            textAlign: TextAlign.center,
          )
        ],
        contentPadding: EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 20,
        ),
      );
    },
  );
}

Future<void> showWaterLevelDialog(BuildContext context) async {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'KRİTİK UYARI',
          style: TextStyle(color: Colors.redAccent),
          textAlign: TextAlign.center,
        ),
        content: Text(
          '''Cihaz Su Seviyesi Kritik Seviyede.
            Lütfen Su Ekleyiniz !''',
        ),
        actions: <Widget>[
          TextButton(
            child: Text("OK", style: TextStyle(fontSize: 16)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  });
}

Future<void> showDisconnectedUnitDialog(BuildContext context) async {
  await showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        'KRİTİK UYARI',
        style: TextStyle(color: Colors.redAccent),
        textAlign: TextAlign.center,
      ),
      content: Text(
        '''Cihaz Bağlantı Sorunu
            Lütfen servis ile iletişime geçiniz  !''',
      ),
      actions: <Widget>[
        TextButton(
          child: Text("OK", style: TextStyle(fontSize: 16)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

Future<bool> showConfirmLogoutDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('DİKKAT'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Çıkış Yapmak İstiyorsunuz'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('İPTAL'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text('ÇIKIŞ'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
