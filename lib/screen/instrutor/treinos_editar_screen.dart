import 'package:flutter/material.dart';
import 'package:healthroom_app/model/treino.dart';

class TreinosEditarScreen extends StatefulWidget {
  final Treino? treino;
  final String nome;
  final String uid;
  const TreinosEditarScreen({
    super.key,
    required this.treino,
    required this.nome,
    required this.uid,
  });

  @override
  State<TreinosEditarScreen> createState() => _TreinosEditarScreenState();
}

class _TreinosEditarScreenState extends State<TreinosEditarScreen> {
  final TextEditingController _descricaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descricaoController.text = widget.treino?.descricao ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.treino?.descricao ?? "Novo Treino"),
      ),
      body: Center(
        child: ListView(
          children: [
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Nome do treino'),
            ),
            TextField(
              enabled: false,
              controller: TextEditingController(
                text: widget.nome,
              ),
              decoration: const InputDecoration(labelText: 'Aluno'),
            ),
            const Divider(
              color: Colors.black,
            ),
            const SizedBox(height: 20),
            const Text(
              'Exercícios',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        height: 70,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.check),
              color: Colors.green,
              splashColor: Colors.greenAccent,
              onPressed: () {},
            ),
            CircleAvatar(
              backgroundColor: Colors.black87,
              child: IconButton(
                icon: const Icon(Icons.add),
                color: Colors.white,
                splashColor: Colors.white,
                onPressed: () {},
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              splashColor: Colors.redAccent,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
