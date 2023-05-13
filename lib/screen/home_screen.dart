import 'package:flutter/material.dart';
import 'package:healthroom_app/screen/aluno/_aluno_screen.dart';
import 'package:healthroom_app/screen/aluno/contato_screen.dart';
import 'package:healthroom_app/screen/aluno/dashboard_screen.dart';
import 'package:healthroom_app/screen/aluno/perfil_screen.dart';
import 'package:healthroom_app/screen/aluno/treino_screen.dart';
import 'package:healthroom_app/screen/auth/login_screen.dart';
import 'package:healthroom_app/services/auth.dart';
import 'package:healthroom_app/screen/loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

          return const AlunoScreen();
        });
  }
}
