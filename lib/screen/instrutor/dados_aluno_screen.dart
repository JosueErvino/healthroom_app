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
      body: Column(
        children: [
          // Avatar
          Container(
            margin: const EdgeInsets.all(10),
            child: const CircleAvatar(
              radius: 50,
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
        ],
      ),
    );
  }
}
