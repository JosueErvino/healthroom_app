import 'package:flutter/material.dart';
import 'package:healthroom_app/model/treino.dart';
import 'package:healthroom_app/provider/usuario_provider.dart';
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

            return SizedBox(
              width: double.infinity,
              child: DataTable(
                columns: _columns,
                rows: treinos
                    .map(
                      (treino) => DataRow(
                        cells: [
                          DataCell(
                            Text(treino.descricao),
                          ),
                          DataCell(
                            Text(treino.ultimaExecucao != null
                                ? treino.ultimaExecucao.toString()
                                : ''),
                          ),
                          DataCell(
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.play_arrow),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            );
          }

          return const Loading();
        });
  }
}
