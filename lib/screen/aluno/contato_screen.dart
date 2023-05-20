import 'package:flutter/material.dart';
import 'package:healthroom_app/services/whatsapp.dart';

class ContatoScreen extends StatelessWidget {
  const ContatoScreen({super.key});

  void _abrirWhatsapp(String telefone) {
    WhatsappService.abrirConversa(telefone);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          margin: const EdgeInsets.all(8.0),
          shadowColor: Colors.grey[400],
          child: ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('Fulano'),
            subtitle: const Text('Instrutor(a)'),
            trailing: const Icon(Icons.chat_bubble),
            onTap: () => _abrirWhatsapp('5511999999999'),
          ),
        ),
        Card(
          margin: const EdgeInsets.all(8.0),
          shadowColor: Colors.grey[400],
          child: ListTile(
            leading: const Icon(Icons.apple),
            title: const Text('Fulano'),
            subtitle: const Text('Nutricionista'),
            trailing: const Icon(Icons.chat_bubble),
            onTap: () => _abrirWhatsapp('5511999999999'),
          ),
        )
      ],
    );
  }
}
