import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthroom_app/model/usuario.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> criarUsuario(Usuario usuario) async {
    try {
      await _db.collection('usuarios').doc(usuario.uid).set({
        'nome': usuario.nome,
        'email': usuario.email,
        'telefone': usuario.telefone,
        'dataNascimento': usuario.dataNascimento,
        'perfil': usuario.perfil.toString(),
      });
    } catch (e) {
      // TODO: implementar tratamento de erro
    }
  }
}
