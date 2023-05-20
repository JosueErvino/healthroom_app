import 'package:flutter/material.dart';
import 'package:healthroom_app/model/usuario.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

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
            children: const [
              InfoCard(peso: 88, altura: 1.88),
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
    required this.peso,
    required this.altura,
  });

  final double? peso;
  final double? altura;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            Text('Altura'),
            // Text(altura.toString()),
          ],
        ),
      ),
    );
  }
}
