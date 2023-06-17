import 'package:flutter/material.dart';

class ImcAlunoScreen extends StatefulWidget {
  final double altura;
  final double peso;
  final String nome;

  const ImcAlunoScreen({
    super.key,
    required this.altura,
    required this.peso,
    required this.nome,
  });

  @override
  State<ImcAlunoScreen> createState() => _ImcAlunoScreenState();
}

class _ImcAlunoScreenState extends State<ImcAlunoScreen> {
  late double? newAltura;
  late double? newPeso;

  @override
  void initState() {
    super.initState();
    newAltura = widget.altura;
    newPeso = widget.peso;
  }

  double _calculoImc(double? peso, double? altura) {
    if (peso == null || altura == null || altura == 0) {
      return 0;
    }
    return peso / (altura * altura);
  }

  editarAltura() {
    showDialog(
      context: context,
      builder: (context) {
        final alturaController = TextEditingController(
          text: newAltura.toString(),
        );
        return AlertDialog(
          title: const Text('Alterar altura'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: alturaController,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  newAltura = double.parse(alturaController.text);
                });
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  editarPeso() {
    showDialog(
      context: context,
      builder: (context) {
        final pesoController = TextEditingController(
          text: newPeso.toString(),
        );
        return AlertDialog(
          title: const Text('Alterar peso'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: pesoController,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  newPeso = double.parse(pesoController.text);
                });
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  // Do something on Navigator.pop

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.nome),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, {
                'altura': newAltura,
                'peso': newPeso,
              });
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Row(
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
                    value: _calculoImc(newPeso, newAltura),
                    medida: '',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InfoCard(
                    label: 'Altura',
                    value: newAltura,
                    medida: 'm',
                    onTap: () => editarAltura(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InfoCard(
                    label: 'Peso',
                    value: newPeso,
                    medida: 'kg',
                    onTap: () => editarPeso(),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class InfoCard extends StatelessWidget {
  final String label;
  final double? value;
  final String medida;
  final Function()? onTap;

  const InfoCard({
    super.key,
    required this.label,
    required this.value,
    required this.medida,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Card(
        color: Colors.green[200],
        elevation: onTap != null ? 8 : 0,
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
      ),
    );
  }
}
