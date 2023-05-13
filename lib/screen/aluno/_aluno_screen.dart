import 'package:flutter/material.dart';
import 'package:healthroom_app/screen/aluno/contato_screen.dart';
import 'package:healthroom_app/screen/aluno/dashboard_screen.dart';
import 'package:healthroom_app/screen/aluno/perfil_screen.dart';
import 'package:healthroom_app/screen/aluno/treino_screen.dart';
import 'package:healthroom_app/screen/auth/login_screen.dart';
import 'package:healthroom_app/services/auth.dart';
import 'package:healthroom_app/screen/loading_screen.dart';

class AlunoScreen extends StatefulWidget {
  const AlunoScreen({super.key});

  @override
  State<AlunoScreen> createState() => AlunoScreenState();
}

class AlunoScreenState extends State<AlunoScreen> {
  int _navigationIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    TreinoScreen(),
    PerfilScreen(),
    ContatoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
      body: _screens.elementAt(_navigationIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navigationIndex,
        type: BottomNavigationBarType.fixed,
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
        onTap: (index) {
          setState(() {
            _navigationIndex = index;
          });
        },
      ),
    );
  }
}
