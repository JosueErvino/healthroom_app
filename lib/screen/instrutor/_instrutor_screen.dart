import 'package:flutter/material.dart';
import 'package:healthroom_app/model/usuario.dart';
import 'package:healthroom_app/provider/usuario_provider.dart';
import 'package:healthroom_app/services/auth.dart';
import 'package:healthroom_app/services/database.dart';
import 'package:healthroom_app/services/dialog.dart';

class InstrutorScreen extends StatelessWidget {
  final String title;

  const InstrutorScreen({super.key, required this.title});

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
                                ));
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
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
        body: ListView(),
        floatingActionButton: FloatingActionButton(
          onPressed: handleSolicitarAluno,
          tooltip: 'Adicionar aluno',
          child: const Icon(Icons.add),
        ));
  }
}
