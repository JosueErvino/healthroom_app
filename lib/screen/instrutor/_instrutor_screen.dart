import 'package:flutter/material.dart';
import 'package:healthroom_app/services/auth.dart';

class InstrutorScreen extends StatelessWidget {
  final String title;

  const InstrutorScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {},
          tooltip: 'Adicionar aluno',
          child: const Icon(Icons.add),
        ));
  }
}
