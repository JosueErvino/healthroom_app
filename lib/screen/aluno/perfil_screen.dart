import 'package:flutter/material.dart';
import 'package:healthroom_app/model/usuario.dart';

class PerfilScreen extends StatelessWidget {
  final Usuario usuario;

  const PerfilScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: Image.asset(
            'assets/img/body.png',
            fit: BoxFit.contain,
          ),
        ),
        Expanded(
          child: Column(
            children: [
              InfoCard(usuario: usuario),
              Card(
                child: Text('Peso:'),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.usuario,
  });

  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text('Altura'),
            Text(usuario.altura.toString()),
          ],
        ),
      ),
    );
  }
}
