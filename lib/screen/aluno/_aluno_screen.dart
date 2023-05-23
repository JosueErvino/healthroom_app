import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthroom_app/model/usuario.dart';
import 'package:healthroom_app/provider/usuario_provider.dart';
import 'package:healthroom_app/screen/aluno/contato_screen.dart';
import 'package:healthroom_app/screen/aluno/perfil_screen.dart';
import 'package:healthroom_app/screen/aluno/treino_screen.dart';
import 'package:healthroom_app/services/database.dart';
import 'package:healthroom_app/widget/app_badge.dart';
import 'package:healthroom_app/widget/app_drawer.dart';

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
  int _solicitacoes = 0;
  List _listSoliciacoes = [];

  final List<Widget> _screens = const [
    PerfilScreen(),
    TreinoScreen(),
    ContatoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    Usuario usuario = UsuarioProvider.getProvider(context);

    return StreamBuilder<QuerySnapshot>(
        stream: DatabaseService.getSolicitacoesAlunoStream(usuario),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data?.docs ?? [];
            _solicitacoes = docs.length;
            _listSoliciacoes = docs;
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Stack(children: [
                      const Icon(Icons.menu),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: _solicitacoes == 0
                            ? Container()
                            : AppBadge(value: _solicitacoes),
                      ),
                    ]),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                ),
              ],
            ),
            endDrawer: AppDrawer(
              notificacao: _solicitacoes,
              usuario: usuario,
              listaSolicitacoes: _listSoliciacoes,
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
        });
  }
}
