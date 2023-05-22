import 'package:flutter/material.dart';
import 'package:healthroom_app/model/usuario.dart';
import 'package:healthroom_app/services/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required int notificacao,
    required Usuario usuario,
    List? listaSolicitacoes,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}
