import 'package:healthroom_app/model/perfil.dart';

class Contato {
  final String nome;
  final String telefone;
  final Perfil tipo;

  Contato({
    required this.nome,
    required this.telefone,
    required this.tipo,
  });
}
