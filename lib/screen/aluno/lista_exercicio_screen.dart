import 'package:flutter/material.dart';
import 'package:healthroom_app/screen/loading_screen.dart';
import 'package:healthroom_app/services/database.dart';

class ListaExercicioScreen extends StatelessWidget {
  final String idTreino;
  final String nomeTreino;

  const ListaExercicioScreen({
    super.key,
    required this.idTreino,
    required this.nomeTreino,
  });

  @override
  Widget build(BuildContext context) {
    void handleEncerrarTreino() {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Encerrar Treino'),
                content: const Text('Deseja finalizar o treino?'),
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
    }

    return FutureBuilder(
        future: DatabaseService().getTreinoById(idTreino),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Navigator.pop(context);
          }

          if (snapshot.hasData) {
            final exercicios = snapshot.data ?? [];
            return Scaffold(
                appBar: AppBar(
                  title: Text(nomeTreino),
                ),
                body: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: exercicios.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(
                        Icons.fitness_center,
                      ),
                      trailing: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 2),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: Center(
                          child: Text(
                            '${exercicios[index].carga} kg',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ),

                      title: Text(exercicios[index].descricao),
                      subtitle: Text(
                          '${exercicios[index].repeticoes} x ${exercicios[index].series} - ${exercicios[index].carga} kg'),
                      // onTap: ,
                      // enabled: //if o exercicio foi executado
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
}
