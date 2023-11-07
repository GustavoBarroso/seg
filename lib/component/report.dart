class Report {
  late String id;
  late String descricao;
  late String? incidente;
  late String localizacao;
  late String? urlPhoto;

  Report({required this.id, required this.descricao, required this.incidente, required this.localizacao, required this.urlPhoto});

  Report.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        descricao = map["descricao"],
        incidente = map["incidente"],
        localizacao = map["localizacao"],
        urlPhoto = map["urlPhoto"];
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "descricao": descricao,
      "incidente": incidente,
      "localizacao": localizacao,
      "urlPhoto": urlPhoto,
    };
  }
}
