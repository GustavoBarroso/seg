import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  late String id;
  late String username;
  late String descricao;
  late String? incidente;
  late String localizacao;
  late String? urlPhoto;
  late Timestamp timestamp; // Mantendo o tipo como Timestamp

  Report({
    required this.id,
    required this.username,
    required this.descricao,
    required this.incidente,
    required this.localizacao,
    required this.urlPhoto,
    required this.timestamp,
  });

  Report.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        username = map["username"],
        descricao = map["descricao"],
        incidente = map["incidente"],
        localizacao = map["localizacao"],
        urlPhoto = map["urlPhoto"],
        timestamp = map["timestamp"] ?? Timestamp.now(); // Se timestamp for nulo, use Timestamp.now()

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "descricao": descricao,
      "incidente": incidente,
      "localizacao": localizacao,
      "urlPhoto": urlPhoto,
      "timestamp": timestamp, // Adicionando timestamp ao mapeamento
    };
  }
}
