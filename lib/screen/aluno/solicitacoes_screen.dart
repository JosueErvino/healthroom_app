import 'package:flutter/material.dart';

class SolicitacoesScreen extends StatelessWidget {
  const SolicitacoesScreen({
    super.key,
    this.listaSolicitacoes,
  });

  final List? listaSolicitacoes;

  @override
  Widget build(BuildContext context) {
    final lista = listaSolicitacoes ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitações'),
      ),
      body: ListView.builder(
        itemCount: lista.length,
        itemBuilder: ((context, i) {
          return ListTile(
            title: Text(lista[i]['nomeProfissional']),
            subtitle: Text(lista[i]['tipo']),
          );
        }),
      ),
    );
  }
}
