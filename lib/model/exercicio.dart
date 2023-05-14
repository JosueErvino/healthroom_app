class Exercicio {
  late int carga;
  late int repeticoes;
  late int series;
  late String descricao;
  late String corpo;
  late String observacoes;

  static Exercicio fromMap(dynamic doc) {
    Exercicio exercicio = Exercicio();

    exercicio.carga = doc['carga'];
    exercicio.repeticoes = doc['repeticoes'];
    exercicio.series = doc['series'];
    exercicio.descricao = doc['descricao'];
    exercicio.corpo = doc['corpo'];
    exercicio.observacoes = doc['observacoes'];

    return exercicio;
  }
}
