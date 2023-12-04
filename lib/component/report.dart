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
  late String? useruid;
  List<Avaliacao>? avaliacoes;

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
    this.avaliacoes,
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
        timestamp = map["timestamp"] ?? Timestamp.now(),
        avaliacoes = (map['avaliacoes'] as List<dynamic>?)
            ?.map((avaliacaoMap) => Avaliacao.fromMap(avaliacaoMap))
            .toList();

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
      "avaliacoes": avaliacoes?.map((avaliacao) => avaliacao.toMap()).toList(),
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
    List<Avaliacao>? avaliacoes,
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
      avaliacoes: avaliacoes ?? this.avaliacoes,
    );
  }

  String formatarLocalizacaoSimplificada() {
    List<String> partes =
    localizacao.split(',').map((e) => e.trim()).take(4).toList();
    return partes.join(', ');
  }
}

class Avaliacao {
  late double nota;
  String useruid;
  String? reportId;

  Avaliacao({
    required this.nota,
    required this.useruid,
    this.reportId, // Torna reportId opcional
  });

  Avaliacao.fromMap(Map<String, dynamic> map)
      : nota = map["nota"].toDouble(),
        useruid = map["useruid"],
        reportId = map["reportId"];

  Map<String, dynamic> toMap() {
    return {
      "nota": nota,
      "useruid": useruid,
      "reportId": reportId,
    };
  }
}


class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Avaliacao>> getAvaliacoesDoUsuario(String useruid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> avaliacoesSnapshot =
      await _firestore.collection('avaliacoes').where('useruid', isEqualTo: useruid).get();

      if (avaliacoesSnapshot.size > 0) {
        List<Avaliacao> avaliacoes = avaliacoesSnapshot.docs
            .map((avaliacaoDoc) => Avaliacao.fromMap(avaliacaoDoc.data()))
            .toList();

        return avaliacoes;
      } else {
        return [];
      }
    } catch (error) {
      print('Erro ao obter avaliações do usuário: $error');
      return [];
    }
  }
}
