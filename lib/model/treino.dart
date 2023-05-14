import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthroom_app/model/exercicio.dart';
import 'package:healthroom_app/model/usuario.dart';

class Treino {
  late Usuario usuario;
  late String descricao;
  late bool ativo;
  late DateTime? ultimaExecucao;
  late int? totalExercicios;
  late List<Exercicio> exercicios;

  static Treino fromMap(Map<String, dynamic> data,
      [List<QueryDocumentSnapshot<Map<String, dynamic>>>? listaExercicios]) {
    Treino treino = Treino();

    Usuario usuario = Usuario();
    usuario.uid = data['usuario'];
    treino.usuario = usuario;

    treino.descricao = data['descricao'];
    treino.ativo = data['ativo'];
    treino.ultimaExecucao = data['ultimaExecucao'];

    if (listaExercicios == null) {
      treino.exercicios = [];
      return treino;
    }

    treino.exercicios = listaExercicios
        .map((exercicio) => Exercicio.fromMap(exercicio.data()))
        .toList();
    return treino;
  }
}
