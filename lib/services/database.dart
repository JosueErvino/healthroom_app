import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthroom_app/model/exercicio.dart';
import 'package:healthroom_app/model/treino.dart';
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

  Future<Usuario> getUsuario(String uid) async {
    var ref = _db.collection('usuarios').doc(uid);
    var snapshot = await ref.get();
    var data = snapshot.data();
    Usuario usuario = await Usuario.fromMap(data ?? {});
    usuario.uid = uid;
    return usuario;
  }

  Future<List<Treino>> getTreinosUsuario(String userID) async {
    var ref = _db.collection('treinos');
    var snapshot = ref.where('usuario', isEqualTo: userID);

    var treinos = await snapshot.get();

    return List<Treino>.from(
        treinos.docs.map((doc) => Treino.fromMap(doc.data(), doc.id)).toList());
  }

  Future<List<Exercicio>> getTreinoById(String id) {
    var ref = _db.collection('treinos').doc(id).collection('exercicios');

    return ref.get().then((value) => List<Exercicio>.from(value.docs
        .map((doc) => Exercicio.fromMap(doc.data(), doc.id))
        .toList()));
  }
}
