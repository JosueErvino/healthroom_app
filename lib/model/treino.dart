import 'package:healthroom_app/model/exercicio.dart';
import 'package:healthroom_app/model/usuario.dart';

class Treino {
  late Usuario usuario;
  late bool ativo;
  late DateTime ultimaExecucao;
  late List<Exercicio> exercicios;
}
