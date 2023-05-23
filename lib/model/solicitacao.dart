import 'package:healthroom_app/model/perfil.dart';

class Solicitacao {
  late String id;
  late String idAluno;
  late String idProfissional;
  late String nomeProfissional;
  late Perfil perfilProfissional;

  static Solicitacao fromMap(Map<String, dynamic> map, String id) {
    Solicitacao solicitacao = Solicitacao();

    solicitacao.id = id;
    solicitacao.idAluno = map['aluno'];
    solicitacao.idProfissional = map['profissional'];
    solicitacao.nomeProfissional = map['nomeProfissional'];
    solicitacao.perfilProfissional = Perfil.fromValue(map['perfil']);

    return solicitacao;
  }
}
