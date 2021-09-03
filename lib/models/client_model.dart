class Client {
  final int locationId;
  final String locationName;
  final List<Unit> units;

  Client({this.locationId, this.locationName, this.units});

  factory Client.fromJson(Map<String, dynamic> mapFromJson) {
    // Boş bir liste oluşturuyoruz
    List<Unit> _units = [];
    // Json ile gelen 'units' arrayinin elemanlarını sırasıyla Unit constructora gönderip, Unit objeye çeviriyoruz
    mapFromJson['units'].forEach((unit) {
      _units.add(Unit.fromJson(unit));
    });
    // dart Unit objelerinden oluşan bir _units listemiz oluştu, bunu da Client constructorında kullanıyoruz

    return Client(
        locationId: mapFromJson['locationId'],
        locationName: mapFromJson['locationName'],
        units: _units);
  }
}

class Unit {
  final String unitId;
  final String unitCode;
  bool isActive;
  final int unitType;
  int temperature;
  int humidity;
  int moisture;
  bool wateringOn;
  bool fanOn;
  bool lightingOn;
  bool waterLevelOk;
  final List<Timing> watering;
  final List<Timing> fan;
  final List<Timing> lighting;

  Unit(
      {this.unitId,
      this.unitCode,
      this.isActive,
      this.unitType,
      this.temperature,
      this.humidity,
      this.moisture,
      this.wateringOn,
      this.fanOn,
      this.lightingOn,
      this.waterLevelOk,
      this.watering,
      this.fan,
      this.lighting});

  factory Unit.fromJson(Map<String, dynamic> item) {
    List<Timing> _watering = [];
    List<Timing> _fan = [];
    List<Timing> _lighting = [];
    item['watering'].forEach((timing) {
      _watering.add(Timing.fromJson(timing));
    });
    item['fan'].forEach((timing) {
      _fan.add(Timing.fromJson(timing));
    });
    item['lighting'].forEach((timing) {
      _lighting.add(Timing.fromJson(timing));
    });
    return Unit(
      unitId: item['unitId'],
      unitCode: item['unitCode'],
      isActive: item['isActive'],
      unitType: item['unitType'],
      temperature: item['temperature'],
      humidity: item['humidity'],
      moisture: item['moisture'],
      wateringOn: item['wateringOn'],
      fanOn: item['fanOn'],
      lightingOn: item['lightingOn'],
      waterLevelOk: item['waterLevelOk'],
      watering: _watering,
      fan: _fan,
      lighting: _lighting,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'unitId': this.unitId,
      'unitCode': this.unitCode,
      'isActive': this.isActive,
      'unitType': this.unitType,
      'temperature': this.temperature,
      'humidity': this.humidity,
      'moisture': this.moisture,
      'wateringOn': this.wateringOn,
      'fanOn': this.fanOn,
      'lightingOn': this.lightingOn,
      'waterLevelOk': this.waterLevelOk,
      'watering': this.watering.map((e) => e.toMap()).toList(),
      'fan': this.fan.map((e) => e.toMap()).toList(),
      'lighting': this.lighting.map((e) => e.toMap()).toList(),
    };
  }
}

class Timing {
  bool isActive;
  final int day;
  int startTimeA;
  int endTimeA;
  int startTimeB;
  int endTimeB;
  int startTimeC;
  int endTimeC;

  Timing(
      {this.isActive,
      this.day,
      this.startTimeA,
      this.endTimeA,
      this.startTimeB,
      this.endTimeB,
      this.startTimeC,
      this.endTimeC});

  factory Timing.fromJson(Map<String, dynamic> item) {
    return Timing(
        isActive: item['isActive'],
        day: item['day'],
        startTimeA: item['startTimeA'],
        endTimeA: item['endTimeA'],
        startTimeB: item['startTimeB'],
        endTimeB: item['endTimeB'],
        startTimeC: item['startTimeC'],
        endTimeC: item['endTimeC']);
  }

  Map<String, dynamic> toMap() {
    return {
      'isActive': this.isActive,
      'day': this.day,
      'startTimeA': this.startTimeA,
      'endTimeA': this.endTimeA,
      'startTimeB': this.startTimeB,
      'endTimeB': this.endTimeB,
      'startTimeC': this.startTimeC,
      'endTimeC': this.endTimeC,
    };
  }
}
