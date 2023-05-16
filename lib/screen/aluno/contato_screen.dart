import 'package:flutter/material.dart';

class ContatoScreen extends StatelessWidget {
  const ContatoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.fitness_center),
          title: const Text('Fulano'),
          subtitle: const Text('Instrutor(a)'),
          trailing: const Icon(Icons.chat_bubble),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.apple),
          title: const Text('Ciclano'),
          subtitle: const Text('Nutricionista'),
          trailing: const Icon(Icons.chat_bubble),
          onTap: () {},
        ),
      ],
    );
  }
}
