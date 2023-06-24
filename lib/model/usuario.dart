import 'package:healthroom_app/model/perfil.dart';
import 'package:healthroom_app/services/datetime.dart';

class Usuario {
  late String uid;
  late String nome;
  late String email;
  late String telefone;
  late String dataNascimento;
  late Perfil perfil;
  late double peso;
  late double altura;

  static Usuario fromMap(Map<String, dynamic> data) {
    if (data.isEmpty) {
      throw 'Usuário não encontrado';
    }
    Usuario usuario = Usuario();
    usuario.nome = data['nome'];
    usuario.email = data['email'];
    usuario.telefone = data['telefone'];
    usuario.dataNascimento = data['dataNascimento'];
    usuario.perfil = Perfil.fromValue(data['perfil']);
    usuario.peso = data['peso'] ?? 0.0;
    usuario.altura = data['altura'] ?? 0.0;
    return usuario;
  }

  bool isInstrutor() {
    return perfil == Perfil.instrutor;
  }

  bool isAluno() {
    return perfil == Perfil.aluno;
  }

  bool dadoPessoalVazio() {
    return nome.isEmpty ||
        email.isEmpty ||
        telefone.isEmpty ||
        dataNascimento.isEmpty;
  }

  bool isDataNascimentoValido() {
    return DateTimeService.validarDataNascimento(dataNascimento);
  }

  bool isTelefoneValido() {
    return telefone.length == 11 && int.tryParse(telefone) != null;
  }
}
