import 'package:flutter/material.dart';

class ContatoScreen extends StatelessWidget {
  const ContatoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView.builder(
      itemCount: 2,
      itemBuilder: ((context, index) => Card(
            margin: const EdgeInsets.all(8.0),
            shadowColor: Colors.grey[400],
            child: ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Fulano'),
              subtitle: const Text('Instrutor(a)'),
              trailing: const Icon(Icons.chat_bubble),
              onTap: () {},
            ),
          )),
    ));
  }
}
