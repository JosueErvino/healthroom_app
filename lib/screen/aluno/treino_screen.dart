import 'package:flutter/material.dart';
import 'package:healthroom_app/model/treino.dart';
import 'package:healthroom_app/provider/usuario_provider.dart';
import 'package:healthroom_app/screen/aluno/lista_exercicio_screen.dart';
import 'package:healthroom_app/screen/loading_screen.dart';
import 'package:healthroom_app/services/database.dart';

class TreinoScreen extends StatelessWidget {
  const TreinoScreen({super.key});

  final List<DataColumn> _columns = const [
    DataColumn(
      label: Text('Treino'),
    ),
    DataColumn(
      label: Text('Dt. Execução'),
    ),
    DataColumn(
      label: Text('Iniciar'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final usuario = UsuarioProvider.getProvider(context);

    handleAbrirTreino(Treino treino) {
      final resultado = Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListaExercicioScreen(treino: treino),
        ),
      );

      resultado.then((concluido) {
        if (concluido != null && concluido) {
          DatabaseService().concluirTreino(treino);
        }
      });
    }

    return FutureBuilder<List<Treino>>(
        future: DatabaseService().getTreinosUsuario(usuario.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.hasData) {
            final treinos = snapshot.data ?? [];

            // TODO: Adicionar titulo da tela
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: treinos.length,
              itemBuilder: (context, index) => ListTile(
                  title: Text(treinos[index].descricao),
                  subtitle: Text(treinos[index].ultimaExecucao != null
                      ? treinos[index].ultimaExecucao.toString()
                      : '-'),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () => handleAbrirTreino(
                        treinos[index],
                      )),
            );
          }

          return const Loading();
        });
  }
}
