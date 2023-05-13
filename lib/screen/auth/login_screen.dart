import 'package:flutter/material.dart';
import 'package:healthroom_app/screen/auth/cadastro_screen.dart';
import 'package:healthroom_app/services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _handleLogin() {
      final email = _emailController.text;
      final senha = _senhaController.text;

      AuthService().login(email, senha);
    }

    void _handleCadastro() {
      // TODO: Implementar route
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CadastroScreen()),
      );
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Senha',
            ),
          ),
          ElevatedButton(
            onPressed: _handleLogin,
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: _handleCadastro,
            child: const Text('Cadastre-se aqui!'),
          ),
        ],
      ),
    );
  }
}
