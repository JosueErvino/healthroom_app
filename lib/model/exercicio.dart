class Exercicio {
  late String id;
  late int carga;
  late int repeticoes;
  late int series;
  late String descricao;
  late String corpo;
  late String? observacoes;

  static Exercicio opcoes(Map<String, dynamic> data) {
    Exercicio exercicio = Exercicio();

    exercicio.corpo = data['corpo'];
    exercicio.descricao = data['descricao'];

    return exercicio;
  }

  static Exercicio fromMap(dynamic doc, String? id) {
    Exercicio exercicio = Exercicio();

    exercicio.id = id!;
    exercicio.carga = doc['carga'];
    exercicio.repeticoes = doc['repeticoes'];
    exercicio.series = doc['series'];
    exercicio.descricao = doc['descricao'];
    exercicio.corpo = doc['corpo'];
    exercicio.observacoes = doc['observacoes'];

    return exercicio;
  }

  Map<String, Object?> toMap() {
    return {
      'carga': carga,
      'repeticoes': repeticoes,
      'series': series,
      'descricao': descricao,
      'corpo': corpo,
      'observacoes': observacoes,
    };
  }
}
