import 'package:flutter/material.dart';
import 'package:healthroom_app/model/exercicio.dart';
import 'package:healthroom_app/model/treino.dart';
import 'package:healthroom_app/model/usuario.dart';
import 'package:healthroom_app/provider/usuario_provider.dart';
import 'package:healthroom_app/screen/instrutor/treinos_exercicio_screen.dart';
import 'package:healthroom_app/screen/loading_screen.dart';
import 'package:healthroom_app/services/database.dart';
import 'package:healthroom_app/services/snackbar.dart';
import 'package:healthroom_app/widget/circular_text.dart';

class TreinosEditarScreen extends StatefulWidget {
  final Treino? treino;
  final String nome;
  final String uid;
  const TreinosEditarScreen({
    super.key,
    required this.treino,
    required this.nome,
    required this.uid,
  });

  @override
  State<TreinosEditarScreen> createState() => _TreinosEditarScreenState();
}

class _TreinosEditarScreenState extends State<TreinosEditarScreen> {
  final TextEditingController _descricaoController = TextEditingController();
  String? idTreino;

  @override
  void initState() {
    super.initState();
    _descricaoController.text = widget.treino?.descricao ?? "";
    idTreino = widget.treino?.id;

    if (widget.treino == null) {
      DatabaseService().criarTreino(widget.uid).then((value) {
        setState(() {
          idTreino = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Usuario usuario = UsuarioProvider.getProvider(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.treino?.descricao ?? "Novo Treino"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    TextField(
                      controller: _descricaoController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do treino',
                      ),
                      enabled: usuario.isInstrutor(),
                    ),
                    const Divider(
                      height: 30,
                    ),
                    TextField(
                      enabled: false,
                      controller: TextEditingController(
                        text: widget.nome,
                      ),
                      decoration: const InputDecoration(labelText: 'Aluno'),
                    ),
                    const Divider(
                      color: Colors.black,
                      height: 30,
                    ),
                    const Text(
                      'Exercícios',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: Builder(builder: (context) {
            return Visibility(
              visible: idTreino != null,
              child: ListaExercicios(
                idTreino: idTreino ?? "",
                usuario: usuario,
              ),
            );
          }),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: usuario.isInstrutor(),
        child: BottomAppBar(
          color: Colors.transparent,
          height: 70,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.check),
                color: Colors.green,
                splashColor: Colors.greenAccent,
                onPressed: _handleSalvar,
              ),
              CircleAvatar(
                backgroundColor: Colors.black87,
                child: IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                  splashColor: Colors.white,
                  onPressed: _handleAdicionarExercicio,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                splashColor: Colors.redAccent,
                onPressed: _handleRemoverTreino,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAdicionarExercicio() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TreinosExercicioScreen(),
      ),
    ).then((value) {
      if (value != null && value['exercicio'] is Exercicio) {
        DatabaseService().saveExercicio(
          idTreino,
          value['exercicio'],
        );
      }
    });
  }

  void _handleSalvar() {
    DatabaseService()
        .saveTreino(
          idTreino,
          _descricaoController.text,
        )
        .then((value) => Navigator.pop(context));
  }

  void _handleRemoverTreino() {
    DatabaseService()
        .removerTreino(idTreino)
        .then((value) => Navigator.pop(context));
  }
}

class ListaExercicios extends StatelessWidget {
  final String idTreino;
  final Usuario usuario;

  const ListaExercicios({
    super.key,
    required this.idTreino,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    bool isInstrutor() => usuario.isInstrutor();

    void handleEditarExercicio(Exercicio exercicio) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TreinosExercicioScreen(
            exercicio: exercicio,
          ),
        ),
      ).then((value) {
        if (value != null && value['exercicio'] is Exercicio) {
          if (value['remove']) {
            DatabaseService().removeExercicioDoTreino(
              idTreino,
              value['exercicio'],
            );
          } else {
            DatabaseService().saveExercicio(
              idTreino,
              value['exercicio'],
            );
          }
        }
      });
    }

    return StreamBuilder<List<Exercicio>>(
        stream: DatabaseService().getStreamTreinoById(idTreino),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            SnackBarService.showSnackbarError(
              context,
              snapshot.error.toString(),
            );
            Navigator.pop(context);
          }

          if (snapshot.hasData) {
            final exercicios = snapshot.data ?? [];

            return exercicios.isEmpty
                ? const Center(
                    child: Text('Nenhum exercício cadastrado!'),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: exercicios.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircularText(
                          text: '${index + 1}',
                        ),
                        trailing: isInstrutor() ? const Icon(Icons.edit) : null,
                        title: Text(exercicios[index].descricao),
                        subtitle: Text(
                          '${exercicios[index].series} séries de ${exercicios[index].repeticoes} repetições - ${exercicios[index].carga} kg',
                        ),
                        onTap: () => isInstrutor()
                            ? handleEditarExercicio(exercicios[index])
                            : null,
                      );
                    },
                  );
          }
          return const Loading();
        });
  }
}
