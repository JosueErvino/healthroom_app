import 'package:flutter/material.dart';
import 'package:healthroom_app/model/perfil.dart';
import 'package:healthroom_app/model/usuario.dart';
import 'package:healthroom_app/services/auth.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();

  Perfil _perfil = Perfil.aluno;

  @override
  Widget build(BuildContext context) {
    void handleBack() {
      Navigator.pop(context);
    }

    void handleCadastro() {
      Usuario usuario = Usuario();
      usuario.email = _emailController.text;
      usuario.nome = _nomeController.text;
      usuario.telefone = _telefoneController.text;
      usuario.dataNascimento = _dataNascimentoController.text;
      usuario.perfil = _perfil;

      AuthService()
          .cadastrarEmail(_emailController.text, _senhaController.text, usuario)
          .then((value) => handleBack());
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _nomeController,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            decoration: const InputDecoration(
              labelText: 'Nome',
            ),
          ),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            decoration: const InputDecoration(
              labelText: 'E-mail',
            ),
          ),
          TextField(
            controller: _senhaController,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Senha',
            ),
          ),
          TextField(
            controller: _telefoneController,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Telefone',
              hintText: '(00) 00000-0000',
            ),
          ),
          TextField(
            controller: _dataNascimentoController,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            keyboardType: TextInputType.datetime,
            decoration: const InputDecoration(
              labelText: 'Data de Nascimento',
              hintText: 'dd/mm/yyyy',
            ),
          ),
          DropdownButton(
            value: _perfil,
            hint: const Text('Selecione o perfil'),
            items: const [
              DropdownMenuItem(
                value: Perfil.aluno,
                child: Text('Aluno'),
              ),
              DropdownMenuItem(
                value: Perfil.instrutor,
                child: Text('Instrutor'),
              ),
              DropdownMenuItem(
                value: Perfil.nutricionista,
                child: Text('Nutricionista'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _perfil = value!;
              });
            },
          ),
          ElevatedButton(
            onPressed: handleCadastro,
            child: const Text('Cadastrar'),
          ),
          TextButton(
            onPressed: handleBack,
            child: const Text('Já possui conta? Faça o login!'),
          ),
        ],
      ),
    );
  }
}
