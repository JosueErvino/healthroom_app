import 'package:flutter/material.dart';
import 'package:healthroom_app/model/treino.dart';
import 'package:healthroom_app/screen/instrutor/treinos_editar_screen.dart';
import 'package:healthroom_app/screen/loading_screen.dart';
import 'package:healthroom_app/services/database.dart';
import 'package:healthroom_app/services/datetime.dart';

class TreinosListaScreen extends StatefulWidget {
  final String nome;
  final String uid;
  const TreinosListaScreen({super.key, required this.nome, required this.uid});

  @override
  State<TreinosListaScreen> createState() => _TreinosListaScreenState();
}

class _TreinosListaScreenState extends State<TreinosListaScreen> {
  @override
  Widget build(BuildContext context) {
    editarTreino(Treino? treino) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return TreinosEditarScreen(
              treino: treino,
              uid: widget.uid,
              nome: widget.nome,
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nome),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => editarTreino(null),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Treino>>(
        future: DatabaseService().getTreinosUsuario(widget.uid),
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

            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: treinos.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(treinos[index].descricao),
                subtitle: Text(
                  "Ultima execução: ${getDataUltimaExecucao(treinos[index])}",
                ),
                trailing: const Icon(Icons.edit),
                onTap: () => editarTreino(treinos[index]),
              ),
            );
          }

          return const Loading();
        },
      ),
    );
  }

  String getDataUltimaExecucao(Treino treino) {
    if (treino.ultimaExecucao == null) return '-';

    return DateTimeService().formatarData(treino.ultimaExecucao!.toDate());
  }
}
