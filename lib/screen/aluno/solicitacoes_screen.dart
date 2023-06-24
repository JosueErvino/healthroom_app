import 'package:flutter/material.dart';
import 'package:healthroom_app/model/solicitacao.dart';
import 'package:healthroom_app/services/database.dart';
import 'package:healthroom_app/services/snackbar.dart';

class SolicitacoesScreen extends StatefulWidget {
  const SolicitacoesScreen({
    super.key,
    this.listaSolicitacoes,
  });

  final List? listaSolicitacoes;

  @override
  State<SolicitacoesScreen> createState() => _SolicitacoesScreenState();
}

class _SolicitacoesScreenState extends State<SolicitacoesScreen> {
  late List lista;

  @override
  void initState() {
    super.initState();
    lista = widget.listaSolicitacoes ?? [];
  }

  void _responderSolicitacao(int index, Solicitacao s, bool resposta) {
    DatabaseService.responderSolicitacao(s, resposta).then((_) {
      setState(() => lista.removeAt(index));
    }).catchError((onError) {
      SnackBarService.showSnackbarError(
        context,
        onError.toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitações'),
      ),
      body: lista.isEmpty
          ? const Center(
              child: Text('Nenhuma solicitação em aberto!'),
            )
          : ListView.builder(
              itemCount: lista.length,
              itemBuilder: ((context, i) {
                Solicitacao solicitacao = Solicitacao.fromMap(
                  lista[i].data(),
                  lista[i].id,
                );
                return ListTile(
                  title: Text(solicitacao.nomeProfissional),
                  subtitle: Text(solicitacao.perfilProfissional.toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.check),
                          color: Colors.white,
                          onPressed: () => _responderSolicitacao(
                            i,
                            solicitacao,
                            true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.white,
                          onPressed: () => _responderSolicitacao(
                            i,
                            solicitacao,
                            false,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
    );
  }
}
