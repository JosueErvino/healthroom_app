import 'package:flutter/material.dart';
import 'package:healthroom_app/model/exercicio.dart';
import 'package:healthroom_app/screen/loading_screen.dart';
import 'package:healthroom_app/services/database.dart';
import 'package:healthroom_app/services/dialog.dart';
import 'package:healthroom_app/services/snackbar.dart';

class TreinosExercicioScreen extends StatefulWidget {
  final Exercicio? exercicio;
  const TreinosExercicioScreen({super.key, this.exercicio});

  @override
  State<TreinosExercicioScreen> createState() => _TreinosExercicioScreenState();
}

class _TreinosExercicioScreenState extends State<TreinosExercicioScreen> {
  Exercicio? exercicio;
  Exercicio? exercicioAuxiliar;

  final _cargaController = TextEditingController();
  final _repeticoesController = TextEditingController();
  final _serieController = TextEditingController();
  final _observacaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    exercicio = widget.exercicio;

    if (exercicio != null) {
      _cargaController.text = exercicio!.carga.toString();
      _repeticoesController.text = exercicio!.repeticoes.toString();
      _serieController.text = exercicio!.series.toString();
      _observacaoController.text = exercicio!.observacoes ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    void handleSave() {
      if (exercicio == null) {
        return;
      }

      exercicio!.carga = int.tryParse(_cargaController.text) ?? 0;
      exercicio!.repeticoes = int.tryParse(_repeticoesController.text) ?? 0;
      exercicio!.series = int.tryParse(_serieController.text) ?? 0;
      exercicio!.observacoes = _observacaoController.text;

      Navigator.pop(context, {'exercicio': exercicio});
    }

    void handleRemove() {
      if (exercicio == null) {
        return;
      }

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Remover exercício'),
              content: const Text('Deseja remover o exercício?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Remover'),
                ),
              ],
            );
          }).then(
        (value) {
          if (value) {
            Navigator.pop(context, {'exercicio': exercicio, 'remove': true});
          }
        },
      );
    }

    if (exercicio == null) {
      List<Exercicio> exerciciosDisponiveis = [];

      return Scaffold(
        appBar: AppBar(
          title: const Text('Selecionar Exercício'),
          leading: widget.exercicio == null
              ? IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                )
              : IconButton(
                  onPressed: () => setState(() {
                    exercicio = exercicioAuxiliar;
                    exercicioAuxiliar = null;
                  }),
                  icon: const Icon(Icons.arrow_back),
                ),
        ),
        body: FutureBuilder<List<Exercicio>>(
          future: DatabaseService().getExercicios(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            }

            if (snapshot.hasError) {
              SnackBarService.showSnackbarError(
                context,
                snapshot.error.toString(),
              );
              Navigator.pop(context);
            }

            if (snapshot.hasData) {
              exerciciosDisponiveis = snapshot.data ?? [];
            }

            return ListView.builder(
              itemCount: exerciciosDisponiveis.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.fitness_center),
                  title: Text(exerciciosDisponiveis[index].descricao),
                  subtitle: Text(exerciciosDisponiveis[index].corpo),
                  onTap: () {
                    setState(
                      () => {
                        if (exercicioAuxiliar != null)
                          {
                            exercicioAuxiliar?.descricao =
                                exerciciosDisponiveis[index].descricao,
                            exercicioAuxiliar?.corpo =
                                exerciciosDisponiveis[index].corpo,
                            exercicio = exercicioAuxiliar,
                            exercicioAuxiliar = null,
                          }
                        else
                          {
                            exercicio = exerciciosDisponiveis[index],
                          }
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Exercício'),
      ),
      floatingActionButton: Visibility(
        visible: exercicio != null,
        child: FloatingActionButton(
          onPressed: handleSave,
          child: const Icon(Icons.check),
        ),
      ),
      body: ListView(
        children: [
          Visibility(
            visible: exercicio != null,
            child: ListTile(
              title: Text(exercicio?.descricao ?? ''),
              subtitle: Text(exercicio?.corpo ?? ''),
              trailing: CircleAvatar(
                backgroundColor: Colors.green,
                child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      exercicioAuxiliar = exercicio;
                      exercicio = null;
                    });
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
            ),
          ),
          Visibility(
            visible: exercicio != null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: _serieController,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Séries'),
                        ),
                      ),
                      // Space
                      const SizedBox(width: 10),
                      Flexible(
                        child: TextField(
                          controller: _repeticoesController,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Repetições'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: TextField(
                          controller: _cargaController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Carga'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _observacaoController,
                    keyboardType: TextInputType.text,
                    minLines: 3,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Observações',
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: handleRemove,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Excluir'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
