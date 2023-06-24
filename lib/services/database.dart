import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthroom_app/model/contato.dart';
import 'package:healthroom_app/model/exercicio.dart';
import 'package:healthroom_app/model/perfil.dart';
import 'package:healthroom_app/model/solicitacao.dart';
import 'package:healthroom_app/model/treino.dart';
import 'package:healthroom_app/model/usuario.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const _collectionUsuario = 'usuarios';
  static const _collectionVinculos = 'vinculo';
  static const _collectionTreinos = 'treinos';
  static const _collectionExercicios = 'exercicios';

  Future<void> criarUsuario(Usuario usuario) async {
    try {
      await _db.collection(_collectionUsuario).doc(usuario.uid).set({
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
    Usuario usuario = Usuario.fromMap(data ?? {});
    usuario.uid = uid;
    return usuario;
  }

  Future<List<Treino>> getTreinosUsuario(String userID) async {
    var ref = _db.collection(_collectionTreinos);
    var snapshot = ref
        .where(
          'usuario',
          isEqualTo: userID,
        )
        .where(
          'ativo',
          isEqualTo: true,
        );

    var treinos = await snapshot.get();

    return List<Treino>.from(treinos.docs
        .map((doc) => Treino.fromMap(
              doc.data(),
              doc.id,
            ))
        .toList());
  }

  Stream<List<Treino>> streamTreinosUsuario(String userId) {
    return _db
        .collection(_collectionTreinos)
        .where('usuario', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Treino.fromMap(doc.data(), doc.id))
            .toList());
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
        'nomeProfissional': usuarioAtual.nome,
        'tipo': usuarioAtual.perfil.toString(),
      });

      // TODO: Notificar aluno
    } catch (e) {
      throw 'Ocorreu um erro inesperado, tente novamente mais tarde';
    }
  }

  static Stream<QuerySnapshot> getSolicitacoesAlunoStream(Usuario aluno) {
    return FirebaseFirestore.instance
        .collection('solicitacoes')
        .where('aluno', isEqualTo: aluno.uid)
        .snapshots();
  }

  static Future<void> responderSolicitacao(
    Solicitacao solicitacao,
    bool aceita,
  ) async {
    final ref = FirebaseFirestore.instance;

    if (aceita) {
      ref
          .collection('usuarios')
          .doc(solicitacao.idAluno)
          .get()
          .then((snapshot) {
        final aluno = snapshot.data();
        final perfilProfissional = solicitacao.perfilProfissional.toString();

        if (aluno == null) return;
        if (aluno[perfilProfissional] != null) {
          ref
              .collection(_collectionVinculos)
              .doc(aluno[perfilProfissional])
              .set({snapshot.id: false}, SetOptions(merge: true));
        }

        snapshot.reference.update({
          perfilProfissional: solicitacao.idProfissional,
        });

        ref
            .collection(_collectionVinculos)
            .doc(solicitacao.idProfissional)
            .set({snapshot.id: true}, SetOptions(merge: true));
      });
    }

    ref.collection('solicitacoes').doc(solicitacao.id).delete();
  }

  Future<List<Contato>> getContatos(String uid) {
    var ref = _db.collection('usuarios').doc(uid);

    return ref.get().then((value) async {
      var data = value.data();
      if (data == null) return [];

      var contatos = <Contato>[];

      if (data['Instrutor'] != null) {
        final instrutor =
            await _db.collection('usuarios').doc(data['Instrutor']).get();
        contatos.add(Contato(
          nome: instrutor['nome'],
          telefone: instrutor['telefone'],
          tipo: Perfil.instrutor,
        ));
      }

      if (data['Nutricionista'] != null) {
        final nutricionista =
            await _db.collection('usuarios').doc(data['Nutricionista']).get();
        contatos.add(Contato(
          nome: nutricionista['nome'],
          telefone: nutricionista['telefone'],
          tipo: Perfil.nutricionista,
        ));
      }

      return contatos;
    });
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getAlunosVinculados(
      Usuario profissional) {
    return FirebaseFirestore.instance
        .collection(_collectionVinculos)
        .doc(profissional.uid)
        .snapshots();
  }

  Stream<List<Usuario>> getAlunosVinculadosInfo(Map<String, bool> vinculos) {
    vinculos.removeWhere((uid, ativo) => !ativo);

    final listaAlunosUid = vinculos.entries.map((e) => e.key).toList();

    if (listaAlunosUid.isEmpty) return Stream.value([]);

    return _db
        .collection('usuarios')
        .where(FieldPath.documentId, whereIn: listaAlunosUid)
        .snapshots()
        .map((alunos) {
      return alunos.docs.map((e) {
        final user = Usuario.fromMap(e.data());
        user.uid = e.id;
        return user;
      }).toList();
    });
  }

  void atualizarDadosAntropometricos(String uid, double altura, double peso) {
    _db.collection('usuarios').doc(uid).update({
      'altura': altura,
      'peso': peso,
    });
  }

  getStreamTreinoById(String? id) {
    return _db
        .collection(_collectionTreinos)
        .doc(id)
        .collection(_collectionExercicios)
        .snapshots()
        .map(
          (value) => List<Exercicio>.from(
            value.docs.map(
              (e) => Exercicio.fromMap(
                e.data(),
                e.id,
              ),
            ),
          ),
        );
  }

  Future<List<Exercicio>> getExercicios() async {
    return _db.collection(_collectionExercicios).get().then(
          (value) => value.docs
              .map(
                (e) => Exercicio.opcoes(e.data()),
              )
              .toList(),
        );
  }

  void saveExercicio(String? idTreino, Exercicio exercicio) {
    _db
        .collection(_collectionTreinos)
        .doc(idTreino)
        .collection(_collectionExercicios)
        .doc(exercicio.id)
        .set(exercicio.toMap());
  }

  void removeExercicioDoTreino(String? id, Exercicio exercicio) {
    _db
        .collection(_collectionTreinos)
        .doc(id)
        .collection(_collectionExercicios)
        .doc(exercicio.id)
        .delete();
  }

  Future<String> criarTreino(String idUsuario) {
    return _db.collection(_collectionTreinos).add({
      'usuario': idUsuario,
      'descricao': 'Treino ${DateTime.now().toString()}',
      'ativo': true,
    }).then((value) => value.id);
  }

  Future<void> removerTreino(String? idTreino) {
    if (idTreino == null) throw 'Treino não encontrado';

    return _db.collection(_collectionTreinos).doc(idTreino).delete();
  }

  Future<void> saveTreino(String? idTreino, String text) {
    if (idTreino == null) throw 'Treino não encontrado';

    if (text == '') throw 'Descrição não pode ser vazia';

    return _db.collection(_collectionTreinos).doc(idTreino).update({
      'descricao': text,
    });
  }
}
