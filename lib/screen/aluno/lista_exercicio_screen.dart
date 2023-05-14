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
    return FutureBuilder(
        future: DatabaseService().getTreinoById(idTreino),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            Navigator.pop(context);
          }

          if (snapshot.hasData) {
            final exercicios = snapshot.data ?? [];
            return Scaffold(
                appBar: AppBar(
                  title: Text(nomeTreino),
                ),
                body: ListView.separated(
                  itemCount: exercicios.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(exercicios[index].descricao),
                    );
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {},
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
