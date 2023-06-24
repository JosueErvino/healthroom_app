import 'package:flutter/material.dart';
import 'package:healthroom_app/model/exercicio.dart';
import 'package:healthroom_app/model/treino.dart';
import 'package:healthroom_app/screen/aluno/exercicio_screen.dart';
import 'package:healthroom_app/screen/loading_screen.dart';
import 'package:healthroom_app/services/database.dart';
import 'package:healthroom_app/services/snackbar.dart';
import 'package:healthroom_app/widget/circular_text.dart';

class ListaExercicioScreen extends StatefulWidget {
  final Treino treino;

  const ListaExercicioScreen({
    super.key,
    required this.treino,
  });

  @override
  State<ListaExercicioScreen> createState() => _ListaExercicioScreenState();
}

class _ListaExercicioScreenState extends State<ListaExercicioScreen> {
  String? execId;
  List<Exercicio> exerciciosConcluidos = [];

  @override
  Widget build(BuildContext context) {
    Future<void> handleEncerrarTreino() async {
      final result = await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Encerrar Treino'),
                content: const Text('Deseja finalizar o treino em progresso?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'Não',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Sim',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ));

      if (result != null && result) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context, exerciciosConcluidos.isNotEmpty);
      }
    }

    void handleOpenExercicio(Exercicio exercicio) {
      final resultado = Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExercicioScreen(exercicio: exercicio)));

      resultado.then((concluido) async {
        if (concluido) {
          execId = await DatabaseService().salvarExecucaoExercicio(
            execId,
            widget.treino,
            exercicio,
          );
          setState(() {
            exerciciosConcluidos.add(exercicio);
          });
        }
      });
    }

    return FutureBuilder(
        future: DatabaseService().getTreinoById(widget.treino.id),
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

            return Scaffold(
                appBar: AppBar(
                  title: Text(widget.treino.descricao),
                ),
                body: exercicios.isEmpty
                    ? const Center(
                        child: Text('Nenhum exercício cadastrado!'),
                      )
                    : ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: exercicios.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
                              !isExercicioConcluido(exercicios[index])
                                  ? Icons.fitness_center
                                  : Icons.check,
                            ),
                            trailing: CircularText(
                              text: '${exercicios[index].carga} kg',
                            ),
                            title: Text(exercicios[index].descricao),
                            subtitle: Text(
                              '${exercicios[index].repeticoes} x ${exercicios[index].series} - ${exercicios[index].carga} kg',
                            ),
                            onTap: () => handleOpenExercicio(exercicios[index]),
                            enabled: !isExercicioConcluido(exercicios[index]),
                          );
                        },
                      ),
                floatingActionButton: FloatingActionButton(
                  onPressed: handleEncerrarTreino,
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                  ),
                ));
          }
          return const Loading();
        });
  }

  bool isExercicioConcluido(Exercicio exercicio) {
    var result = false;
    exerciciosConcluidos.forEach((element) {
      if (element.id == exercicio.id) {
        result = true;
      }
    });
    return result;
  }
}
