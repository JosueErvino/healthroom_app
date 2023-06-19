import 'package:flutter/material.dart';
import 'package:healthroom_app/model/usuario.dart';
import 'package:healthroom_app/screen/instrutor/imc_aluno_screen.dart';
import 'package:healthroom_app/services/database.dart';

import 'treinos_lista_screen.dart';

class DadosAlunoScreen extends StatefulWidget {
  final Usuario info;
  const DadosAlunoScreen({super.key, required this.info});

  @override
  State<DadosAlunoScreen> createState() => _DadosAlunoScreenState();
}

class _DadosAlunoScreenState extends State<DadosAlunoScreen> {
  late Usuario aluno;
  @override
  void initState() {
    super.initState();
    aluno = widget.info;
  }

  @override
  Widget build(BuildContext context) {
    goToDadosAntropometricos(Usuario aluno) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImcAlunoScreen(
            nome: aluno.nome,
            peso: aluno.peso,
            altura: aluno.altura,
          ),
        ),
      ).then((info) {
        if (info["altura"] != aluno.altura || info["peso"] != aluno.peso) {
          DatabaseService().atualizarDadosAntropometricos(
            aluno.uid,
            info["altura"],
            info["peso"],
          );
          setState(() {
            aluno.altura = info["altura"];
            aluno.peso = info["peso"];
          });
        }
      });
    }

    goToListaDeTreinos(Usuario aluno) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TreinosListaScreen(
            nome: aluno.nome,
            uid: aluno.uid,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(aluno.nome),
      ),
      // show profile of aluno
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Title(title: "Dados do Aluno"),
            // Avatar
            Container(
              margin: const EdgeInsets.all(10),
              child: const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 50,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            // Nome
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                aluno.nome,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            // E-mail
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                aluno.email,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            // Telefone
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                aluno.telefone,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.accessibility),
                  title: const Text("Dados Antropométricos"),
                  onTap: () => goToDadosAntropometricos(aluno),
                ),
                ListTile(
                  leading: const Icon(Icons.fitness_center),
                  title: const Text("Treinos"),
                  onTap: () => goToListaDeTreinos(aluno),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  final String title;

  const Title({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}
