import 'package:flutter/material.dart';
import 'package:healthroom_app/model/treino.dart';
import 'package:healthroom_app/provider/usuario_provider.dart';
import 'package:healthroom_app/screen/aluno/lista_exercicio_screen.dart';
import 'package:healthroom_app/screen/loading_screen.dart';
import 'package:healthroom_app/services/database.dart';
import 'package:healthroom_app/services/datetime.dart';

class TreinoScreen extends StatelessWidget {
  const TreinoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = UsuarioProvider.getProvider(context);

    handleAbrirTreino(Treino treino) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListaExercicioScreen(treino: treino),
        ),
      ).then((value) {
        if (value == true) DatabaseService().concluirTreino(treino);
      });
    }

    return FutureBuilder<List<Treino>>(
        future: DatabaseService().getTreinosUsuario(usuario.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (snapshot.hasData) {
            final treinos = snapshot.data ?? [];

            return treinos.isEmpty
                ? const Center(
                    child: Text('Nenhum treino cadastrado!'),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: treinos.length,
                    itemBuilder: (context, index) => ListTile(
                        title: Text(treinos[index].descricao),
                        subtitle: Text(
                          getDataUltimaExecucao(treinos[index]),
                        ),
                        trailing: const Icon(Icons.play_arrow),
                        onTap: () => handleAbrirTreino(
                              treinos[index],
                            )),
                  );
          }

          return const Loading();
        });
  }

  String getDataUltimaExecucao(Treino treino) {
    if (treino.ultimaExecucao == null) return '-';

    return DateTimeService().formatarData(treino.ultimaExecucao!.toDate());
  }
}
