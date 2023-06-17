import 'package:flutter/material.dart';
import 'package:healthroom_app/model/usuario.dart';

class DadosAlunoScreen extends StatelessWidget {
  final Usuario aluno;
  const DadosAlunoScreen({super.key, required this.aluno});

  @override
  Widget build(BuildContext context) {
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
