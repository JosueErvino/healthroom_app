import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  Future login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Nenhum usuário encontrado para esse email.';
      } else if (e.code == 'wrong-password') {
        return 'Senha incorreta.';
      }
    }
  }

  // Future cadastrarEmail(String email, String senha, Usuario usuario) async {
  //   try {
  //     final userCredential = await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(email: email, password: senha);

  //     final user = userCredential.user;
  //     if (user != null) {
  //       usuario.uid = user.uid;
  //       DatabaseService().criarUsuario(usuario);
  //       user.updateDisplayName(StringService().firstName(usuario.nome));
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       return 'A senha é muito fraca.';
  //     } else if (e.code == 'email-already-in-use') {
  //       return 'O email já está em uso.';
  //     }
  //   } catch (e) {
  //     return 'Ocorreu um erro inesperado.';
  //   }
  // }

  Future logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // TODO
    }
  }
}
