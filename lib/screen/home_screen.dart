import 'package:flutter/material.dart';
import 'package:healthroom_app/model/usuario.dart';
import 'package:healthroom_app/provider/usuario_provider.dart';
import 'package:healthroom_app/screen/aluno/_aluno_screen.dart';
import 'package:healthroom_app/screen/auth/login_screen.dart';
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

          if (!snapshot.hasData) {
            return const LoginScreen();
          }

          displayName = snapshot.data?.displayName ?? 'Health Room';
          uid = snapshot.data?.uid ?? '';
          return FutureBuilder<Usuario>(
              future: DatabaseService().getUsuario(uid).then((value) {
                UsuarioProvider userProvider =
                    Provider.of<UsuarioProvider>(context, listen: false);
                userProvider.setUsuario(value, uid);

                return userProvider.usuario;
              }),
              builder: (context, snapshot) {
                return AlunoScreen(
                  title: displayName,
                );
              });
        });
  }
}
