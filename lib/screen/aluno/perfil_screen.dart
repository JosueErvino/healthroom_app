import 'package:flutter/material.dart';
import 'package:healthroom_app/model/usuario.dart';
import 'package:healthroom_app/provider/usuario_provider.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  double _calculoImc(double? peso, double? altura) {
    if (peso == null || altura == null || altura == 0) {
      return 0;
    }
    return peso / (altura * altura);
  }

  @override
  Widget build(BuildContext context) {
    final Usuario usuario = UsuarioProvider.getProvider(context);

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Image.asset(
            'assets/img/body.png',
            fit: BoxFit.contain,
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InfoCard(
                label: 'IMC',
                value: _calculoImc(usuario.peso, usuario.altura),
                medida: '',
              ),
              const SizedBox(
                height: 10,
              ),
              InfoCard(
                label: 'Altura',
                value: usuario.altura,
                medida: 'm',
              ),
              const SizedBox(
                height: 10,
              ),
              InfoCard(
                label: 'Peso',
                value: usuario.peso,
                medida: 'kg',
              ),
            ],
          ),
        )
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String label;
  final double? value;
  final String medida;

  const InfoCard({
    super.key,
    required this.label,
    required this.value,
    required this.medida,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                (value?.toStringAsPrecision(3) ?? '-') + medida,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
