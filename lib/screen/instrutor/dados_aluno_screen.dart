import 'package:flutter/material.dart';

class DadosAlunoScreen extends StatelessWidget {
  const DadosAlunoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados do aluno'),
      ),
      body: const Center(
        child: Text('Dados do aluno'),
      ),
    );
  }
}
