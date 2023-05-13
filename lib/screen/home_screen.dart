import 'package:flutter/material.dart';
import 'package:healthroom_app/screen/auth/login_screen.dart';
import 'package:healthroom_app/services/auth.dart';
import 'package:healthroom_app/screen/loading_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

          return Scaffold(
              appBar: AppBar(
                title: const Text('Health Room'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => AuthService().logout(),
                  ),
                ],
              ),
              body: const Center(
                child: Text(
                  'Aluno',
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.fitness_center),
                    label: 'Treinos',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Perfil',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble),
                    label: 'Chat',
                  ),
                ],
                showSelectedLabels: false,
                showUnselectedLabels: false,
              ));
        });
  }
}
