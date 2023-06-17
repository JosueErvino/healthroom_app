import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthroom_app/model/usuario.dart';
import 'package:healthroom_app/provider/usuario_provider.dart';
import 'package:healthroom_app/screen/loading_screen.dart';
import 'package:healthroom_app/services/auth.dart';
import 'package:healthroom_app/services/database.dart';
import 'package:healthroom_app/services/dialog.dart';

import 'dados_aluno_screen.dart';

class InstrutorScreen extends StatefulWidget {
  final String title;

  const InstrutorScreen({super.key, required this.title});

  @override
  State<InstrutorScreen> createState() => _InstrutorScreenState();
}

class _InstrutorScreenState extends State<InstrutorScreen> {
  @override
  Widget build(BuildContext context) {
    Usuario usuario = UsuarioProvider.getProvider(context);

    void handleSolicitarAluno() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            final TextEditingController emailController =
                TextEditingController();

            return AlertDialog(
              title: const Text('Solicitar aluno'),
              content: TextField(
                decoration: const InputDecoration(
                  label: Text('E-mail do aluno'),
                ),
                style: const TextStyle(fontSize: 12),
                controller: emailController,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancelar'),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    DatabaseService()
                        .solicitarVinculo(usuario, emailController.text)
                        .then((value) => Navigator.pop(context, 'OK'))
                        .catchError(
                          (onError) => DialogService().showAlertDialog(
                            context,
                            const Text('Erro'),
                            onError.toString(),
                          ),
                        );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        endDrawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                child: Center(
                  child: Text(
                    'H E A L T H R O O M',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Sair'),
                onTap: () => AuthService.logout(),
              ),
            ],
          ),
        ),
        body: StreamBuilder(
            stream: DatabaseService.getAlunosVinculados(usuario),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }

              if (snapshot.hasData) {
                return StreamBuilder<List<Usuario>>(
                    stream: DatabaseService().getAlunosVinculadosInfo(
                      converterDocParaMap(snapshot.data),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('${snapshot.error}'),
                        );
                      }

                      if (snapshot.hasData) {
                        final listaAlunos = snapshot.data ?? [];
                        return ListView.builder(
                          itemCount: listaAlunos.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(listaAlunos[index].nome),
                              onTap: () =>
                                  abrirDetalhesAluno(listaAlunos[index]),
                            );
                          },
                        );
                      }

                      return const Loading();
                    });
              }

              return const Loading();
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: handleSolicitarAluno,
          tooltip: 'Adicionar aluno',
          child: const Icon(Icons.add),
        ));
  }

  Map<String, bool> converterDocParaMap(
      DocumentSnapshot<Map<String, dynamic>>? data) {
    if (data == null || data.data() == null) return {};

    Map<String, bool> resultado = {};

    data.data()?.forEach((key, value) {
      if (value is bool) {
        resultado[key] = value;
      }
    });

    return resultado;
  }

  abrirDetalhesAluno(Usuario aluno) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DadosAlunoScreen(
          aluno: aluno,
        ),
      ),
    );
  }
}
