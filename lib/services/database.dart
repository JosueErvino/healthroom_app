import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthroom_app/model/exercicio.dart';
import 'package:healthroom_app/model/perfil.dart';
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

  Future<String> salvarExecucaoExercicio(
    String? idExecucao,
    Treino treino,
    Exercicio exercicio,
  ) async {
    final refTreinosConcluidos = _db.collection('treinos-concluidos');

    String execId;

    DocumentReference<Map<String, dynamic>> execucao;

    if (idExecucao == null) {
      execucao = await refTreinosConcluidos.add({
        'descricao': treino.descricao,
        'dataInicio': FieldValue.serverTimestamp(),
      });
    } else {
      execucao = refTreinosConcluidos.doc(idExecucao);
    }

    execId = execucao.id;

    execucao.update({
      'descricao': treino.descricao,
      'usuario': treino.usuario.uid,
      'dataConclusao': FieldValue.serverTimestamp(),
    });

    execucao.collection('exercicios').doc(exercicio.id).set({
      'descricao': exercicio.descricao,
      'repeticoes': exercicio.repeticoes,
      'carga': exercicio.carga,
      'observacoes': exercicio.observacoes,
      'dataConclusao': FieldValue.serverTimestamp(),
    });

    return execId;
  }

  void concluirTreino(Treino treino) {
    _db.collection('treinos').doc(treino.id).update({
      'ultimaExecucao': FieldValue.serverTimestamp(),
    });
  }

  Future<void> solicitarVinculo(Usuario usuarioAtual, String email) async {
    var ref = _db.collection('usuarios');
    var query = await ref
        .where('email', isEqualTo: email)
        .where('perfil', isEqualTo: Perfil.aluno.toString())
        .get();

    if (query.docs.isEmpty) {
      throw 'Usuário não encontrado';
    }

    var alunoDoc = query.docs.first;
    var refVinculos = _db.collection('solicitacoes');
    var queryVinculos = await refVinculos
        .where('aluno', isEqualTo: alunoDoc.id)
        .where('profissional', isEqualTo: usuarioAtual.uid)
        .get();

    if (queryVinculos.docs.isNotEmpty) {
      throw 'Vínculo já solicitado e pendente de aprovação';
    }

    try {
      await refVinculos.add({
        'aluno': alunoDoc.id,
        'profissional': usuarioAtual.uid,
        'tipo': usuarioAtual.perfil.toString(),
      });
    } catch (e) {
      throw 'Ocorreu um erro inesperado, tente novamente mais tarde';
    }
  }
}
