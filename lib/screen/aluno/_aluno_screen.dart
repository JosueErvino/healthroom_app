import 'package:flutter/material.dart';
import 'package:healthroom_app/screen/aluno/contato_screen.dart';
import 'package:healthroom_app/screen/aluno/dashboard_screen.dart';
import 'package:healthroom_app/screen/aluno/perfil_screen.dart';
import 'package:healthroom_app/screen/aluno/treino_screen.dart';
import 'package:healthroom_app/services/auth.dart';

class AlunoScreen extends StatefulWidget {
  const AlunoScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<AlunoScreen> createState() => AlunoScreenState();
}

class AlunoScreenState extends State<AlunoScreen> {
  int _navigationIndex = 0;

  final List<Widget> _screens = const [
    PerfilScreen(),
    TreinoScreen(),
    ContatoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
              onTap: () => AuthService().logout(),
            ),
          ],
        ),
      ),
      body: _screens.elementAt(_navigationIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navigationIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'IMC',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Treinos',
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
