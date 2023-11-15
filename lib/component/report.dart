class Report {
  late String id;
  late String username;
  late String descricao;
  late String? incidente;
  late String localizacao;
  late String? urlPhoto;

  Report({required this.id, required this.username,required this.descricao, required this.incidente, required this.localizacao, required this.urlPhoto});

  Report.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        username = map["username"],
        descricao = map["descricao"],
        incidente = map["incidente"],
        localizacao = map["localizacao"],
        urlPhoto = map["urlPhoto"];
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "descricao": descricao,
      "incidente": incidente,
      "localizacao": localizacao,
      "urlPhoto": urlPhoto,
    };
  }
}
