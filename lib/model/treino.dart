import 'package:healthroom_app/model/exercicio.dart';
import 'package:healthroom_app/model/usuario.dart';

class Treino {
  late String id;
  late Usuario usuario;
  late String descricao;
  late bool ativo;
  late DateTime? ultimaExecucao;
  late List<Exercicio>? exercicios;

  static Treino fromMap(Map<String, dynamic> data, String id) {
    Treino treino = Treino();

    Usuario usuario = Usuario();
    usuario.uid = data['usuario'];
    treino.usuario = usuario;

    treino.id = id;
    treino.descricao = data['descricao'];
    treino.ativo = data['ativo'];
    treino.ultimaExecucao = data['ultimaExecucao'];
    return treino;
  }
}
