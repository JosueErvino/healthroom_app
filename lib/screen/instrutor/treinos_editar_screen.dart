import 'package:flutter/material.dart';
import 'package:healthroom_app/model/treino.dart';

class TreinosEditarScreen extends StatefulWidget {
  final Treino? treino;
  const TreinosEditarScreen({super.key, required this.treino});

  @override
  State<TreinosEditarScreen> createState() => _TreinosEditarScreenState();
}

class _TreinosEditarScreenState extends State<TreinosEditarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.treino?.descricao ?? "Novo Treino"),
      ),
      body: const Center(
        child: Text("Editar treino"),
      ),
    );
  }
}
