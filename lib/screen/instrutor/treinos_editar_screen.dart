import 'package:flutter/material.dart';
import 'package:healthroom_app/model/exercicio.dart';
import 'package:healthroom_app/model/treino.dart';
import 'package:healthroom_app/screen/loading_screen.dart';
import 'package:healthroom_app/services/database.dart';
import 'package:healthroom_app/widget/circular_text.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView(
          children: [
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Nome do treino'),
            ),
            const SizedBox(height: 10),
            TextField(
              enabled: false,
              controller: TextEditingController(
                text: widget.nome,
              ),
              decoration: const InputDecoration(labelText: 'Aluno'),
            ),
            const Divider(
              color: Colors.black,
              height: 30,
            ),
            const Text(
              'Exercícios',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListaExercicios(
              treino: widget.treino,
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

class ListaExercicios extends StatelessWidget {
  final Treino? treino;
  const ListaExercicios({
    super.key,
    required this.treino,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Exercicio>>(
        stream: DatabaseService().getStreamTreinoById(treino?.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Navigator.pop(context);
          }

          if (snapshot.hasData) {
            final exercicios = snapshot.data ?? [];

            return ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: exercicios.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircularText(
                    text: '${index + 1}',
                  ),
                  trailing: const Icon(Icons.edit),
                  title: Text(exercicios[index].descricao),
                  subtitle: Text(
                    '${exercicios[index].repeticoes} repetições de ${exercicios[index].series} - ${exercicios[index].carga} kg',
                  ),
                  onTap: () => {},
                );
              },
            );
          }
          return const Loading();
        });
  }
}
