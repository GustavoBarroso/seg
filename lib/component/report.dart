import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  late String id;
  late String username;
  late String descricao;
  late String? incidente;
  late String localizacao;
  late String? urlPhoto;
  late double latitude;
  late double longitude;
  late double distance;
  late Timestamp timestamp;
  late String useruid;

  Report({
    required this.id,
    required this.username,
    required this.descricao,
    required this.incidente,
    required this.localizacao,
    required this.urlPhoto,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.timestamp,
    required this.useruid,
  });

  Report.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        username = map["username"],
        useruid = map["useruid"],
        descricao = map["descricao"],
        incidente = map["incidente"],
        localizacao = map["localizacao"],
        urlPhoto = map["urlPhoto"],
        latitude = (map["latitude"] as num?)?.toDouble() ?? 0.0,
        longitude = (map["longitude"] as num?)?.toDouble() ?? 0.0,
        distance = (map["distance"] as num?)?.toDouble() ?? 0.0,
        timestamp = map["timestamp"] ?? Timestamp.now();

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "useruid": useruid,
      "descricao": descricao,
      "incidente": incidente,
      "localizacao": localizacao,
      "urlPhoto": urlPhoto,
      "latitude": latitude,
      "longitude": longitude,
      "distance": distance,
      "timestamp": timestamp,
    };
  }

  Report copyWith({
    String? id,
    String? username,
    String? useruid,
    String? descricao,
    String? incidente,
    String? localizacao,
    String? urlPhoto,
    double? latitude,
    double? longitude,
    double? distance,
    Timestamp? timestamp,
  }) {
    return Report(
      id: id ?? this.id,
      username: username ?? this.username,
      useruid: useruid ?? this.useruid,
      descricao: descricao ?? this.descricao,
      incidente: incidente ?? this.incidente,
      localizacao: localizacao ?? this.localizacao,
      urlPhoto: urlPhoto ?? this.urlPhoto,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  String formatarLocalizacaoSimplificada() {
    List<String> partes =
    localizacao.split(',').map((e) => e.trim()).take(4).toList();
    return partes.join(', ');
  }
}
