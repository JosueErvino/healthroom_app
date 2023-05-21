import 'package:healthroom_app/model/perfil.dart';

class Usuario {
  late String uid;
  late String nome;
  late String email;
  late String telefone;
  late String dataNascimento;
  late Perfil perfil;
  late double peso;
  late double altura;

  static Future<Usuario> fromMap(Map<String, dynamic> data) {
    if (data.isEmpty) {
      return Future.error('Usuário não encontrado');
    }
    Usuario usuario = Usuario();
    usuario.nome = data['nome'];
    usuario.email = data['email'];
    usuario.telefone = data['telefone'];
    usuario.dataNascimento = data['dataNascimento'];
    usuario.perfil = Perfil.fromValue(data['perfil']);
    usuario.peso = data['peso'] ?? 0.0;
    usuario.altura = data['altura'] ?? 0.0;
    return Future.value(usuario);
  }

  bool isInstrutor() {
    return perfil == Perfil.instrutor;
  }
}
