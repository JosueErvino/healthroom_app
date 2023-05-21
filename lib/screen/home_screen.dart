import 'package:flutter/material.dart';
import 'package:healthroom_app/model/usuario.dart';
import 'package:healthroom_app/provider/usuario_provider.dart';
import 'package:healthroom_app/screen/aluno/_aluno_screen.dart';
import 'package:healthroom_app/screen/auth/login_screen.dart';
import 'package:healthroom_app/screen/instrutor/_instrutor_screen.dart';
import 'package:healthroom_app/services/auth.dart';
import 'package:healthroom_app/screen/loading_screen.dart';
import 'package:healthroom_app/services/database.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String displayName = 'Health Room';
  String uid = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Ocorreu um erro inesperado'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }

          if (snapshot.hasData) {
            if (snapshot.data?.uid == null) {
              return const LoginScreen();
            }
            displayName = snapshot.data?.displayName ?? 'Health Room';
            uid = snapshot.data?.uid ?? '';
            final Future<Usuario> initialization =
                DatabaseService().getUsuario(uid);

            return FutureBuilder<Usuario>(
                future: initialization,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }

                  if (snapshot.hasData) {
                    UsuarioProvider userProvider =
                        Provider.of<UsuarioProvider>(context, listen: false);
                    userProvider.setUsuario(snapshot.data!, uid);

                    if (userProvider.usuario.isInstrutor()) {
                      return InstrutorScreen(
                        title: displayName,
                      );
                    }

                    return AlunoScreen(
                      title: displayName,
                    );
                  }

                  return const Loading();
                });
          }

          return const LoginScreen();
        });
  }
}
