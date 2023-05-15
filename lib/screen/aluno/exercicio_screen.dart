import 'package:flutter/material.dart';
import 'package:healthroom_app/model/exercicio.dart';

class ExercicioScreen extends StatelessWidget {
  const ExercicioScreen({super.key, required this.exercicio});

  final Exercicio exercicio;

  @override
  Widget build(BuildContext context) {
    void handleConcluirExercicio() {
      Navigator.pop(context, true);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercício'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.fitness_center_sharp,
              size: 100,
            ),
          ),
          ListTile(
            title: Text(exercicio.descricao),
            subtitle: Text(exercicio.observacoes ?? ''),
          ),
          ListTile(
            title: const Text('Séries'),
            subtitle: Text(exercicio.series.toString()),
          ),
          ListTile(
            title: const Text('Repetições'),
            subtitle: Text(exercicio.repeticoes.toString()),
          ),
          ListTile(
            title: const Text('Carga'),
            subtitle: Text(exercicio.carga.toString()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: handleConcluirExercicio,
        child: const Icon(Icons.check, color: Colors.black),
      ),
    );
  }
}
