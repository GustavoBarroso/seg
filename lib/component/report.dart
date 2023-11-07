class Report {
  late String id;
  late String descricao;
  late String incidente;
  late String localizacao;

  Report({required this.id, required this.descricao, required this.incidente, required this.localizacao});

  Report.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        descricao = map["descricao"],
        incidente = map["incidente"],
        localizacao = map["localizacao"];
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "descricao": descricao,
      "incidente": incidente,
      "localizacao": localizacao,
    };
  }
}
