import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthroom_app/model/usuario.dart';
import 'package:healthroom_app/services/database.dart';
import 'package:healthroom_app/services/string.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  static Future login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw 'Email ou senha incorretos.';
      }
      throw 'Ocorreu um erro inesperado, tente novamente mais tarde.';
    }
  }

  static Future cadastrarEmail(
    String email,
    String senha,
    Usuario usuario,
  ) async {
    if (email.isEmpty || senha.isEmpty) throw ('Preencha todos os campos.');

    if (usuario.dadoPessoalVazio()) throw ('Preencha todos os campos.');

    if (!usuario.isDataNascimentoValido()) {
      throw ('Data de nascimento inválida. (dd/mm/aaaa)');
    }

    if (!usuario.isTelefoneValido()) {
      throw ('Telefone inválido. (11 999999999)');
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: senha);

      final user = userCredential.user;
      if (user != null) {
        usuario.uid = user.uid;
        DatabaseService().criarUsuario(usuario);
        user.updateDisplayName(StringService().firstName(usuario.nome));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'A senha é muito fraca.';
      } else if (e.code == 'email-already-in-use') {
        throw 'O email já está em uso.';
      } else if (e.code == 'invalid-email') {
        throw 'O email é inválido.';
      } else {
        throw 'Ocorreu um erro inesperado, tente novamente mais tarde.';
      }
    } catch (e) {
      throw 'Ocorreu um erro inesperado.';
    }
  }

  static Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
